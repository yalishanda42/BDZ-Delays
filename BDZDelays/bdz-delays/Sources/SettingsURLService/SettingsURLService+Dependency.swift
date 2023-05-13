import Dependencies

extension SettingsURLService: TestDependencyKey {
    public static let testValue = Self(
        openSettings: unimplemented("SetingsURLService.openSettings")
    )
    
    public static let previewValue = Self(
        openSettings: {}
    )
}

public extension DependencyValues {
    var settingsService: SettingsURLService {
        get { self[SettingsURLService.self] }
        set { self[SettingsURLService.self] = newValue }
    }
}
