//
//  StationPresentationView.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 22.04.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - View

struct StationPresentationView: View {
    let store: StoreOf<StationReducer>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            StationView(vm: viewStore.asViewModel)
                .onAppear {
                    viewStore.send(.refresh)
                }
        }
    }
}

// MARK: - Convertions

fileprivate extension ViewStore where ViewState == StationReducer.State, ViewAction == StationReducer.Action {
    var asViewModel: StationViewModel {
        .init(
            name: state.station.name,
            trains: state.trains.map { $0.asViewModel },
            refreshState: state.loadingState.asRefreshIndicatorState,
            updateDisplayTime: state.lastUpdateTime
                .map { $0.hoursAndMinutes },
            refreshAction: { self.send(.refresh) }
        )
    }
}

fileprivate extension StationReducer.State.TrainAtStation {
    var asViewModel: TrainViewModel {
        .init(
            id: number.asString,
            from: from.name,
            through: nil, // TODO
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

fileprivate extension StationReducer.State.RefreshState {
    var asRefreshIndicatorState: StationViewModel.RefreshIndicatorState {
        switch self {
        case .disabled: return .hidden
        case .enabled: return .refresh
        case .failed: return .warning
        case .loading: return .loading
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

struct StationPresentationView_Previews: PreviewProvider {
    static var previews: some View {
        StationPresentationView(store: .init(
            initialState: .init(
                station: .gornaOryahovitsa
            ),
            reducer: StationReducer(),
            prepareDependencies: {
                $0.context = .preview
            }
        ))
    }
}
