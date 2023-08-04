//
//  DeepLinkHandler.swift
//  BDZDelays
//
//  Created by AI on 10.06.23.
//

import Foundation
import ComposableArchitecture
import Dependencies

import SharedModels
import SearchStationDomain
import LogServiceLive

enum DeepLinkHandler {
    static func handle(url: URL, store: ViewStoreOf<SearchStationReducer>) {
        @Dependency(\.log) var log
        log.info("Received URL: \(url)")
        
        guard
            url.scheme == "bdzdelays",
            url.host() == "station"
        else { return }
        
        let station = decodeStation(fromString: url.lastPathComponent)
        store.send(.selectStation(station))
    }
}

private extension DeepLinkHandler {
    static func decodeStation(fromString string: String) -> BGStation? {
        BGStation.allCases.first {
            $0.name == string
        }
    }
}
