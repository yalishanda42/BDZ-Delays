//
//  StationRepository.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 22.04.23.
//

import Foundation
import SharedModels

public struct StationRepository {
    public var fetchTrainsAtStation: (_ station: BGStation) async throws -> [TrainAtStation]
    
    public init(fetchTrainsAtStation: @escaping (BGStation) async throws -> [TrainAtStation]) {
        self.fetchTrainsAtStation = fetchTrainsAtStation
    }
}

public enum StationRepositoryError: Error {
    case parseError
    case invalidData
}
