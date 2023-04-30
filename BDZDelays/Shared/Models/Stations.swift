//
//  Stations.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 22.04.23.
//

import Foundation

enum Station: Equatable {
    case bulgarian(BGStation)
    case other(String)
}

enum BGStation: Equatable, CaseIterable {
    case sofia
    case gornaOryahovitsa
}
