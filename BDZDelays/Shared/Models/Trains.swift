//
//  Trains.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 22.04.23.
//

import Foundation

struct TrainNumber: Hashable, Equatable {
    let type: TrainType
    let number: Int
}

enum TrainType: Hashable, Equatable {
    case suburban
    case normal
    case fast
    case international
    case other(String)
}

extension TrainNumber: Identifiable {
    var id: Self { self }
}
