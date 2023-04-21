//
//  TrainViewModel.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 21.04.23.
//

import Foundation

struct TrainViewModel: Identifiable {
    let id: String
    
    let from: String
    let through: String?
    let to: String
    
    let arrival: DisplayTime?
    let departure: DisplayTime?
}

extension TrainViewModel {
    enum DisplayTime {
        case scheduled(String)
        case punctual(String)
        case delayed(scheduled: String, delay: String, estimate: String)
    }
}
