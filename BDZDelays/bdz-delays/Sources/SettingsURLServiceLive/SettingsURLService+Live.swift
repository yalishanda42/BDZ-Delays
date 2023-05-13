//
//  File.swift
//  
//
//  Created by AI on 13.05.23.
//

import Foundation

#if canImport(UIKit)
import UIKit
private let url: URL? = URL(string: UIApplication.openSettingsURLString)
#else
private let url: URL? = nil
#endif

import SettingsURLService
import Dependencies

extension SettingsURLService: DependencyKey {
    public static let liveValue = Self(
        openSettings: {
            guard let url = url else { return }
            @Dependency(\.openURL) var openURL
            await openURL(url)
        }
    )
}
