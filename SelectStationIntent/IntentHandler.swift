//
//  IntentHandler.swift
//  SelectStationIntent
//
//  Created by AI on 30.05.23.
//

import Intents
import SharedModels

class IntentHandler: INExtension, SelectStationIntentHandling {
    func resolveStation(for intent: SelectStationIntent) async -> INStringResolutionResult {
        guard let station = intent.station else {
            return .success(with: "?") // ?
        }
        
        return .success(with: station)
    }
    
    func provideStationOptionsCollection(for intent: SelectStationIntent) async throws -> INObjectCollection<NSString> {
        .init(items: BGStation.allCases.map(\.name) as [NSString])
    }
}
