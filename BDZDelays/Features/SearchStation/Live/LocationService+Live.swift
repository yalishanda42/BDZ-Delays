//
//  LocationService+Live.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 2.05.23.
//

import Foundation
import Dependencies
import CoreLocation
import Combine

private let coordTolerance = 0.001
private let authorizedStatuses: [CLAuthorizationStatus] = [.authorizedAlways, .authorizedWhenInUse]

extension LocationService: DependencyKey {
    static let liveValue: Self = {
        return Self(
            status: AsyncStream {
                let statusStream = locationActor.status
                for await (authStatus, locationMaybe) in statusStream {
                    switch authStatus {
                    case .notDetermined:
                        return .notYetAskedForAuthorization
                    case .denied:
                        return .denied
                    case .restricted:
                        return .unableToUseLocation
                    case .authorizedAlways, .authorizedWhenInUse:
                        guard let location = locationMaybe else {
                            return .authorized(nearestStation: nil)
                        }
                        
//                        let stationId = await RovrProximityService.nearestStation(
//                            la: location.latitude, lo: location.longitude
//                        )
//                        return .authorized(nearestStation: BGStation(id: stationId))
                        return .authorized(nearestStation: .sofia)
                        
                    @unknown default:
                        return .unableToUseLocation
                    }
                }
                
                return .unableToUseLocation
            } onCancel: {},
            requestAuthorization: {
                await locationActor.requestAuth()
            }
        )
    }()
    
    private static let locationActor = LocationManagerActor()
}

private actor LocationManagerActor: NSObject {
    
    let status: AsyncPublisher<AnyPublisher<(CLAuthorizationStatus, CLLocationCoordinate2D?), Never>>
    
    private let manager = CLLocationManager()
    private let delegate: ManagerDelegate
    
    private var cancellables: Set<AnyCancellable> = []
    
    override init() {
        self.delegate = ManagerDelegate(status: manager.authorizationStatus)
        
        self.status = AsyncPublisher(
            delegate.$status.removeDuplicates().combineLatest(
                delegate.$location.removeDuplicates {
                    guard let c1 = $0, let c2 = $1 else {
                        return $0 == nil && $1 == nil
                    }
                    
                    return abs(c1.latitude - c2.latitude) <= coordTolerance
                        && abs(c1.longitude - c2.longitude) <= coordTolerance
                }
            ).eraseToAnyPublisher()
        )
        
        super.init()
        
        delegate.$status.sink { [weak manager] status in
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                // From the official documentation:
                // "The Visits location service provides the most power-efficient way to get location data.
                // The system monitors the places someone visits and the time they spend there,
                // and delivers that data at a later time."
                // Calling this more than once should be okay as well.
                manager?.startMonitoringVisits()
            default:
                break
            }
        }.store(in: &cancellables)
        
        manager.delegate = delegate
    }
    
    func requestAuth() {
        guard case .notDetermined = manager.authorizationStatus else { return }
        manager.requestWhenInUseAuthorization()
    }
}

extension LocationManagerActor {
    class ManagerDelegate: NSObject, CLLocationManagerDelegate {
        
        @Published var status: CLAuthorizationStatus
        @Published var location: CLLocationCoordinate2D?
        
        init(status: CLAuthorizationStatus, location: CLLocationCoordinate2D? = nil) {
            self.status = status
            self.location = location
        }
            
        func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
            location = visit.coordinate
        }
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            status = manager.authorizationStatus
        }
    }
}
