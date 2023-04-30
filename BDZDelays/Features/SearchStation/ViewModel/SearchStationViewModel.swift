//
//  SearchStationViewModel.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 30.04.23.
//

import Foundation
import Combine

class SearchStationViewModel: ObservableObject {
    @Published var stations: [BGStation]
    var query: String
    
    private let all: [BGStation]
    let onTap: ((BGStation) -> Void)?

    init(
        _ all: [BGStation] = BGStation.allCases.sorted,
        onTap: ((BGStation) -> Void)? = nil
    ) {
        self.all = all
        self.stations = all
        self.query = ""
        self.onTap = onTap
    }
    
    func updateQuery(_ newQuery: String) {
        let trimmed = newQuery.trimmingCharacters(in: .whitespaces)
        query = trimmed
        
        guard trimmed.count > 0 else {
            stations = all.sorted
            return
        }
        
        stations = all.filter {
            $0.name.lowercased().contains(trimmed.lowercased())
        }.sorted
    }
}


fileprivate extension Array where Element == BGStation {
    var sorted: Self {
        sorted { $0.name < $1.name }
    }
}
