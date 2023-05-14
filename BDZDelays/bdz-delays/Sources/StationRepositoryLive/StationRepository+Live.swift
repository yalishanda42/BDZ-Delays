//
//  StationRepository+Live.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 22.04.23.
//

import Foundation
import Dependencies

import StationRepository
import SharedModels
import ROVR

extension StationRepository: DependencyKey {
    public static let liveValue: Self = {
        
        @Dependency(\.date.now) var now
        @Dependency(\.calendar) var calendar
        // TODO: make the scraper a dependency too
        
        let cache = CacheActor()
        
        return Self(
            fetchTrainsAtStation: { station -> [TrainAtStation] in
                let station = ROVRStation(station)
                
                let cacheEntry = await cache.retrieve(for: station.rawValue)
                let isInTheSameMinute = cacheEntry
                    .map {
                        let components: Set<Calendar.Component> = [.day, .hour, .minute]
                        let entryComponents = calendar.dateComponents(components, from: $0.date)
                        let nowComponents = calendar.dateComponents(components, from: now)
                        return entryComponents == nowComponents
                    }
                
                if let entry = cacheEntry, isInTheSameMinute == true {
                    // ROVR updates the available data every whole minute
                    // so there is no point in refetching for the same minute.
                    return entry.trains
                }
                
                let rawData = try await RovrDownloader.downloadPageData(station: station)
                let htmlString = try RovrDecoder.decode(pageData: rawData)
                let scrapedTrains = try RovrHTMLScraper.scrapeHTML(htmlString)
                let result = try scrapedTrains.map {
                    try TrainAtStation($0, station: station.asDomainStation)
                }
                
                await cache.updateValue(.init(date: now, trains: result), forKey: station.rawValue)
                
                return result
            }
        )
    }()
}

// MARK: - Cache

fileprivate actor CacheActor {
    private var cache: [Int: Entry] = [:]
    
    func retrieve(for key: Int) -> Entry? {
        return cache[key]
    }
    
    func updateValue(_ value: Entry?, forKey key: Int) {
        cache[key] = value
    }
}

extension CacheActor {
    struct Entry {
        let date: Date
        let trains: [TrainAtStation]
    }
}

// MARK: - Convertions

fileprivate extension TrainAtStation {
    init(_ data: RovrHTMLScraper.TrainData, station: BGStation) throws {
        self.init(
            number: TrainNumber(
                type: try TrainType(data.type),
                number: Int(data.number) ?? 0
            ),
            from: data.from.map(Station.init) ?? .bulgarian(station),
            to: Station(data.to),
            schedule: try .init(data),
            delay: data.delayMinutes.map { Duration.seconds($0 * 60) },
            movement: .init(data)
        )
    }
}

fileprivate let dateFormatter: DateFormatter = {
    let result = DateFormatter()
    result.dateFormat = "HH:mm"
    result.timeZone = TimeZone(identifier: "Europe/Sofia")
    return result
}()

fileprivate extension String {
    func asDate() throws -> Date {
        guard let date = dateFormatter.date(from: self) else {
            throw StationRepositoryError.invalidData
        }
        
        return date
    }
}

fileprivate extension TrainAtStation.Schedule {
    init(_ data: RovrHTMLScraper.TrainData) throws {
        switch (data.arrival, data.departure) {
        case let (.some(arrival), .some(departure)):
            self = .full(arrival: try arrival.asDate(), departure: try departure.asDate())
        case let (.some(arrival), .none):
            self = .arrivalOnly(try arrival.asDate())
        case let (.none, .some(departure)):
            self = .departureOnly(try departure.asDate())
        case (.none, .none):
            throw StationRepositoryError.invalidData
        }
    }
}

fileprivate extension TrainAtStation.MovementState {
    init(_ data: RovrHTMLScraper.TrainData) {
        if data.isOperating {
            self = .inOperation
        } else if data.isAboutToLeave {
            self = .doorsOpen
        } else if data.hasLeft {
            self = .leavingStation
        } else if data.hasArrived {
            self = .stopped
        } else {
            self = .notYetOperating
        }
    }
}

fileprivate extension TrainType {
    init(_ string: String) throws {
        switch string {
        case "КПВ": self = .suburban
        case "ПВ": self = .normal
        case "БВ": self = .fast
        case "МБВ": self = .international
        default: self = .other(string)
        }
    }
}


fileprivate extension Station {
    init(_ string: String) {
        guard
            let rovrStation = ROVRStation(string)
        else {
            self = .other(string)
            return
        }
        
        self = .bulgarian(rovrStation.asDomainStation)
    }
}
