//
//  LocationService+Dependency.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 1.05.23.
//

import Foundation
import Dependencies
import Combine

extension LocationService: TestDependencyKey {
    static let previewValue: Self = {
        let subject = PassthroughSubject<SearchStationReducer.State.LocationStatus, Never>()
        return Self(
            status: AsyncStream { cont in
                let cancellable = subject.sink {
                    cont.yield($0)
                }
                subject.send(.notYetAskedForAuthorization)
            },
            requestAuthorization: {
                subject.send(.authorized(nearestStation: .dobrich))
            }
        )
    }()
}

extension DependencyValues {
    var locationService: LocationService {
        get { self[LocationService.self] }
        set { self[LocationService.self] = newValue }
    }
}
