//
//  StationRepository+Dependency.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 22.04.23.
//

import Foundation
import Dependencies

extension StationRepository: TestDependencyKey {
    static let previewValue = Self(
        fetchTrainsAtStation: { _ -> [StationReducer.State.TrainAtStation] in
           []
        }
    )
}

extension DependencyValues {
    var stationRepository: StationRepository {
        get { self[StationRepository.self] }
        set { self[StationRepository.self] = newValue }
    }
}
