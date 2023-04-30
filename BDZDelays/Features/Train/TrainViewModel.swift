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
    
    let operation: OperationState
    
    let arrival: DisplayTime?
    let departure: DisplayTime?
}

extension TrainViewModel {
    enum OperationState {
        case notYetOperating
        case operating
        case inStation
        case leftStationOrTerminated
    }
    
    struct DisplayTime {
        let scheduled: String
        let delay: Delay?
    }
    
    struct Delay {
        let minutes: Int
        let estimate: String
    }
}
