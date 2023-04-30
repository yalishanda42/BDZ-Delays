//
//  SearchStationView.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 30.04.23.
//

import SwiftUI

struct SearchStationView: View {
    @ObservedObject var vm: SearchStationViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.stations) { station in
                    Button {
                        vm.onTap?(station)
                    } label: {
                        Text(station.name)
                            .foregroundColor(.primary)
                    }
                    
                }
            }
        }.searchable(
            text: .init(
                get: { vm.query },
                set: vm.updateQuery
            ),
            prompt: "Потърси гара..."
        )
    }
}

extension BGStation: Identifiable {
    var id: Self { self }
}

// MARK: - Previews

struct SearchStationView_Previews: PreviewProvider {
    static var previews: some View {
        SearchStationView(vm: .init())
    }
}
