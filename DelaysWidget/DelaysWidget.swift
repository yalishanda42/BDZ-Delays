//
//  DelaysWidget.swift
//  DelaysWidget
//
//  Created by AI on 30.05.23.
//

import WidgetKit
import SwiftUI
import Intents

struct DelaysWidget: Widget {
    let kind: String = "DelaysWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: SelectStationIntent.self,
            provider: TrainsTimelineProvider()
        ) { entry in
            WidgetView(entry: entry)
                .widgetURL(URL(string: "bdzdelays://station/\(entry.configuration.station ?? "")"))
        }
        .configurationDisplayName("БДЖ Закъснения")
        .description("Показва движението на влаковете от/към избрана гара в реално време за следващите 6 часа. След добавяне, натиснете джаджата за да изберете гара.")
    }
}
