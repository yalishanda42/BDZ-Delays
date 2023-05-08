//
//  File.swift
//  
//
//  Created by Alexander Ignatov on 8.05.23.
//

import Foundation

public struct TrainAtStation: Equatable {
    public let number: TrainNumber
    
    public let from: Station
    public let to: Station
    
    public let schedule: Schedule
    
    public let delay: Duration?
    
    public let movement: MovementState
    
    public init(
        number: TrainNumber,
        from: Station,
        to: Station,
        schedule: Schedule,
        delay: Duration?,
        movement: MovementState
    ) {
        self.number = number
        self.from = from
        self.to = to
        self.schedule = schedule
        self.delay = delay
        self.movement = movement
    }
}

public extension TrainAtStation {
    enum Schedule: Equatable {
        case arrivalOnly(Date)
        case departureOnly(Date)
        case full(arrival: Date, departure: Date)
    }

    enum MovementState: Equatable {
        case notYetOperating
        case inOperation
        case doorsOpen
        case leavingStation
        case stopped
    }
}
