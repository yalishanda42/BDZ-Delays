//
//  SearchStationView.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 30.04.23.
//

import SwiftUI
import ComposableArchitecture

struct SearchStationView: View {
    let store: StoreOf<SearchStationReducer>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { vs in
            NavigationSplitView {
                List(vs.filteredStations, selection: Binding<BGStation?>(
                    get: { vs.selectedStation?.station },
                    set: { vs.send(.selectStation($0)) }
                )) { station in
                    NavigationLink(value: station) {
                        Text(station.name)
                    }
                }.navigationTitle("ЖП Гари")
            } detail: {
                if let selected = vs.selectedStation {
                    StationView(store: store.scope(
                        state: { _ in selected },
                        action: SearchStationReducer.Action.stationAction
                    ))
                } else {
                    Text("Изберете гара, за която да се покаже информация за спиращите и тръгващите влакове в следващите 6 часа.")
                }
            }.searchable(
                text: .init(
                    get: { vs.query },
                    set: { vs.send(.updateQuery($0)) }
                ),
                prompt: "Изберете гара..."
            )
        }
    }
}

extension BGStation: Identifiable {
    var id: Self { self }
}

// MARK: - Previews

struct SearchStationView_Previews: PreviewProvider {
    static var previews: some View {
        SearchStationView(store: .init(
            initialState: .init(),
            reducer: SearchStationReducer()
        ))
    }
}
