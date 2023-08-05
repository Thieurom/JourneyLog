# JourneyLog

A simple wrapper of `os.Logger` and `OSLogStore` to log and export entries.

## Usage

1. Define your log types by conforming to `LogEvent`. It's preferable to group them into an `enum`:
  ```swift
  enum LogType: LogEventType {
      case app
      case api

      var category: String {
          switch self {
          case .app:
              return "App"
          case .api:
              return "API"
          }
      }
  }
  ```

2. Create a logger for your app:
  ```swift
  let log = JourneyLog<LogType>(identifier: "identifier")
  ```

  The provided "identifier" will identify your log as a subsystem in Apple's unified logging system. Typically, you use the same value as your app’s _bundle ID_, for example, `com.yourcompany.yourapp`.
3. Start logging:
  ```swift
  log.info(.app, "App launches")
  log.warning(.app, "Feature is not implemented")

  let url = URL(string: "www.example.com")!
  log.debug(.api, "Request: \(url)")

  let error = APIError.dataNotFound
  log.error(.api, "Request failed with error: \(error)")
  ```

  It will show to Xcode Console:
  ![](./.github/images/xcode-console-log.png?raw=true)

4. Export the log entries:

  ```swift
  do {
      let entries = try await log.exportEntries() // -> [LogEntry]
      let logText = entries
          .map {
              "\(dateFormatter.string(from: $0.date)) \($0.process) [\($0.category)] \($0.composedMessage)"
          }
  } catch {
      // Handle error
  }
  ```

## Installation
JourneyLog requires iOS from `15.0` and macOS from `12.0`.

You can add JourneyLog to an Xcode project as a package dependency.
> https://github.com/Thieurom/JourneyLog

If you want to use JourneyLog in a SwiftPM project, it's as simple as adding it to a dependencies clause in your Package.swift:
```swift
dependencies: [
  .package(url: "https://github.com/Thieurom/JourneyLog", from: "0.1.0")
]
```
