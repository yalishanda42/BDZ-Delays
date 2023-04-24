//
//  Station+name.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 22.04.23.
//

import Foundation

extension Station {
    var name: String {
        switch self {
        case .sofia: return "София"
        case .gornaOryahovitsa: return "Горна Оряховица"
        case .other(let name): return name
        }
    }
}