//
//  LocationService+Live.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 2.05.23.
//

import Foundation
import CoreLocation

import LocationService
import LogService
import ROVR
import SharedModels

import Dependencies

private let coordTolerance = 0.001

#if os(iOS)
private let authorizedStatuses: [CLAuthorizationStatus] = [.authorizedAlways, .authorizedWhenInUse]
#elseif os(macOS)
private let authorizedStatuses: [CLAuthorizationStatus] = [.authorized]
#else
private let authorizedStatuses: [CLAuthorizationStatus] = []
#endif


extension LocationService: DependencyKey {
    public static let liveValue: Self = {
        return Self(
            statusStream: {
                let stream = await LocationManagerActor.shared.status
                return stream.map {
                    (authStatus, locationMaybe) -> LocationStatus in
                    
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
                        
                        guard let data = try? await RovrDownloader.downloadProximityData(to: .init(
                            latitude: location.latitude, longitude: location.longitude
                        )) else {
                            return .authorized(nearestStation: nil)
                        }
                        
                        guard let station = try? RovrDecoder.decodeStation(fromLocationData: data)
                        else {
                            return .authorized(nearestStation: nil)
                        }
                        
                        return .authorized(nearestStation: station.asDomainStation)
                        
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
            let location = authorizedStatuses.contains(status)
                ? manager.location?.coordinate
                : nil
            
            cont.yield((status, location))
            
            delegate.onStatusUpdate = { [weak delegate] in
                guard let delegate = delegate else { return }
                
                if authorizedStatuses.contains($0) {
                    manager.startMonitoringVisits()  // it is okay to duplicate these calls
                    cont.yield(($0, manager.location?.coordinate))
                } else {
                    cont.yield(($0, delegate.location))
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
        
        if authorizedStatuses.contains(status) {
            manager.startMonitoringVisits()
        }
    }
    
    func requestAuth() {
        guard case .notDetermined = manager.authorizationStatus else { return }
        manager.requestWhenInUseAuthorization()
    }
}

extension LocationManagerActor {
    class ManagerDelegate: NSObject, CLLocationManagerDelegate {
        
        @Dependency(\.log) private var log
        
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
            log.info("locationManager didVisit cordinate:\(visit.coordinate)")
            location = visit.coordinate
        }
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            log.info("locationManager didChangeAuthorization:\(manager.authorizationStatus)")
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
