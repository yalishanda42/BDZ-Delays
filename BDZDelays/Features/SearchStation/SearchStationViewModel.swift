//
//  SearchStationViewModel.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 30.04.23.
//

import Foundation
import Combine

class SearchStationViewModel: ObservableObject {
    @Published var stations: [BGStation] = BGStation.allCases
}
