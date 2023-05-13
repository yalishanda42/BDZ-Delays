import Foundation

public struct SettingsURLService {
    public var openSettings: () async -> Void
    
    public init(openSettings: @escaping () async -> Void) {
        self.openSettings = openSettings
    }
    
    public func callAsFuntion() async {
        await openSettings()
    }
}
