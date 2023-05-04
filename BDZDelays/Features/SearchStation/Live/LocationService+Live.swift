//
//  LocationService+Live.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 2.05.23.
//

import Foundation
import Dependencies
import CoreLocation

private let coordTolerance = 0.001
private let authorizedStatuses: [CLAuthorizationStatus] = [.authorizedAlways, .authorizedWhenInUse]

extension LocationService: DependencyKey {
    static let liveValue: Self = {
        return Self(
            statusStream: {
                let stream = await LocationManagerActor.shared.status
                return stream.map {
                    (authStatus, locationMaybe) -> SearchStationReducer.State.LocationStatus in
                    
                    switch authStatus {
                    case .notDetermined:
                        return .notYetAskedForAuthorization
                    case .denied:
                        return .denied
                    case .restricted:
                        return .unableToUseLocation
                    case .authorizedAlways, .authorizedWhenInUse:
                        guard let location = locationMaybe else {
                            return .determining
                        }
                        
                        //                        let stationId = await RovrProximityService.nearestStation(
                        //                            la: location.latitude, lo: location.longitude
                        //                        )
                        //                        return .authorized(nearestStation: BGStation(id: stationId))
                        return .authorized(nearestStation: .sofia)
                        
                    @unknown default:
                        return .unableToUseLocation
                    }
                }.eraseToStream()
            },
            requestAuthorization: {
                await LocationManagerActor.shared.requestAuth()
            }
        )
    }()
}

// "Configuration of your location manager object must always occur on a thread
// with an active run loop, such as your application’s main thread."
@MainActor
private struct LocationManagerActor {
    
    private(set) static var shared = Self()  // bug: https://stackoverflow.com/a/69264293
    
    let status: AsyncStream<(CLAuthorizationStatus, CLLocationCoordinate2D?)>
    
    private let manager: CLLocationManager
    private let delegate: ManagerDelegate
    
    private init() {
        let manager = CLLocationManager()
        
        let status = manager.authorizationStatus
        let delegate = ManagerDelegate(status: status)
        
        self.status = AsyncStream { cont in
            cont.yield((status, nil))
            if authorizedStatuses.contains(status) {
                manager.startMonitoringVisits()
            }
            
            delegate.onStatusUpdate = { [weak delegate] in
                guard let delegate = delegate else { return }
                cont.yield(($0, delegate.location))
                
                if authorizedStatuses.contains($0) {
                    // it is okay to duplicate these calls
                    manager.startMonitoringVisits()
                }
            }
            
            delegate.onLocationUpdate = { [weak delegate] in
                guard let delegate = delegate else { return }
                cont.yield((delegate.status, $0))
            }
            
        }
        
        self.manager = manager
        self.delegate = delegate
        
        manager.delegate = delegate
    }
    
    func requestAuth() {
        guard case .notDetermined = manager.authorizationStatus else { return }
        manager.requestWhenInUseAuthorization()
    }
}

extension LocationManagerActor {
    class ManagerDelegate: NSObject, CLLocationManagerDelegate {
        
        private(set) var status: CLAuthorizationStatus {
            didSet {
                guard oldValue != status else { return }
                onStatusUpdate?(status)
            }
        }
        
        private(set) var location: CLLocationCoordinate2D? {
            didSet {
                guard !oldValue.isApproximatelyEqualTo(location) else { return }
                onLocationUpdate?(location)
            }
        }
        
        var onStatusUpdate: ((CLAuthorizationStatus) -> Void)?
        var onLocationUpdate: ((CLLocationCoordinate2D?) -> Void)?
        
        init(
            status: CLAuthorizationStatus,
            location: CLLocationCoordinate2D? = nil,
            onStatusUpdate: ((CLAuthorizationStatus) -> Void)? = nil,
            onLocationUpdate: ((CLLocationCoordinate2D?) -> Void)? = nil
        ) {
            self.status = status
            self.location = location
            self.onStatusUpdate = onStatusUpdate
            self.onLocationUpdate = onLocationUpdate
        }
            
        func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
            location = visit.coordinate
        }
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            status = manager.authorizationStatus
        }
    }
}

fileprivate extension Optional where Wrapped == CLLocationCoordinate2D {
    func isApproximatelyEqualTo(_ other: CLLocationCoordinate2D?) -> Bool {
        guard let c1 = self, let c2 = other else {
            return self == nil && other == nil
        }
        
        return abs(c1.latitude - c2.latitude) <= coordTolerance
        && abs(c1.longitude - c2.longitude) <= coordTolerance
    }
}
