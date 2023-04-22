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
            StationPresentationView(store: .init(
                initialState: .init(station: .sofia),
                reducer: StationReducer(),
                prepareDependencies: {
                    $0.context = .live
                }
            ))
        }
    }
}
