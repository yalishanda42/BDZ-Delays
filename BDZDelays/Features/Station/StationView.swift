//
//  StationView.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 22.04.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - View

struct StationView: View {
    let store: StoreOf<StationReducer>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { vs in
            AnyView(content(vs))
                .navigationTitle(vs.station.name)
                .toolbar {
                    if let time = vs.lastUpdateTime {
                        Text(time.hoursAndMinutes)
                    }
                    
                    switch vs.loadingState {
                    case .loading where !vs.trains.isEmpty:
                        ProgressView()
                    case .failed:
                        Button {
                            vs.send(.refresh)
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.red)
                        }
                    case .enabled:
                        Button {
                            vs.send(.refresh)
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                    default:
                        EmptyView()
                    }
                }
                .onAppear {
                    vs.send(.refresh)
                }
        }
    }
    
    private func content(_ vs: ViewStoreOf<StationReducer>) -> any View {
        switch vs.loadingState {
        case .loading where vs.trains.isEmpty:
            return ProgressView()
        case .failed where vs.trains.isEmpty:
            return VStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                Text("Неуспешен опит за взимане на данните. Дали имате интернет?")
            }
        case .enabled where vs.trains.isEmpty,
             .disabled where vs.trains.isEmpty:
            return Text("Няма пътнически влакове за следващите 6 часа.")
        default:
            return List(vs.trains) { train in
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

// MARK: - Convertions

fileprivate extension StationReducer.State.TrainAtStation {
    var asViewModel: TrainViewModel {
        .init(
            id: number.asString,
            from: from.name,
            through: nil,
            to: to.name,
            operation: movement.asOperationState,
            arrival: arrivalDisplayTime,
            departure: departureDisplayTime
        )
    }
    
    var arrivalDisplayTime: TrainViewModel.DisplayTime? {
        switch schedule {
        case .arrivalOnly(let arrival),
                .full(arrival: let arrival, departure: _):
            return displayTimeFrom(arrival)
        default:
            return nil
        }
    }
    
    var departureDisplayTime: TrainViewModel.DisplayTime? {
        switch schedule {
        case .departureOnly(let departure),
                .full(arrival: _, departure: let departure):
            return displayTimeFrom(departure)
        default:
            return nil
        }
    }
    
    func displayTimeFrom(_ scheduled: Date) -> TrainViewModel.DisplayTime {
        .init(
            scheduled: scheduled.hoursAndMinutes,
            delay: delay.map { TrainViewModel.Delay(
                minutes: $0.minutes,
                estimate: scheduled.addingDuration($0).hoursAndMinutes
            )}
        )
    }
}

fileprivate extension StationReducer.State.TrainAtStation.MovementState {
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
    }
    
    private static var testModels: [StationReducer.State.TrainAtStation] =
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
