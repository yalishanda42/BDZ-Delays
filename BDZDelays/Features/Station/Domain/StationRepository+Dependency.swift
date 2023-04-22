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
        fetchTrainsAtStation: { _ in
            [
                .init(
                    number: .init(
                        type: .fast,
                        number: 2112
                    ),
                    from: .sofia,
                    to: .gornaOryahovitsa,
                    arrival: .delayed(
                        originalSchedule: Date(timeIntervalSince1970: 3600),
                        delay: .seconds(240)
                    ),
                    departure: nil
                ),
                .init(
                    number: .init(
                        type: .normal,
                        number: 2112
                    ),
                    from: .gornaOryahovitsa,
                    to: .sofia,
                    arrival: nil,
                    departure: .punctual(Date(timeIntervalSince1970: 300))
                ),
            ]
        }
    )
}

extension DependencyValues {
    var stationRepository: StationRepository {
        get { self[StationRepository.self] }
        set { self[StationRepository.self] = newValue }
    }
}
