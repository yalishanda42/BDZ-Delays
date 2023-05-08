//
//  BDZDelaysApp.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 21.04.23.
//

import SwiftUI

import SearchStationView
import SearchStationDomain

import StationRepositoryLive
import LocationServiceLive

@main
struct BDZDelaysApp: App {
    var body: some Scene {
        WindowGroup {
            SearchStationView(store: .init(
                initialState: .init(),
                reducer: SearchStationReducer()
            ))
        }
    }
}
