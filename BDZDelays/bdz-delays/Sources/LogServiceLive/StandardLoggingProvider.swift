import LogService
import Logging

struct StandardLoggingProvider: LogProvider {
    private static let logger = Logger(label: "bdz-delays")
    
    func log(
        _ level: LogService.Level,
        _ message: String,
        file: String,
        function: String,
        line: UInt
    ) {
        let source = "\(file.split(separator: "/").last ?? "")::\(function)::\(line)"
        switch level {
        case .info:
            Self.logger.info("\(message)", source: source)
        case .error(let error):
            Self.logger.error("\(message); error=\(error)", source: source)
        }
    }
}
