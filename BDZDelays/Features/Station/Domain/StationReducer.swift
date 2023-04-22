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
        var trains: IdentifiedArrayOf<TrainAtStation> = []
        var lastUpdateTime: Date?
    }
    
    enum Action: Equatable {
        case refresh
        case load(IdentifiedArrayOf<State.TrainAtStation>)
        case receiveError
        case enableRefresh
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.date.now) var now
    @Dependency(\.stationRepository) var stationRepository
    
    struct LoadingCancellableID {}
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .refresh:
            state.loadingState = .loading
            return .run { [station = state.station] send in
                do {
                    try Task.checkCancellation()
                    let trains = try await stationRepository.fetchTrainsAtStation(station)
                    try Task.checkCancellation()
                    await send(.load(.init(uniqueElements: trains)))
                } catch is CancellationError {
                    return  // do nothing
                } catch {
                    await send(.receiveError)
                }
            }.cancellable(id: LoadingCancellableID.self, cancelInFlight: true)
            
        case .load(let trains):
            state.lastUpdateTime = now
            state.trains = trains
            state.loadingState = .disabled
        
        case .receiveError:
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
