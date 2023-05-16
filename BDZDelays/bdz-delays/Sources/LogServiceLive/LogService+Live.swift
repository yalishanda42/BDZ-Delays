import LogService
import Dependencies

extension LogService: DependencyKey {
    public static let liveValue = Self(providers: [
        StandardLoggingProvider(),
    ])
}
