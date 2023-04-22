//
//  StationViewModel.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 21.04.23.
//

import Foundation

struct StationViewModel {
    let name: String
    let trains: [TrainViewModel]
    let refreshState: RefreshIndicatorState
    let updateDisplayTime: String?
    let refreshAction: () -> Void
}

extension StationViewModel {
    enum RefreshIndicatorState {
        case hidden
        case loading
        case warning
        case refresh
    }
}
