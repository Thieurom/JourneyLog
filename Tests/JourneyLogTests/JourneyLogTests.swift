import XCTest
import JourneyLog

final class JourneyLogTests: XCTestCase {
    
    let identifier = "com.test.app"
    var log: JourneyLog<LogType>!
    var logStore: LogStore!
    
    override func setUp() {
        log = JourneyLog<LogType>(identifier: identifier)
        logStore = LogStore()
    }

    func testLogDebug() async {
        let inputMessage = "Make a request"
        log.debug(.api, inputMessage)
        
        let logEntries = await logStore.exportLogs(of: identifier)
        
        let outputMessage = "🟢 DEBUG - \(inputMessage)"
        XCTAssertEqual(logEntries.last, outputMessage)
    }
    
    func testLogInfo() async {
        let inputMessage = "App launches"
        log.info(.app, inputMessage)
        
        let logEntries = await logStore.exportLogs(of: identifier)

        let outputMessage = "🔵 INFO - \(inputMessage)"
        XCTAssertEqual(logEntries.last, outputMessage)
    }
    
    func testLogWarning() async {
        let inputMessage = "This might not work"
        log.warning(.app, inputMessage)
        
        let logEntries = await logStore.exportLogs(of: identifier)

        let outputMessage = "🟡 WARNING - \(inputMessage)"
        XCTAssertEqual(logEntries.last, outputMessage)
    }
    
    func testLogError() async {
        struct Error: Swift.Error {}
        
        let inputMessage = "There's an error: \(Error())"
        log.error(.api, inputMessage)
        
        let logEntries = await logStore.exportLogs(of: identifier)

        let outputMessage = "🔴 ERROR - \(inputMessage)"
        XCTAssertEqual(logEntries.last, outputMessage)
    }

    func testExportEntries() async throws {
        struct Error: Swift.Error {}
        
        let message = "A log message"

        log.debug(.api, message)
        log.info(.app, message)
        log.warning(.api, message)
        log.error(.app, message)
        
        let entries = try await log.exportEntries().suffix(4)
        
        let messages = ["🟢 DEBUG", "🔵 INFO", "🟡 WARNING", "🔴 ERROR"].map { "\($0) - \(message)" }
        XCTAssertEqual(entries.map(\.message), messages)
        
        let categories = [LogType.api, LogType.app, LogType.api, LogType.app].map(\.category)
        XCTAssertEqual(entries.map(\.category),categories)
    }
}
