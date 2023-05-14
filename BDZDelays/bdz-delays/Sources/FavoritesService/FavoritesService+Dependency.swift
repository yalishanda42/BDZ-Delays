import Dependencies

extension FavoritesService: TestDependencyKey {
    public static let testValue = Self(
        loadFavorites: unimplemented("FavoritesService.loadFavorites"),
        saveFavorites: unimplemented("FavoritesService.saveFavorites")
    )
    
    public static let previewValue = Self(
        loadFavorites: { [] },
        saveFavorites: { _ in }
    )
}

public extension DependencyValues {
    var favoritesService: FavoritesService {
        get { self[FavoritesService.self] }
        set { self[FavoritesService.self] = newValue }
    }
}
