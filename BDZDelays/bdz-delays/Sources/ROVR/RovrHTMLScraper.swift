//
//  RovrHTMLScraper.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 22.04.23.
//

import Foundation
import RegexBuilder

import SwiftSoup

public enum RovrHTMLScraper {
    public enum ParseError: Error {
        case timetableParseError
    }
    
    public struct TrainData {
        public let type: String
        public let number: String
        public let to: String
        public let from: String?
        
        public let isOperating: Bool
        
        public let delayMinutes: Int?
        
        public let arrival: String?
        public let hasArrived: Bool
        
        public let departure: String?
        public let isAboutToLeave: Bool
        public let hasLeft: Bool
        
        public init(
            type: String,
            number: String,
            to: String,
            from: String?,
            isOperating: Bool,
            delayMinutes: Int?,
            arrival: String?,
            hasArrived: Bool,
            departure: String?,
            isAboutToLeave: Bool,
            hasLeft: Bool
        ) {
            self.type = type
            self.number = number
            self.to = to
            self.from = from
            self.isOperating = isOperating
            self.delayMinutes = delayMinutes
            self.arrival = arrival
            self.hasArrived = hasArrived
            self.departure = departure
            self.isAboutToLeave = isAboutToLeave
            self.hasLeft = hasLeft
        }
    }
    
    public static func scrapeHTML(_ htmlString: String) throws -> [TrainData] {
        let document = try SwiftSoup.parse(htmlString)
        
        guard
            let timetable = try document.getElementById("ttable"),
            let tbody = timetable.children().first
        else {
            return []  // no trains info
        }
        
        var currentTrainRows: [Element] = []
        var trainData: [TrainData] = []
        
        for row in tbody.children() {
            currentTrainRows.append(row)
            
            guard currentTrainRows.count == 3 else {
                continue
            }
            
            trainData.append(try .init(
                firstTr: currentTrainRows[0],
                secondTr: currentTrainRows[1],
                thirdTr: currentTrainRows[2]
            ))
            
            currentTrainRows = []
        }
        
        if !currentTrainRows.isEmpty {
            throw ParseError.timetableParseError
        }
        
        return trainData
    }
}

fileprivate extension RovrHTMLScraper.TrainData {
    init(firstTr: Element, secondTr: Element, thirdTr: Element) throws {
        self.init(
            type: try firstTr.child(0).text().split(separator: CharacterClass.whitespace)[0].string,
            number: try firstTr.child(0).text().split(separator: CharacterClass.whitespace)[1].string,
            to: try secondTr.child(0).text().dropFirst(3).string,  // removes "за "
            from: try thirdTr.child(0).text().nilIfEmpty?.dropFirst(3).string,  // removes "от "
            isOperating: try !thirdTr.child(1).text().isEmpty,
            delayMinutes: try secondTr.child(2).text().exctractDelay,
            arrival: try firstTr.child(3).text().nilIfEmpty,
            hasArrived: try secondTr.child(5).text() == "⇲",
            departure: try firstTr.child(5).text().nilIfEmpty,
            isAboutToLeave: try secondTr.child(4).attr("bgcolor").lowercased() == "#ffc0c0",
            hasLeft: try secondTr.child(5).text() == "...↗"
        )
    }
}

fileprivate extension Substring {
    var string: String {
        .init(self)
    }
}

fileprivate extension String {
    var nilIfEmpty: String? {
        self.isEmpty ? nil : self
    }
    
    var exctractDelay: Int? {
        let regex = Regex {
            "+"
            Capture {
                OneOrMore(.digit)
            }
            "'"
        }
        
        guard let match = firstMatch(of: regex) else {
            return nil
        }
        
        let (_, minutes) = match.output
        let result = Int(minutes)
        return result
    }
}
