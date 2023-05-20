//
//  StationView.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 22.04.23.
//

import SwiftUI
import ComposableArchitecture

import StationDomain
import TrainView
import SharedModels

// MARK: - View

public struct StationView: View {
    let store: StoreOf<StationReducer>
    
    public init(store: StoreOf<StationReducer>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { vs in
            content(vs)
                .navigationTitle(vs.station.name)
                .toolbar {
                    if let time = vs.lastUpdateTime {
                        Text(time.hoursAndMinutes)
                    }
                    
                    switch vs.loadingState {
                    case .loading:
                        ProgressView()
                    case .failed:
                        Button {
                            vs.send(.refresh)
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.red)
                        }
                    default:
                        EmptyView()
                    }
                }
                .onAppear {
                    vs.send(.refresh)
                }
                .task {
                    await vs.send(.task).finish()
                }
        }
    }
    
    @ViewBuilder
    private func content(_ vs: ViewStoreOf<StationReducer>) -> some View {
        switch vs.loadingState {
        case .loading where vs.trains.isEmpty:
            List(0..<10) { _ in
                Section {
                    PlaceholderTrainView()
                        .listRowInsets(.init())
                }
            }
        case .failed where vs.trains.isEmpty:
            VStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                Text("Неуспешен опит за взимане на данните. Дали имате интернет?")
            }
        case .loaded where vs.trains.isEmpty:
            Text("Няма пътнически влакове за следващите 6 часа.")
        default:
            List(vs.trains) { train in
                Section {
                    TrainView(vm: train.asViewModel)
                        .listRowInsets(.init())
                }
            }.refreshable {
                await vs.send(.refresh) {
                    $0.loadingState == .loading
                }
            }
        }
    }
}


private struct PlaceholderTrainView: View {
    var body: some View {
        TrainView(vm: .init(
            id: "БВ 2112",
            from: "Станция",
            to: "Станция",
            operation: .leftStationOrTerminated
        ))
        .redacted(reason: .placeholder)
    }
}

// MARK: - Convertions

fileprivate extension TrainAtStation {
    var asViewModel: TrainViewModel {
        .init(
            id: number.asString,
            from: from.name,
            through: nil,
            to: to.name,
            operation: movement.asOperationState,
            arrival: arrivalDisplayTime,
            departure: departureDisplayTime,
            delayInMinutes: delay?.minutes
        )
    }
    
    var arrivalDisplayTime: TrainViewModel.Schedule? {
        switch schedule {
        case .arrivalOnly(let arrival),
                .full(arrival: let arrival, departure: _):
            return scheduleFrom(arrival)
        default:
            return nil
        }
    }
    
    var departureDisplayTime: TrainViewModel.Schedule? {
        switch schedule {
        case .departureOnly(let departure),
                .full(arrival: _, departure: let departure):
            return scheduleFrom(departure)
        default:
            return nil
        }
    }
    
    func scheduleFrom(_ scheduled: Date) -> TrainViewModel.Schedule {
        .init(
            scheduled.hoursAndMinutes,
            actual: delay.map {
                scheduled.addingDuration($0).hoursAndMinutes
            }
        )
    }
}

fileprivate extension TrainAtStation.MovementState {
    var asOperationState: TrainViewModel.OperationState {
        switch self {
        case .doorsOpen: return .inStation
        case .inOperation: return .operating
        case .leavingStation: return .leftStationOrTerminated
        case .stopped: return .leftStationOrTerminated
        case .notYetOperating: return .notYetOperating
        }
    }
}

fileprivate extension TrainNumber {
    var asString: String {
        "\(type.abbrev) \(number)"
    }
}

fileprivate extension Duration {
    var minutes: Int {
        Int(components.seconds / 60)
    }
}

fileprivate extension Date {
    func addingDuration(_ duration: Duration) -> Date {
        self + TimeInterval(duration.components.seconds)
    }
}

fileprivate let dateFormatter: DateFormatter = {
    let result = DateFormatter()
    result.dateFormat = "HH:mm"
    result.timeZone = TimeZone(identifier: "Europe/Sofia")
    return result
}()

fileprivate extension Date {
    var hoursAndMinutes: String {
        dateFormatter.string(from: self)
    }
}

// MARK: - Previews

struct StationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StationView(store: .init(
                initialState: .init(
                    station: .gornaOryahovitsa
                ),
                reducer: StationReducer(),
                prepareDependencies: {
                    $0.context = .preview
                    $0.stationRepository.fetchTrainsAtStation = { _ in
                        testModels
                    }
                }
            ))
        }.previewDisplayName("Full list")
        
        NavigationView {
            StationView(store: .init(
                initialState: .init(
                    station: .gornaOryahovitsa
                ),
                reducer: StationReducer(),
                prepareDependencies: {
                    $0.context = .preview
                }
            ))
        }.previewDisplayName("Empty list")
        
        NavigationView {
            StationView(store: .init(
                initialState: .init(
                    station: .gornaOryahovitsa
                ),
                reducer: StationReducer(),
                prepareDependencies: {
                    $0.context = .preview
                    $0.stationRepository.fetchTrainsAtStation = { _ in
                        for await _ in TestClock().timer(interval: .seconds(420)) {
                            return testModels
                        }
                        return []
                    }
                }
            ))
        }.previewDisplayName("Loading")
    }
    
    private static var testModels: [TrainAtStation] =
        [
            .init(
                number: TrainNumber(
                    type: .suburban,
                    number: 2112
                ),
                from: .bulgarian(.sofia),
                to: .bulgarian(.gornaOryahovitsa),
                schedule: .departureOnly(Date(timeIntervalSince1970: 3600)),
                delay: nil,
                movement: .leavingStation
            ),
            .init(
                number: TrainNumber(
                    type: .suburban,
                    number: 2113
                ),
                from: .bulgarian(.sofia),
                to: .bulgarian(.gornaOryahovitsa),
                schedule: .departureOnly(Date(timeIntervalSince1970: 3600)),
                delay: .seconds(240),
                movement: .leavingStation
            ),
            .init(
                number: TrainNumber(
                    type: .fast,
                    number: 2112
                ),
                from: .bulgarian(.sofia),
                to: .bulgarian(.gornaOryahovitsa),
                schedule: .arrivalOnly(Date(timeIntervalSince1970: 3600)),
                delay: .seconds(240),
                movement: .inOperation
            ),
            .init(
                number: TrainNumber(
                    type: .normal,
                    number: 2112
                ),
                from: .bulgarian(.gornaOryahovitsa),
                to: .bulgarian(.sofia),
                schedule: .full(
                    arrival: Date(timeIntervalSince1970: 3600),
                    departure: Date(timeIntervalSince1970: 3660)
                ),
                delay: nil,
                movement: .notYetOperating
            ),
        ]
}
