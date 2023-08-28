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
import FavoritesService
import LogService

public struct SearchStationReducer: Reducer {
    
    public let allStations: [BGStation]
    
    public init(allStations: [BGStation] = BGStation.allCases) {
        self.allStations = allStations
    }
    
    public struct State: Equatable {
        public var filteredStations: [BGStation]
        public var favoriteStations: [BGStation]
        public var query: String
        public var locationStatus: LocationStatus
        
        @PresentationState
        public var stationDetailsState: StationReducer.State?
        
        public init(
            filteredStations: [BGStation] = BGStation.allCases,
            favoriteStations: [BGStation] = [],
            query: String = "",
            locationStatus: LocationStatus = .unableToUseLocation,
            stationDetailsState: StationReducer.State? = nil
        ) {
            self.filteredStations = filteredStations
            self.favoriteStations = favoriteStations
            self.query = query
            self.locationStatus = locationStatus
            self.stationDetailsState = stationDetailsState
        }
        
        public var isSearching: Bool {
            !query.isEmpty
        }
        
        public func isStationFavorite(_ station: BGStation) -> Bool {
            favoriteStations.contains(station)
        }
    }
    
    public enum Action: Equatable {
        case updateQuery(String)
        case selectStation(BGStation?)
        
        case loadSavedStations([BGStation])
        case toggleSaveStation(BGStation)
        case moveFavorite(from: IndexSet, to: Int)
        
        case locationStatusUpdate(LocationStatus)
        case locationAction
        
        case refresh
        
        /// To be send from the `.task` view modifier.
        /// Used for executing a long-running effect for
        /// as long as the view is alive.
        /// Automatically cancelled when the view disappears.
        case task
        
        /// Child screen action
        case stationAction(PresentationAction<StationReducer.Action>)
    }
    
    @Dependency(\.locationService) var locationService
    @Dependency(\.settingsService) var settingsService
    @Dependency(\.favoritesService) var favoritesService
    @Dependency(\.log) var log
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .task:
                return .merge(
                    .run { send in
                        let stream = await locationService.statusStream()
                        for await status in stream {
                            await send(.locationStatusUpdate(status))
                        }
                    },
                    .run { send in
                        let stations = try await favoritesService.loadFavorites()
                        await send(.loadSavedStations(stations))
                    } catch: { error, _ in
                        log.error(error, "Failed to retrieve saved stations")
                    }
                )
                
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
                    return .send(.stationAction(.presented(.finalize)))
                }
                
                guard new != state.stationDetailsState?.station else {
                    // the station is already selected
                    return .none
                }
                
                state.stationDetailsState = .init(station: new)
                return .send(.stationAction(.presented(.refresh)))
                
            case .loadSavedStations(let statons):
                state.favoriteStations = statons
                return .none
                
            case .toggleSaveStation(let station):
                if state.isStationFavorite(station) {
                    state.favoriteStations.removeAll { $0 == station }
                } else {
                    state.favoriteStations.append(station)
                }
                
                return .run { [favorites = state.favoriteStations] _ in
                    try await favoritesService.saveFavorites(favorites)
                } catch: { [favorites = state.favoriteStations] error, _ in
                    log.error(error, ".toggleSaveStation: Coud not save favorites=\(favorites)")
                }
                
            case let .moveFavorite(from: from, to: to):
                state.favoriteStations.move(fromOffsets: from, toOffset: to)
                return .run { [favorites = state.favoriteStations] _ in
                    try await favoritesService.saveFavorites(favorites)
                } catch: { [favorites = state.favoriteStations] error, _ in
                    log.error(error, ".moveFavorite: Could not save favorites=\(favorites)")
                }
                
            case .locationAction:
                switch state.locationStatus {
                case .notYetAskedForAuthorization:
                    state.locationStatus = .determining
                    return .run { _ in
                        await locationService.requestAuthorization()
                    }
                case .denied:
                    return .run { _ in
                        await settingsService.openSettings()
                    }
                case .authorized(nearestStation: .some(let station)):
                    return .send(.selectStation(station))
                case .authorized(nearestStation: .none):
                    state.locationStatus = .determining
                    return .run { _ in
                        await locationService.manuallyRefreshStatus()
                    }
                case .determining, .unableToUseLocation:
                    return .none
                }
                
            case .refresh:
                if state.locationStatus == .authorized(nearestStation: nil) {
                    return .run { send in
                        await locationService.manuallyRefreshStatus()
                    }
                }
                
                return .none
                
            case .stationAction(let childAction):
                // Child screen
                if case .presented(.finalize) = childAction {
                    state.stationDetailsState = nil
                }
                
                return .none
            }
        }.ifLet(\.$stationDetailsState, action: /Action.stationAction) {
            StationReducer()
        }
    }
}
