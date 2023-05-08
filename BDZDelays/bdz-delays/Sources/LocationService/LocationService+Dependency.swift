//
//  LocationService+Dependency.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 1.05.23.
//

import Foundation
import Combine
import SharedModels
import Dependencies

extension LocationService: TestDependencyKey {
    public static var testValue = Self(
        statusStream: unimplemented("LocationService.statusStream"),
        requestAuthorization: unimplemented("LocationService.requestAuthorization")
    )
    
    public static let previewValue: Self = {
        var continuation: AsyncStream<LocationStatus>.Continuation?
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

public extension DependencyValues {
    var locationService: LocationService {
        get { self[LocationService.self] }
        set { self[LocationService.self] = newValue }
    }
}
