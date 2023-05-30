//
//  DelaysWidget.swift
//  DelaysWidget
//
//  Created by AI on 30.05.23.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    typealias Entry = SimpleEntry
    
    func placeholder(in context: Context) -> Entry {
        Entry(date: Date(), configuration: SelectStationIntent())
    }

    func getSnapshot(
        for configuration: SelectStationIntent,
        in context: Context,
        completion: @escaping (Entry) -> ()
    ) {
        let entry = Entry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(
        for configuration: SelectStationIntent,
        in context: Context,
        completion: @escaping (Timeline<Entry>) -> ()
    ) {
        let entries: [Entry] = (0 ..< 30).map {  // nxt half an hour
            let now = Date()
            let entryDate = Calendar.current.date(byAdding: .minute, value: $0, to: now)!
            let entry = Entry(date: entryDate, configuration: configuration)
            return entry
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: SelectStationIntent
}

struct DelaysWidget: Widget {
    let kind: String = "DelaysWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SelectStationIntent.self, provider: Provider()) { entry in
            WidgetView(entry: entry)
        }
        .configurationDisplayName("Delays Widget")
        .description("This is the widget of the BDZ Delays app.")
    }
}
