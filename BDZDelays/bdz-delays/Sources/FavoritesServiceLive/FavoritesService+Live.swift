import FavoritesService
import Dependencies
import ROVR

extension FavoritesService: DependencyKey {
    private static let realm = RealmActor()
    
    public static let liveValue = Self(
        loadFavorites: {
            try await realm.loadStationsSorted().compactMap {
                ROVRStation(rawValue: $0.id)?.asDomainStation
            }
        },
        saveFavorites: { favorites in
            let realmStations = favorites.enumerated().map { idx, domainStation in
                RealmStation(id: ROVRStation(domainStation).rawValue, index: idx)
            }
            
            try await realm.save(stations: realmStations)
        }
    )
}
