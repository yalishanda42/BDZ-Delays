//
//  SearchStationView.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 30.04.23.
//

import SwiftUI
import ComposableArchitecture

import SearchStationDomain
import StationView
import SharedModels

public struct SearchStationView: View {
    public let store: StoreOf<SearchStationReducer>
    
    public init(store: StoreOf<SearchStationReducer>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { vs in
            NavigationSplitView {
                MasterView(vs: vs)
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
            .task {
                await vs.send(.task).finish()
            }
        }
    }
}

private struct MasterView: View {
    let vs: ViewStore<SearchStationReducer.State, SearchStationReducer.Action>

    var body: some View {
        List(selection: Binding<BGStation?>(
            get: { vs.selectedStation?.station },
            set: { vs.send(.selectStation($0)) }
        )) {
            if vs.locationStatus != .unableToUseLocation {
                Section("Най-близката") {
                    NearestStationView(vs: vs)
                }
            }
            
            Section("Всички") {
                ForEach(vs.filteredStations) { station in
                    NavigationLink(value: station) {
                        Text(station.name)
                    }
                }
            }
        }.navigationTitle("ЖП Гари")
    }
}

private struct NearestStationView: View {
    let vs: ViewStore<SearchStationReducer.State, SearchStationReducer.Action>
    
    var body: some View {
        HStack {
            switch vs.locationStatus {
            case let .authorized(nearestStation: .some(station)):
                Image(systemName: "location.fill")
                    .foregroundColor(.accentColor)
                Button {
                    vs.send(.selectStation(station))
                } label: {
                    Text(station.name)
                }
            case .notYetAskedForAuthorization:
                Image(systemName: "location")
                    .foregroundColor(.accentColor)
                Button {
                    vs.send(.askForLocationPersmission)
                } label: {
                    Text("Позволи достъп до локацията")
                }
            case .denied:
                Image(systemName: "location")
                    .foregroundColor(.red)
                Button {
                    vs.send(.locationSettings)
                } label: {
                    Text("Достъпът до локацията е отказан")
                        .italic()
                }
            case .determining:
                Image(systemName: "circle.dotted")
                    .foregroundColor(.gray)
                Text("Свързване...")
                    .foregroundColor(.gray)
                    .italic()
            case .authorized(nearestStation: .none):
                Image(systemName: "wifi.exclamationmark")
                    .foregroundColor(.gray)
                Text("Неуспех при опит за връзка")
                    .foregroundColor(.gray)
            case .unableToUseLocation:
                EmptyView()
            }
        }
    }
}

extension BGStation: Identifiable {
    public var id: Self { self }
}

// MARK: - Previews

struct SearchStationView_Previews: PreviewProvider {
    static var previews: some View {
        SearchStationView(store: .init(
            initialState: .init(),
            reducer: SearchStationReducer()
        )).previewDisplayName("Default")
        
        SearchStationView(store: .init(
            initialState: .init(),
            reducer: SearchStationReducer(),
            prepareDependencies: {
                $0.locationService.statusStream = { AsyncStream {
                    $0.yield(.unableToUseLocation)
                }}
            }
        )).previewDisplayName("No location")
        
        SearchStationView(store: .init(
            initialState: .init(),
            reducer: SearchStationReducer(),
            prepareDependencies: {
                $0.locationService.statusStream = { AsyncStream {
                    $0.yield(.authorized(nearestStation: .dobrich))
                }}
            }
        )).previewDisplayName("Use location")
        
        SearchStationView(store: .init(
            initialState: .init(),
            reducer: SearchStationReducer(),
            prepareDependencies: {
                $0.locationService.statusStream = { AsyncStream {
                    $0.yield(.denied)
                }}
            }
        )).previewDisplayName("Denied location")
        
        SearchStationView(store: .init(
            initialState: .init(),
            reducer: SearchStationReducer(),
            prepareDependencies: {
                $0.locationService.statusStream = { AsyncStream {
                    $0.yield(.determining)
                }}
            }
        )).previewDisplayName("Determining location")
        
        SearchStationView(store: .init(
            initialState: .init(),
            reducer: SearchStationReducer(),
            prepareDependencies: {
                $0.locationService.statusStream = { AsyncStream {
                    $0.yield(.authorized(nearestStation: nil))
                }}
            }
        )).previewDisplayName("Use location, no station")
    }
}
