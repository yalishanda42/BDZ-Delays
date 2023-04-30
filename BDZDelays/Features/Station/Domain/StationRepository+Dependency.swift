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
                        type: .suburban,
                        number: 2112
                    ),
                    from: .sofia,
                    to: .gornaOryahovitsa,
                    schedule: .departureOnly(Date(timeIntervalSince1970: 3600)),
                    delay: nil,
                    movement: .leavingStation
                ),
                .init(
                    number: .init(
                        type: .suburban,
                        number: 2113
                    ),
                    from: .sofia,
                    to: .gornaOryahovitsa,
                    schedule: .departureOnly(Date(timeIntervalSince1970: 3600)),
                    delay: .seconds(240),
                    movement: .leavingStation
                ),
                .init(
                    number: .init(
                        type: .fast,
                        number: 2112
                    ),
                    from: .sofia,
                    to: .gornaOryahovitsa,
                    schedule: .arrivalOnly(Date(timeIntervalSince1970: 3600)),
                    delay: .seconds(240),
                    movement: .inOperation
                ),
                .init(
                    number: .init(
                        type: .normal,
                        number: 2112
                    ),
                    from: .gornaOryahovitsa,
                    to: .sofia,
                    schedule: .full(
                        arrival: Date(timeIntervalSince1970: 3600),
                        departure: Date(timeIntervalSince1970: 3600)
                    ),
                    delay: nil,
                    movement: .notYetOperating
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
