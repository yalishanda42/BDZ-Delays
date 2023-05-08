//
//  Trains.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 22.04.23.
//

import Foundation

public struct TrainNumber: Hashable, Equatable {
    public let type: TrainType
    public let number: Int
    
    public init(type: TrainType, number: Int) {
        self.type = type
        self.number = number
    }
}

public enum TrainType: Hashable, Equatable {
    case suburban
    case normal
    case fast
    case international
    case other(String)
}

extension TrainNumber: Identifiable {
    public var id: Self { self }
}
