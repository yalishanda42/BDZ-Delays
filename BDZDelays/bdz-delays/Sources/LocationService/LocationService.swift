//
//  LocationService.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 1.05.23.
//

import Foundation
import SharedModels

public struct LocationService {
    public var statusStream: () async -> AsyncStream<LocationStatus>
    public var requestAuthorization: () async -> Void
    public var manuallyRefreshStatus: () async -> Void
    
    public init(
        statusStream: @escaping () async -> AsyncStream<LocationStatus>,
        requestAuthorization: @escaping () async -> Void,
        manuallyRefreshStatus: @escaping () async -> Void
    ) {
        self.statusStream = statusStream
        self.requestAuthorization = requestAuthorization
        self.manuallyRefreshStatus = manuallyRefreshStatus
    }
}
