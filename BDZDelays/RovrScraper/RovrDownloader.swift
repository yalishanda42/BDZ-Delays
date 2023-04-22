//
//  RovrDownloader.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 22.04.23.
//

import Foundation

enum RovrDownloader {
    static let url = URL(string: "https://rovr.info/")!
    
    static func downloadPageData(stationId: Int) async throws -> Data {
        let request: URLRequest = {
            var result = URLRequest(url: url)
            result.httpMethod = "POST"
            result.setValue(
                "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
                forHTTPHeaderField: "Accept"
            )
            result.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            result.setValue("https://rovr.info", forHTTPHeaderField: "Origin")
            result.setValue("rovr.info", forHTTPHeaderField: "Host")
            result.setValue("https://rovr.info/", forHTTPHeaderField: "Referer")
//            result.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.6.1 Safari/605.1.15", forHTTPHeaderField: "User-Agent")
            
            let data: [String: String] = [
                "orientation": "P",
                "mobver": "1",
                "active_View": "2",
                "station_id": "\(stationId)",
                "scrpos": "0",
            ]
            
            let joinedData = data
                .map {
                    "\($0.key)=\($0.value)"
                }.compactMap {
                    $0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                }
                .joined(separator: "&")
                .data(using: .utf8)
            
            result.httpBody = joinedData
            return result
        }()
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return data
    }
}
