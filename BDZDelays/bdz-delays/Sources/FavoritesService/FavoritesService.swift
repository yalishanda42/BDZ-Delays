import SharedModels

public struct FavoritesService {
    public var loadFavorites: () async throws -> [BGStation]
    public var saveFavorites: ([BGStation]) async throws -> Void
    
    public init(
        loadFavorites: @escaping () async throws -> [BGStation],
        saveFavorites: @escaping ([BGStation]) async throws -> Void
    ) {
        self.loadFavorites = loadFavorites
        self.saveFavorites = saveFavorites
    }
}
