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
        var locationStatus: LocationStatus = .notYetAskedForAuthorization
        
        // Child screen
        var selectedStation: StationReducer.State?
    }
    
    enum Action: Equatable {
        case updateQuery(String)
        case selectStation(BGStation?)
        
        case askForLocationPersmission
        case locationSettings
        
        // Child screen
        case stationAction(StationReducer.Action)
    }
    
    @Dependency(\.locationService) var locationService
    
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
                    return .send(.stationAction(.finalize))
                }
                
                guard new != state.selectedStation?.station else {
                    // the station is already selected
                    return .none
                }
                
                state.selectedStation = .init(station: new)
                return .send(.stationAction(.refresh))
                
            case .askForLocationPersmission:
                return .fireAndForget {
                    await locationService.requestAuthorization()
                }
                
            case .locationSettings:
                // TODO
                return .none
                
            case .stationAction(let childAction):
                // Child screen
                if case .finalize = childAction {
                    state.selectedStation = nil
                }
                
                return .none
            }
        }.ifLet(\.selectedStation, action: /Action.stationAction) {
            StationReducer()
        }
    }
}

extension SearchStationReducer.State {
    enum LocationStatus: Equatable {
        case notYetAskedForAuthorization
        case determining
        case authorized(nearestStation: BGStation?)
        case denied
        case unableToUseLocation
    }
}
