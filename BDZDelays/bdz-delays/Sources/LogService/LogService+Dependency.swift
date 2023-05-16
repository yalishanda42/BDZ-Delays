import Dependencies

extension LogService: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

public extension DependencyValues {
    var log: LogService {
        get { self[LogService.self] }
        set { self[LogService.self] = newValue }
    }
}
