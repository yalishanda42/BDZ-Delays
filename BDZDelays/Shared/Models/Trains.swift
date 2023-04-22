//
//  Trains.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 22.04.23.
//

import Foundation

struct TrainNumber {
    let type: TrainType
    let number: Int
}

enum TrainType {
    case suburban
    case normal
    case fast
    case international
}

extension TrainType: Hashable {
}

extension TrainNumber: Identifiable, Hashable {
    var id: Self { self }
}
