//
//  DelaysWidget.swift
//  DelaysWidget
//
//  Created by AI on 30.05.23.
//

import WidgetKit
import SwiftUI
import Intents

import Dependencies

import SharedModels
import StationRepository
import StationRepositoryLive

struct Provider: IntentTimelineProvider {
    typealias Entry = SimpleEntry
    
    @Dependency(\.stationRepository) var repository
    
    func placeholder(in context: Context) -> Entry {
        Entry(date: Date(), configuration: SelectStationIntent(), result: .success(prevewiewData))
    }

    func getSnapshot(
        for configuration: SelectStationIntent,
        in context: Context,
        completion: @escaping (Entry) -> ()
    ) {
        let entry = Entry(
            date: Date(),
            configuration: configuration,
            result: .success(prevewiewData)
        )
        completion(entry)
    }

    func getTimeline(
        for configuration: SelectStationIntent,
        in context: Context,
        completion: @escaping (Timeline<Entry>) -> ()
    ) {
        Task {
            let trainsResult: Result<[TrainAtStation], Error>?
            
            defer {
                let now = Date()
                let entry = Entry(date: now, configuration: configuration, result: trainsResult)
                let refreshDate = Calendar.current.date(byAdding: .minute, value: 1, to: now)!
                let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                completion(timeline)
            }
            
            guard
                let name = configuration.station,
                let station = BGStation(name: name)
            else {
                trainsResult = nil
                return
            }
            
            do {
                trainsResult = .success(try await repository.fetchTrainsAtStation(station))
            } catch let error {
                trainsResult = .failure(error)
            }
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: SelectStationIntent
    let result: Result<[TrainAtStation], Error>?
}

struct DelaysWidget: Widget {
    let kind: String = "DelaysWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SelectStationIntent.self, provider: Provider()) { entry in
            WidgetView(entry: entry)
        }
        .configurationDisplayName("БДЖ Закъснения")
        .description("Тази джаджа ви показва движението на влаковете от/към избрана гара в реално време за следващите 6 часа.")
    }
}

fileprivate let prevewiewData: [TrainAtStation] = [
    .init(
        number: TrainNumber(
            type: .suburban,
            number: 2112
        ),
        from: .bulgarian(.sofia),
        to: .bulgarian(.varna),
        schedule: .departureOnly(Date(timeIntervalSince1970: 3600)),
        delay: nil,
        movement: .leavingStation
    ),
    .init(
        number: TrainNumber(
            type: .suburban,
            number: 21123
        ),
        from: .bulgarian(.sofia),
        to: .bulgarian(.burgas),
        schedule: .departureOnly(Date(timeIntervalSince1970: 3600)),
        delay: .seconds(240),
        movement: .leavingStation
    ),
    .init(
        number: TrainNumber(
            type: .fast,
            number: 2212
        ),
        from: .bulgarian(.sofia),
        to: .bulgarian(.vraca),
        schedule: .arrivalOnly(Date(timeIntervalSince1970: 3600)),
        delay: .seconds(240),
        movement: .inOperation
    ),
    .init(
        number: TrainNumber(
            type: .normal,
            number: 2312
        ),
        from: .bulgarian(.plovdiv),
        to: .bulgarian(.sofia),
        schedule: .full(
            arrival: Date(timeIntervalSince1970: 3600),
            departure: Date(timeIntervalSince1970: 3660)
        ),
        delay: nil,
        movement: .notYetOperating
    ),
]
