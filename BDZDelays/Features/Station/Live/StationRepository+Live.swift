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
            let rawData = try await RovrDownloader.downloadPageData(stationId: station.apiID)
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

fileprivate extension StationReducer.State.TrainAtStation.Schedule {
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

fileprivate extension StationReducer.State.TrainAtStation.MovementState {
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
        guard let bgStation = BGStation(string) else {
            self = .other(string)
            return
        }
        
        self = .bulgarian(bgStation)
    }
}

fileprivate extension BGStation {
    init?(_ string: String) {
        switch string.lowercased() {
        case "софия": self = .sofia
        case "горна оряховица": self = .gornaOryahovitsa
        default: return nil
        }
    }
    
    // MARK: - IDs
    
    var apiID: Int {
        switch self {
        case .sofia: return 18
        case .gornaOryahovitsa: return 238
        }
    }
}
