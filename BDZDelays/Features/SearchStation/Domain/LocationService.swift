//
//  LocationService.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 1.05.23.
//

import Foundation

struct LocationService {
    var statusStream: () async -> AsyncStream<SearchStationReducer.State.LocationStatus>
    var requestAuthorization: () async -> Void
}
