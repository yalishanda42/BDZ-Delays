//
//  BDZDelaysApp.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 21.04.23.
//

import SwiftUI

import SearchStationView
import SearchStationDomain

import ComposableArchitecture

// === List all live dependencies here ===
import StationRepositoryLive
import LocationServiceLive
import SettingsURLServiceLive
import FavoritesServiceLive
import LogServiceLive  // exposes Firebase
// =======================================

@main
struct BDZDelaysApp: App {
    
    private let store = StoreOf<SearchStationReducer>(
        initialState: .init()
    ) {
        SearchStationReducer()._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            SearchStationView(store: store)
                .onOpenURL { DeepLinkHandler.handle(url: $0, store: store) }
        }
    }
    
    init() {
        Firebase.initialize(
            plistPath: Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
        )
    }
}
