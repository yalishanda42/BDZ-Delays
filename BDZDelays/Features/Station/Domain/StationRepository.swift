//
//  StationRepository.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 22.04.23.
//

import Foundation

struct StationRepository {
    var fetchTrainsAtStation: (_ station: Station) async throws -> [StationReducer.State.TrainAtStation]
}

enum StationRepositoryError: Error {
    case parseError
    case invalidData
}
