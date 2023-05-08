//
//  StationRepository+Dependency.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 22.04.23.
//

import Dependencies
import Foundation

import SharedModels

extension StationRepository: TestDependencyKey {
    public static var testValue = Self(
        fetchTrainsAtStation: unimplemented("StationRepository.fetchTrainsAtStation")
    )
    
    public static let previewValue = Self(
        fetchTrainsAtStation: { _ -> [TrainAtStation] in
           []
        }
    )
}

public extension DependencyValues {
    var stationRepository: StationRepository {
        get { self[StationRepository.self] }
        set { self[StationRepository.self] = newValue }
    }
}
