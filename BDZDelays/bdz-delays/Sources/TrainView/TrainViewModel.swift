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
    
    public let arrival: Schedule?
    public let departure: Schedule?
    
    public let delayInMinutes: Int?
    
    public init(
        id: String,
        from: String,
        through: String? = nil,
        to: String,
        operation: OperationState,
        arrival: Schedule? = nil,
        departure: Schedule? = nil,
        delayInMinutes: Int? = nil
    ) {
        self.id = id
        self.from = from
        self.through = through
        self.to = to
        self.operation = operation
        self.arrival = arrival
        self.departure = departure
        self.delayInMinutes = delayInMinutes
    }
}

public extension TrainViewModel {
    enum OperationState {
        case notYetOperating
        case operating
        case inStation
        case leftStationOrTerminated
    }
    
    struct Schedule {
        let scheduled: String
        let actual: String?
        
        public init(_ scheduled: String, actual: String? = nil) {
            self.scheduled = scheduled
            self.actual = actual
        }
    }
}
