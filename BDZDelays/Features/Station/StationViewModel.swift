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
    let updatDisplayTime: String
    let refreshAction: () -> Void
}
