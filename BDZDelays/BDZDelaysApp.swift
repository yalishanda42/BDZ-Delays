//
//  BDZDelaysApp.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 21.04.23.
//

import SwiftUI

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
