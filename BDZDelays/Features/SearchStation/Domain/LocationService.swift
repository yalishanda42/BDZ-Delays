//
//  LocationService.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 1.05.23.
//

import Foundation

struct LocationService {
    var status: AsyncStream<SearchStationReducer.State.LocationStatus>
    var requestAuthorization: () async -> Void
}
