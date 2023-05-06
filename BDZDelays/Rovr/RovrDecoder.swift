//
//  RovrDecoder.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 6.05.23.
//

import Foundation

enum RovrDecoder {
    enum Error: Swift.Error {
        case invalidEncoding
        case invalidData
    }
    
    static func decode(pageData: Data) throws -> String {
        // Unfortunately, `String(data: pageData, encoding: .windowsCP1251)`
        // returns `nil` for some reason, although the data appears to be in the
        // Windows 1251 encoding.
        // This required to write a custom encoding implementation
        // so that at least we can have the cyrillic letters decoded correctly.
        return String(decoding: pageData, as: WindowsCP1251.self)
    }
    
    static func decodeStationId(fromLocationData data: Data) throws -> Int {
        guard let string = String(data: data, encoding: .utf8) else {
            throw Error.invalidEncoding
        }
        
        // Response looks like this:
        // 1683384235 18 2021.6069047926 1626 1059.1314442427
        // The second number is the station ID.
        let parts = string.split(separator: " ")
        guard parts.count > 2,
              let id = Int(parts[1])
        else {
            throw Error.invalidData
        }
        
        return id
    }
}
