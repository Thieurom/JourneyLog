import OSLog

public class JourneyLog<LogEvent> where LogEvent: LogEventType {
    
    public let identifier: String
    private var loggers = [String: Logger]()
    
    public init(identifier: String) {
        self.identifier = identifier
    }
}

// Logging

extension JourneyLog {
    
    public func debug(_ event: LogEvent, _ message: String) {
        withLogger(for: event.category) {
            $0.debug("🟢 DEBUG - \(message)")
        }
    }
    
    public func info(_ event: LogEvent, _ message: String) {
        withLogger(for: event.category) {
            $0.info("🔵 INFO - \(message)")
        }
    }
    
    public func warning(_ event: LogEvent, _ message: String) {
        withLogger(for: event.category) {
            $0.warning("🟡 WARNING - \(message)")
        }
    }
    
    public func error(_ event: LogEvent, _ message: String) {
        withLogger(for: event.category) {
            $0.error("🔴 ERROR - \(message)")
        }
    }
    
    private func withLogger(for category: String, log: (inout Logger) -> Void) {
        if loggers[category] == nil {
            loggers[category] = Logger(subsystem: identifier, category: category)
        }
        
        var logger = loggers[category]!
        log(&logger)
    }
}

// Exporting

extension JourneyLog {
    
    public func exportEntries() async throws -> [LogEntry] {
        let store = try OSLogStore(scope: .currentProcessIdentifier)
        let position = store.position(timeIntervalSinceEnd: 1)
        return try store
            .getEntries(at: position)
            .compactMap { $0 as? OSLogEntryLog }
            .filter { $0.subsystem == identifier && loggers.map(\.key).contains($0.category) }
            .map { LogEntry(date: $0.date, message: $0.composedMessage, category: $0.category) }
    }
}
