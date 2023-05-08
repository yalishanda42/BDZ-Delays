import Foundation

public enum LocationStatus: Equatable {
    case notYetAskedForAuthorization
    case determining
    case authorized(nearestStation: BGStation?)
    case denied
    case unableToUseLocation
}
