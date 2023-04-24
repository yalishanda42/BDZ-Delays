//
//  StationReducer.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 22.04.23.
//

import Foundation
import ComposableArchitecture

struct StationReducer: ReducerProtocol {
    
    struct State: Equatable {
        let station: Station
        var loadingState: RefreshState = .loading
        var trains: [TrainAtStation] = []
        var lastUpdateTime: Date?
    }
    
    enum Action: Equatable {
        case refresh
        case receive(TaskResult<[State.TrainAtStation]>)
        case enableRefresh
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.date.now) var now
    @Dependency(\.stationRepository) var stationRepository
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .refresh:
            state.loadingState = .loading
            return .task { [station = state.station] in
                await .receive(TaskResult {
                    try await stationRepository.fetchTrainsAtStation(station)
                })
            }
            
        case .receive(.success(let trains)):
            state.lastUpdateTime = now
            state.trains = trains
            state.loadingState = .enabled
        
        case .receive(.failure):
            state.loadingState = .failed
            return .run { send in
                for await _ in clock.timer(interval: .seconds(5)) {
                    await send(.enableRefresh)
                    break
                }
            }
        
        case .enableRefresh:
            state.loadingState = .enabled
        }
        
        return .none
    }
}

extension StationReducer.State {
    enum RefreshState: Equatable {
        case disabled
        case loading
        case enabled
        case failed
    }
    
    struct TrainAtStation: Equatable {
        let number: TrainNumber
        
        let from: Station
        let to: Station
        
        var arrival: TrainTime?
        var departure: TrainTime?
    }

    enum TrainTime: Equatable {
        case scheduled(Date)
        case punctual(Date)
        case delayed(originalSchedule: Date, delay: Duration)
    }
}

extension StationReducer.State.TrainAtStation: Identifiable {
    var id: TrainNumber { number }
}
