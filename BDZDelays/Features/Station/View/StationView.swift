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
                    if let time = vm.updateDisplayTime {
                        Text(time)
                    }
                    
                    switch vm.refreshState {
                    case .loading where !vm.trains.isEmpty:
                        ProgressView()
                    case .warning:
                        Button {
                            vm.refreshAction()
                        } label: {
                            Image(systemName: "exclamationmark.triangle.fill")
                        }
                    case .refresh:
                        Button {
                            vm.refreshAction()
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                    default:
                        EmptyView()
                    }
                }
        }
    }
    
    private var content: some View {
        if vm.trains.isEmpty {
            return vm.refreshState == .loading
                ? AnyView(ProgressView())
                : AnyView(Text("Няма влакове за следващите 6 часа."))
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
            refreshState: .refresh,
            updateDisplayTime: "21:12",
            refreshAction: {}
        ))
        .preferredColorScheme(.light)
        .previewDisplayName("Light full")
        
        StationView(vm: .init(
            name: "Горна Оряховица",
            trains: TrainView_Previews.testVMs,
            refreshState: .loading,
            updateDisplayTime: "21:12",
            refreshAction: {}
        ))
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark full")
        
        StationView(vm: .init(
            name: "Горна Оряховица",
            trains: [],
            refreshState: .hidden,
            updateDisplayTime: "21:12",
            refreshAction: {}
        ))
        .preferredColorScheme(.light)
        .previewDisplayName("Light empty")
        
        StationView(vm: .init(
            name: "Горна Оряховица",
            trains: [],
            refreshState: .warning,
            updateDisplayTime: "21:12",
            refreshAction: {}
        ))
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark empty")
        
        StationView(vm: .init(
            name: "Горна Оряховица",
            trains: [],
            refreshState: .loading,
            updateDisplayTime: nil,
            refreshAction: {}
        ))
        .preferredColorScheme(.light)
        .previewDisplayName("Light loading empty")
    }
}
