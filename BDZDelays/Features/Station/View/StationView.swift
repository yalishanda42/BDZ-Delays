//
//  StationView.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 21.04.23.
//

import SwiftUI

struct StationView: View {
    let vm: StationViewModel
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle(vm.name)
                .toolbar {
                    Text(vm.updateDisplayTime)
                    Button {
                        vm.refreshAction()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
        }
    }
    
    private var content: some View {
        if vm.trains.isEmpty {
            return AnyView(Text("Няма влакове за следващите 6 часа."))
        } else {
            return AnyView(
                List {
                    ForEach(vm.trains) { trainVM in
                        Section {
                            TrainView(vm: trainVM)
                                .listRowInsets(.init())
                        }
                    }
                }
            )
        }
    }
}

struct StationView_Previews: PreviewProvider {
    static var previews: some View {
        StationView(vm: .init(
            name: "Горна Оряховица",
            trains: TrainView_Previews.testVMs,
            updateDisplayTime: "21:12",
            refreshAction: {}
        ))
        .preferredColorScheme(.light)
        .previewDisplayName("Light full")
        
        StationView(vm: .init(
            name: "Горна Оряховица",
            trains: TrainView_Previews.testVMs,
            updateDisplayTime: "21:12",
            refreshAction: {}
        ))
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark full")
        
        StationView(vm: .init(
            name: "Горна Оряховица",
            trains: [],
            updateDisplayTime: "21:12",
            refreshAction: {}
        ))
        .preferredColorScheme(.light)
        .previewDisplayName("Light empty")
        
        StationView(vm: .init(
            name: "Горна Оряховица",
            trains: [],
            updateDisplayTime: "21:12",
            refreshAction: {}
        ))
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark empty")
    }
}
