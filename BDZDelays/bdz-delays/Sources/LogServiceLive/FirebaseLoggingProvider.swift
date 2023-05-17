import LogService
import FirebaseCrashlytics
import Firebase

public enum Firebase {
    public static func initialize(plistPath: String) {
        let options = FirebaseOptions(contentsOfFile: plistPath)!
        FirebaseApp.configure(options: options)
    }
}

struct FirebaseLoggingProvider: LogProvider {
    private static let crashlytics = Crashlytics.crashlytics()
    
    func log(
        _ level: LogService.Level,
        _ message: String,
        file: String,
        function: String,
        line: UInt
    ) {
        switch level {
        case .info:
            Self.log(message, file: file, function: function, line: line)
        case .error(let error):
            Self.log(message, file: file, function: function, line: line)
            Self.crashlytics.record(error: error)
        }
    }
    
    private static func log(
        _ message: String,
        file: String,
        function: String,
        line: UInt
    ) {
        let msg = "[\(file.split(separator: "/").last ?? "")::\(function)::\(line)] \(message)"
        Self.crashlytics.log(msg)
    }
}
