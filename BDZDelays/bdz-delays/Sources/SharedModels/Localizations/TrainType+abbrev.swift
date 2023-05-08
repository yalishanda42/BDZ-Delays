//
//  TrainType+abbrev.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 22.04.23.
//

import Foundation

public extension TrainType {
    var abbrev: String {
        switch self {
        case .suburban:
            return "КПВ"
        case .normal:
            return "ПВ"
        case .fast:
            return "БВ"
        case .international:
            return "МБВ"
        case .other(let string):
            return string
        }
    }
}
