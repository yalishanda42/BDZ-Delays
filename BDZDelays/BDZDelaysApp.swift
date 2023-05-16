//
//  BDZDelaysApp.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 21.04.23.
//

import SwiftUI

import SearchStationView
import SearchStationDomain

// === List all live dependencies here ===
import StationRepositoryLive
import LocationServiceLive
import SettingsURLServiceLive
import FavoritesServiceLive
import LogServiceLive
// =======================================

@main
struct BDZDelaysApp: App {
    var body: some Scene {
        WindowGroup {
            SearchStationView(store: .init(
                initialState: .init(),
                reducer: SearchStationReducer()._printChanges()
            ))
        }
    }
}
