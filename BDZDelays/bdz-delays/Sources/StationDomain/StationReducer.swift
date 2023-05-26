//
//  StationReducer.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 22.04.23.
//

import Foundation
import ComposableArchitecture

import SharedModels
import StationRepository
import LogService

public struct StationReducer: ReducerProtocol {
    
    public struct State: Equatable {
        public let station: BGStation
        public var loadingState: RefreshState
        public var trains: [TrainAtStation]
        public var lastUpdateTime: Date?
        
        public init(
            station: BGStation,
            loadingState: RefreshState = .loaded,
            trains: [TrainAtStation] = [],
            lastUpdateTime: Date? = nil
        ) {
            self.station = station
            self.loadingState = loadingState
            self.trains = trains
            self.lastUpdateTime = lastUpdateTime
        }
    }
    
    public enum Action: Equatable {
        case refresh
        case receive(TaskResult<[TrainAtStation]>)
        
        /// Received on every new second.
        case tick
        
        /// Execute the long-running effect,
        /// associated with the lifetime of the feature.
        case task
        
        /// To be invoked before destroying.
        case finalize
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.calendar) var calendar
    @Dependency(\.date.now) var now
    
    @Dependency(\.stationRepository) var stationRepository
    @Dependency(\.log) var log
    
    public init() {}
    
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .task:
            return .run { send in
                for await _ in clock.timer(interval: .seconds(1)) {
                    await send(.tick)
                }
            }
            
        case .tick:
            // Auto-refresh only on every new calendar minute and if not errored.
            guard state.loadingState != .failed else {
                return .none
            }
            
            let isInTheSameMinute = state.lastUpdateTime
                .map {
                    let components: Set<Calendar.Component> = [.day, .hour, .minute]
                    let entryComponents = calendar.dateComponents(components, from: $0)
                    let nowComponents = calendar.dateComponents(components, from: now)
                    return entryComponents == nowComponents
                }
                ?? false
            
            if !isInTheSameMinute {
                return .send(.refresh)
            }
            
        case .refresh:
            guard state.loadingState != .loading else {
                return .none
            }
            
            state.loadingState = .loading
            
            return .task { [station = state.station] in
                await .receive(TaskResult {
                    try await stationRepository.fetchTrainsAtStation(station)
                })
            }.cancellable(id: TrainsTaskCancelID.self)
            
        case .receive(.success(let trains)):
            state.lastUpdateTime = now
            state.trains = trains
            state.loadingState = .loaded
        
        case .receive(.failure(let error)):
            state.loadingState = .failed
            log.error(error, "Faied to fetch trains data for station \(state.station).")
            
        case .finalize:
            return .cancel(id: TrainsTaskCancelID.self)
        }
        
        return .none
    }
    
    private enum TrainsTaskCancelID {}
}

public extension StationReducer.State {
    enum RefreshState: Equatable {
        case loaded
        case loading
        case failed
    }
}

extension TrainAtStation: Identifiable {
    public var id: TrainNumber { number }
}
