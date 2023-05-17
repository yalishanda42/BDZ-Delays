public protocol LogProvider {
    func log(
        _ level: LogService.Level,
        _ message: String,
        file: String,
        function: String,
        line: UInt
    )
}

public struct LogService {
    public enum Level {
        case info
        case error(Error)
    }
    
    let providers: [LogProvider]
    
    public init(providers: [LogProvider] = []) {
        self.providers = providers
    }
    
    public func info(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        log(.info, message, file: file, function: function, line: line)
    }
    
    public func error(
        _ error: Error,
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        log(.error(error), message, file: file, function: function, line: line)
    }
    
    internal func log(
        _ level: Level,
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        for provider in providers {
            provider.log(level, message, file: file, function: function, line: line)
        }
    }
}
