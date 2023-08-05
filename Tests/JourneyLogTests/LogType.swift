//
//  LogType.swift
//  
//
//  Created by Doan Thieu on 21/07/2023.
//

import JourneyLog

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
