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

private let favoriteIconColor = Color.teal

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
                if let selected = vs.stationState {
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
            get: { vs.stationState?.station },
            set: { vs.send(.selectStation($0)) }
        )) {
            if vs.locationStatus != .unableToUseLocation
                && !vs.isSearching {
                Section {
                    NearestStationView(vs: vs)
                } header: {
                    Text("Най-близката")
                } footer: {
                    if vs.locationStatus == .denied {
                        Text("За да се определи коя е най-близката ЖП гара, трябва да се разреши достъп до местоположението в настройките на приложението (натиснете горния бутон, за да ви отведе там)")
                        
                    }
                }
            }
            
            if !vs.isSearching {
                Section {
                    ForEach(vs.favoriteStations) { station in
                        NavigationLink(value: station) {
                            Text(station.name)
                                .favoritable(station: station, vs: vs)
                        }
                    }.onMove { from, to in
                        vs.send(.moveFavorite(from: from, to: to))
                    }
                } header: {
                    Text("Запазени")
                } footer: {
                    if vs.favoriteStations.isEmpty {
                        Text("Можете да си запазвате тук гари чрез плъзване надясно на избрана такава.")
                    }
                }
            }
            
            Section {
                ForEach(vs.filteredStations) { station in
                    NavigationLink(value: station) {
                        HStack {
                            if vs.state.isStationFavorite(station) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(favoriteIconColor)
                            }
                            Text(station.name)
                        }
                        .favoritable(station: station, vs: vs)
                    }
                }
            } header: {
                if vs.isSearching {
                    Text("Резултати")
                } else {
                    Text("Всички")
                }
            } footer: {
                if !vs.isSearching {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Информацията се предоставя от https://rovr.info.")
                        Text("Код на приложението: https://github.com/yalishanda42/BDZ-Delays")
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
                    vs.send(.locationAction)
                } label: {
                    Text(station.name)
                }.favoritable(station: station, vs: vs)
            case .notYetAskedForAuthorization:
                Image(systemName: "location")
                    .foregroundColor(.accentColor)
                Button {
                    vs.send(.locationAction)
                } label: {
                    Text("Позволи достъп до локацията")
                }
            case .denied:
                Image(systemName: "location")
                    .foregroundColor(.red)
                Button {
                    vs.send(.locationAction)
                } label: {
                    Text("Достъпът до локацията е отказан")
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
                Button {
                    vs.send(.locationAction)
                } label: {
                    Text("Неуспех при опит за връзка")
                        .foregroundColor(.gray)
                }
            case .unableToUseLocation:
                EmptyView()
            }
        }
    }
}

fileprivate extension View {
    @ViewBuilder
    func favoritable(
        station: BGStation,
        vs: ViewStore<SearchStationReducer.State, SearchStationReducer.Action>
    ) -> some View {
        swipeActions(edge: .leading, allowsFullSwipe: true) {
            if vs.state.isStationFavorite(station) {
                Button {
                    vs.send(.toggleSaveStation(station))
                } label: {
                    Label("Премахни", systemImage: "star.slash.fill")
                }
            } else {
                Button {
                    vs.send(.toggleSaveStation(station))
                } label: {
                    Label("Запази", systemImage: "star.fill")
                }.tint(favoriteIconColor)
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
