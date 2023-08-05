//
//  LogStore.swift
//  
//
//  Created by Doan Thieu on 21/07/2023.
//

import OSLog

class LogStore {
    
    func exportLogs(of subsytem: String) async -> [String] {
        do {
            let store = try OSLogStore(scope: .currentProcessIdentifier)
            let position = store.position(timeIntervalSinceEnd: 1)
            return try store
                .getEntries(at: position)
                .compactMap { $0 as? OSLogEntryLog }
                .filter { $0.subsystem == subsytem }
                .map(\.composedMessage)
        } catch {
            return []
        }
    }
}
