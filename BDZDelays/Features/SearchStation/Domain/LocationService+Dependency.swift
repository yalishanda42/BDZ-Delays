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
        var continuation: AsyncStream<SearchStationReducer.State.LocationStatus>.Continuation?
        return Self(
            statusStream: {
                AsyncStream { cont in
                    cont.yield(.notYetAskedForAuthorization)
                    continuation = cont
                }
            },
            requestAuthorization: {
                continuation?.yield(.authorized(nearestStation: .dobrich))
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
