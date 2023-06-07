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
        IntentConfiguration(kind: kind, intent: SelectStationIntent.self, provider: TrainsTimelineProvider()) { entry in
            WidgetView(entry: entry)
        }
        .configurationDisplayName("БДЖ Закъснения")
        .description("Тази джаджа ви показва движението на влаковете от/към избрана гара в реално време за следващите 6 часа.")
    }
}
