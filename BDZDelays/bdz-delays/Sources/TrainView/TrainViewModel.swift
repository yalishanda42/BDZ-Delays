//
//  TrainViewModel.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 21.04.23.
//

import Foundation

public struct TrainViewModel: Identifiable {
    public let id: String
    
    public let from: String
    public let through: String?
    public let to: String
    
    public let operation: OperationState
    
    public let arrival: DisplayTime?
    public let departure: DisplayTime?
    
    public init(
        id: String,
        from: String,
        through: String? = nil,
        to: String,
        operation: OperationState,
        arrival: DisplayTime? = nil,
        departure: DisplayTime? = nil
    ) {
        self.id = id
        self.from = from
        self.through = through
        self.to = to
        self.operation = operation
        self.arrival = arrival
        self.departure = departure
    }
}

public extension TrainViewModel {
    enum OperationState {
        case notYetOperating
        case operating
        case inStation
        case leftStationOrTerminated
    }
    
    struct DisplayTime {
        let scheduled: String
        let delay: Delay?
        
        public init(scheduled: String, delay: Delay? = nil) {
            self.scheduled = scheduled
            self.delay = delay
        }
    }
    
    struct Delay {
        let minutes: Int
        let estimate: String
        
        public init(minutes: Int, estimate: String) {
            self.minutes = minutes
            self.estimate = estimate
        }
    }
}
