//
//  StationRepository+Live.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 22.04.23.
//

import Foundation
import Dependencies

extension StationRepository: DependencyKey {
    static let liveValue = Self(
        fetchTrainsAtStation: { station in
            let rawData = try await RovrDownloader.downloadPageData(stationId: station.id)
            let htmlString = try RovrHTMLScraper.decode(pageData: rawData)
            let scrapedTrains = try RovrHTMLScraper.parseHTML(htmlString)
            return try scrapedTrains.map {
                try StationReducer.State.TrainAtStation($0, station: station)
            }
        }
    )
}

// MARK: - Convertions

fileprivate extension StationReducer.State.TrainAtStation {
    init(_ data: RovrHTMLScraper.TrainData, station: Station) throws {
        self.init(
            number: TrainNumber(
                type: try TrainType(data.type),
                number: Int(data.number) ?? 0
            ),
            from: data.from.map(Station.init) ?? station,
            to: Station(data.to),
            arrival: .init(arrivalTimeFromData: data),
            departure: .init(departureTimeFromData: data)
        )
    }
}

fileprivate let dateFormatter: DateFormatter = {
    let result = DateFormatter()
    result.dateFormat = "HH:mm"
    result.timeZone = TimeZone(identifier: "Europe/Sofia")
    return result
}()

fileprivate extension StationReducer.State.TrainTime {
    init?(arrivalTimeFromData data: RovrHTMLScraper.TrainData) {
        guard
            let arrivalString = data.arrival,
            let arrivalDate = dateFormatter.date(from: arrivalString)
        else {
            return nil
        }
        
        if let delayInMinutes = data.delayMinutes {
            self = .delayed(originalSchedule: arrivalDate, delay: .seconds(delayInMinutes * 60))
        } else if data.isOperating {
            self = .punctual(arrivalDate)
        } else {
            self = .scheduled(arrivalDate)
        }
    }
    
    init?(departureTimeFromData data: RovrHTMLScraper.TrainData) {
        guard
            let departureString = data.departure,
            let departurelDate = dateFormatter.date(from: departureString)
        else {
            return nil
        }
        
        if let delayInMinutes = data.delayMinutes {
            self = .delayed(originalSchedule: departurelDate, delay: .seconds(delayInMinutes * 60))
        } else if data.isOperating {
            self = .punctual(departurelDate)
        } else {
            self = .scheduled(departurelDate)
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
        switch string.lowercased() {
        case "софия": self = .sofia
        case "горна оряховица": self = .gornaOryahovitsa
        default: self = .other(string)
        }
    }
    
    // MARK: - IDs
    
    var id: Int {
        switch self {
        case .sofia: return 18
        case .gornaOryahovitsa: return 238
        case .other: return 0
        }
    }
}
