//
//  SearchStationReducer.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 30.04.23.
//

import Foundation
import ComposableArchitecture
import Dependencies

import SharedModels
import StationDomain
import LocationService
import SettingsURLService

public struct SearchStationReducer: ReducerProtocol {
    
    public let allStations: [BGStation]
    
    public init(allStations: [BGStation] = BGStation.allCases) {
        self.allStations = allStations
    }
    
    public struct State: Equatable {
        public var filteredStations: [BGStation]
        public var query: String
        public var locationStatus: LocationStatus
        
        // Child screen
        public var stationState: StationReducer.State?
        
        public init(
            filteredStations: [BGStation] = BGStation.allCases,
            query: String = "",
            locationStatus: LocationStatus = .unableToUseLocation,
            selectedStation: StationReducer.State? = nil
        ) {
            self.filteredStations = filteredStations
            self.query = query
            self.locationStatus = locationStatus
            self.stationState = selectedStation
        }
        
        public var isSearching: Bool {
            !query.isEmpty
        }
    }
    
    public enum Action: Equatable {
        case updateQuery(String)
        case selectStation(BGStation?)
        
        case locationStatusUpdate(LocationStatus)
        case askForLocationPersmission
        case locationSettings
        
        /// To be send from the `.task` view modifier.
        /// Used for executing a long-running effect for
        /// as long as the view is alive.
        /// Automatically cancelled when the view disappears.
        case task
        
        /// Child screen action
        case stationAction(StationReducer.Action)
    }
    
    @Dependency(\.locationService) var locationService
    @Dependency(\.settingsService) var settingsService
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .task:
                return .run { send in
                    let stream = await locationService.statusStream()
                    for await status in stream {
                        await send(.locationStatusUpdate(status))
                    }
                }
                
            case .locationStatusUpdate(let status):
                state.locationStatus = status
                return .none
                
            case .updateQuery(let newQuery):
                let trimmed = newQuery.trimmingCharacters(in: .whitespaces)
                state.query = trimmed
                
                guard trimmed.count > 0 else {
                    state.filteredStations = allStations
                    return .none
                }
                
                state.filteredStations = allStations.filter {
                    $0.name.lowercased().contains(trimmed.lowercased())
                }
                
                return .none
                
            case .selectStation(let station):
                guard let new = station else {
                    return .send(.stationAction(.finalize))
                }
                
                guard new != state.stationState?.station else {
                    // the station is already selected
                    return .none
                }
                
                state.stationState = .init(station: new)
                return .send(.stationAction(.refresh))
                
            case .askForLocationPersmission:
                state.locationStatus = .determining
                return .fireAndForget {
                    await locationService.requestAuthorization()
                }
                
            case .locationSettings:
                return .fireAndForget {
                    await settingsService.openSettings()
                }
                
            case .stationAction(let childAction):
                // Child screen
                if case .finalize = childAction {
                    state.stationState = nil
                }
                
                return .none
            }
        }.ifLet(\.stationState, action: /Action.stationAction) {
            StationReducer()
        }
    }
}
