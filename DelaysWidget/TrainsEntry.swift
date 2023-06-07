//
//  TrainsEntry.swift
//  DelaysWidgetExtension
//
//  Created by AI on 7.06.23.
//

import WidgetKit

import SharedModels

struct TrainsEntry: TimelineEntry {
    let date: Date
    let configuration: SelectStationIntent
    let result: Result<[TrainAtStation], Error>?
}
