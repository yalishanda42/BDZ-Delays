// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "bdz-delays",
    
    platforms: [.iOS(.v16), .macOS(.v13)],
    
    // MARK: - Products
    
    products: [
        // Train Reusable View
        .library(name: "TrainView", targets: ["TrainView"]),
        
        // Station Feature
        .library(name: "StationView", targets: ["StationView"]),
        .library(name: "StationDomain", targets: ["StationDomain"]),
        
        // Search Station Feature
        .library(name: "SearchStationView", targets: ["SearchStationView"]),
        .library(name: "SearchStationDomain", targets: ["SearchStationDomain"]),
        
        // Shared Models
        .library(name: "SharedModels", targets: ["SharedModels"]),
        
        // Services and repositoriss interfaces
        .library(name: "StationRepository", targets: ["StationRepository"]),
        .library(name: "LocationService", targets: ["LocationService"]),
        .library(name: "SettingsURLService", targets: ["SettingsURLService"]),
        .library(name: "FavoritesService", targets: ["FavoritesService"]),
        .library(name: "LogService", targets: ["LogService"]),
        
        // Services and repositories live implmentations
        .library(name: "StationRepositoryLive", targets: ["StationRepositoryLive"]),
        .library(name: "LocationServiceLive", targets: ["LocationServiceLive"]),
        .library(name: "SettingsURLServiceLive", targets: ["SettingsURLServiceLive"]),
        .library(name: "FavoritesServiceLive", targets: ["FavoritesServiceLive"]),
        .library(name: "LogServiceLive", targets: ["LogServiceLive"]),
        
        // ROVR scraping tools
        .library(name: "ROVR", targets: ["ROVR"]),
        
        // Custom Encodings
        .library(name: "CustomEncoding", targets: ["CustomEncoding"]),
    ],
    
    // MARK: - Dependencies
    
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.0.0"),
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.6.0"),
        .package(url: "https://github.com/realm/realm-swift.git", from: "10.39.1"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.5.2"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.9.0"),
    ],
    
    // MARK: - Targets
    
    targets: [
        
        // Train Reusable View
        
        .target(
            name: "TrainView",
            dependencies: []
        ),
        
        // Station Feature
        
        .target(
            name: "StationView",
            dependencies: ["StationDomain", "SharedModels", "TrainView"]
        ),
        .target(
            name: "StationDomain",
            dependencies: [
                "SharedModels",
                "StationRepository",
                "LogService",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "StationDomainTests",
            dependencies: ["StationDomain"]
        ),
        
        // Search Station Feature
        
        .target(
            name: "SearchStationView",
            dependencies: ["SearchStationDomain", "StationView", "SharedModels"]
        ),
        .target(
            name: "SearchStationDomain",
            dependencies: [
                "SharedModels",
                "StationDomain",
                "LocationService",
                "SettingsURLService",
                "FavoritesService",
                "LogService",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "SearchStationDomainTests",
            dependencies: ["SearchStationDomain"]
        ),
        
        // Shared Models
        
        .target(
            name: "SharedModels",
            dependencies: []
        ),
        
        // Services and repositories interfaces
        
        .target(
            name: "StationRepository",
            dependencies: [
                "SharedModels",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]
        ),
        .target(
            name: "LocationService",
            dependencies: [
                "SharedModels",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]
        ),
        .target(
            name: "SettingsURLService",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]
        ),
        .target(
            name: "FavoritesService",
            dependencies: [
                "SharedModels",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]
        ),
        .target(
            name: "LogService",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]
        ),
        
        // Services and repositories live implementations
        
        .target(
            name: "StationRepositoryLive",
            dependencies: [
                "StationRepository",
                "SharedModels",
                "ROVR",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]
        ),
        .target(
            name: "LocationServiceLive",
            dependencies: [
                "LocationService",
                "SharedModels",
                "ROVR",
                "LogService",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]
        ),
        .target(
            name: "SettingsURLServiceLive",
            dependencies: [
                "SettingsURLService",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]
        ),
        .target(
            name: "FavoritesServiceLive",
            dependencies: [
                "FavoritesService",
                "SharedModels",
                "ROVR",
                .product(name: "RealmSwift", package: "realm-swift"),
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]
        ),
        .target(
            name: "LogServiceLive",
            dependencies: [
                "LogService",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"),
            ]
        ),
        
        // ROVR scraping tools
        
        .target(
            name: "ROVR",
            dependencies: [
                "SharedModels",
                "CustomEncoding",
                "SwiftSoup",
            ]
        ),
        
        .testTarget(
            name: "ROVRTests",
            dependencies: [
                "ROVR",
            ],
            resources: [
                .process("Resources"),
            ]
        ),
        
        // Custom encodings
        
        .target(name: "CustomEncoding"),
    ]
)
