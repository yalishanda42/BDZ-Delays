//
//  RovrDownloader.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 22.04.23.
//

import Foundation

public enum RovrDownloader {
    
    private static let baseURL = URL(string: "https://rovr.info/")!
    
    private static let headers: [String: String] = [
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Content-Type": "application/x-www-form-urlencoded",
        "Origin": "https://rovr.info",
        "Referer": "https://rovr.info/",
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.6.1 Safari/605.1.15",
    ]
    
    // MARK: - Page
    
    public static func downloadPageData(station: ROVRStation) async throws -> Data {
        let request: URLRequest = {
            var result = URLRequest(url: baseURL)
            result.httpMethod = "POST"
            result.allHTTPHeaderFields = headers
            let data: [String: String] = [
                "orientation": "P",
                "mobver": "1",
                "active_View": "2",
                "station_id": "\(station.rawValue)",
                "scrpos": "0",
            ]
            result.httpBody = parametrize(dict: data)
            return result
        }()
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
    
    // MARK: - Proximity info
    
    public struct Location {
        public let latitude: Double
        public let longitude: Double
        
        public init(latitude: Double, longitude: Double) {
            self.latitude = latitude
            self.longitude = longitude
        }
    }
    
    public static func downloadProximityData(to location: Location) async throws -> Data {
        let request: URLRequest = {
            let endpoint = "rovrandr.php"
            var result = URLRequest(url: baseURL.appending(component: endpoint))
            result.httpMethod = "POST"
            result.allHTTPHeaderFields = headers
            let data: [String: String] = [
                "user_alive": "0",
                "nav_data": "9999999999_704649791_\(location.latitude)_\(location.longitude)_null",
            ]
            result.httpBody = parametrize(dict: data)
            return result
        }()
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}

// MARK: - Helpers

private extension RovrDownloader {
    static func parametrize(dict: [String: String]) -> Data? {
        dict
            .map {
                "\($0.key)=\($0.value)"
            }.compactMap {
                $0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            }
            .joined(separator: "&")
            .data(using: .utf8)
    }
}
