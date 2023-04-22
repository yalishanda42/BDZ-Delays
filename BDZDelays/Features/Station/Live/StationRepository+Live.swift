//
//  StationRepository+Live.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 22.04.23.
//

import Foundation
import Dependencies

extension StationRepository: DependencyKey {
    static let liveValue = Self(
        fetchTrainsAtStation: { _ in
            // TODO
            return []
        }
    )
}
