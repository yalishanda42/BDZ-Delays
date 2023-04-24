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
            arrival: arrival.map { $0.asDisplayTime },
            departure: departure.map { $0.asDisplayTime }
        )
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

fileprivate extension StationReducer.State.TrainTime {
    var asDisplayTime: TrainViewModel.DisplayTime {
        switch self {
        case .scheduled(let date):
            return .scheduled(date.hoursAndMinutes)
        case .punctual(let date):
            return .punctual(date.hoursAndMinutes)
        case .delayed(let originalSchedule, let delay):
            return .delayed(
                scheduled: originalSchedule.hoursAndMinutes,
                delay: "\(delay.minutes)",
                estimate: originalSchedule.addingDuration(delay).hoursAndMinutes
            )
        }
    }
}

fileprivate extension Duration {
    var minutes: Int64 {
        components.seconds / 60
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
