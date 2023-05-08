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

public struct StationReducer: ReducerProtocol {
    
    public struct State: Equatable {
        public let station: BGStation
        public var loadingState: RefreshState = .loading
        public var trains: [TrainAtStation] = []
        public var lastUpdateTime: Date?
        
        public init(station: BGStation) {
            self.station = station
        }
    }
    
    public enum Action: Equatable {
        case refresh
        case receive(TaskResult<[TrainAtStation]>)
        case enableRefresh
        
        /// To be invoked before destroying
        case finalize
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.date.now) var now
    @Dependency(\.stationRepository) var stationRepository
    
    public init() {}
    
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .refresh:
            state.loadingState = .loading
            return .concatenate(
                // First cancel ongoing fetch
                .cancel(id: TrainsTaskCancelID.self),
                // Then send another
                .task { [station = state.station] in
                    await .receive(TaskResult {
                        try await stationRepository.fetchTrainsAtStation(station)
                    })
                }.cancellable(id: TrainsTaskCancelID.self)
            )
            
        case .receive(.success(let trains)):
            state.lastUpdateTime = now
            state.trains = trains
            state.loadingState = .enabled
        
        case .receive(.failure):
            state.loadingState = .failed
        
        case .enableRefresh:
            state.loadingState = .enabled
            
        case .finalize:
            return .cancel(id: TrainsTaskCancelID.self)
        }
        
        return .none
    }
    
    private enum TrainsTaskCancelID {}
}

public extension StationReducer.State {
    enum RefreshState: Equatable {
        case disabled
        case loading
        case enabled
        case failed
    }
}

extension TrainAtStation: Identifiable {
    public var id: TrainNumber { number }
}
