//
//  SearchStationReducer.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 30.04.23.
//

import Foundation
import ComposableArchitecture

struct SearchStationReducer: ReducerProtocol {
    
    let allStations: [BGStation] = BGStation.allCases
    
    struct State: Equatable {
        var filteredStations = BGStation.allCases
        var query: String = ""
        
        // Child screen
        var selectedStation: StationReducer.State?
    }
    
    enum Action: Equatable {
        case updateQuery(String)
        case selectStation(BGStation?)
        
        // Child screen
        case stationAction(StationReducer.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .updateQuery(let newQuery):
                let trimmed = newQuery.trimmingCharacters(in: .whitespaces)
                state.query = trimmed
                
                guard trimmed.count > 0 else {
                    state.filteredStations = allStations
                    return .none
                }
                
                state.filteredStations = allStations.filter {
                    $0.name.lowercased().contains(trimmed.lowercased)
                }
                
                return .none
                
            case .selectStation(let station):
                guard let new = station else {
                    state.selectedStation = nil
                    return .none
                }
                
                guard new != state.selectedStation?.station else {
                    // the station is already selected
                    return .none
                }
                
                state.selectedStation = .init(station: new)
                return .send(.stationAction(.refresh))
                
            case .stationAction:
                // Child screen
                return .none
            }
        }.ifLet(\.selectedStation, action: /Action.stationAction) {
            StationReducer()
        }
    }
}
