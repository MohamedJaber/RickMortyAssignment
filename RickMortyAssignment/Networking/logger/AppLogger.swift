//
//  AppLogger.swift
//  RickMortyAssignment
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import Foundation
import os

/// Centralized logging system for the entire app
/// Usage: AppLogger.network.error("Failed to load data")
enum AppLogger {
    case network
    case persistence
    case database
    case authentication
    case ui
    
    /// Get the appropriate OSLog for this category
    nonisolated private var osLog: OSLog {
        let subsystem = "com.rickmortyexplorer"
        switch self {
        case .network:
            return OSLog(subsystem: subsystem, category: "Network")
        case .persistence:
            return OSLog(subsystem: subsystem, category: "Persistence")
        case .database:
            return OSLog(subsystem: subsystem, category: "Database")
        case .authentication:
            return OSLog(subsystem: subsystem, category: "Authentication")
        case .ui:
            return OSLog(subsystem: subsystem, category: "UI")
        }
    }
    
    // MARK: - Debug Level
    nonisolated func debug(_ message: String, file: String = #file, line: Int = #line) {
        os_log("[DEBUG] %s:%d - %s", log: osLog, type: .debug, (file as NSString).lastPathComponent, line, message)
    }
    
    // MARK: - Info Level
    nonisolated func info(_ message: String, file: String = #file, line: Int = #line) {
        os_log("[INFO] %s:%d - %s", log: osLog, type: .info, (file as NSString).lastPathComponent, line, message)
    }
    
    // MARK: - Warning Level
    nonisolated func warning(_ message: String, file: String = #file, line: Int = #line) {
        os_log("[WARNING] %s:%d - %s", log: osLog, type: .default, (file as NSString).lastPathComponent, line, message)
    }
    
    // MARK: - Error Level
    nonisolated func error(_ message: String, file: String = #file, line: Int = #line) {
        os_log("[ERROR] %s:%d - %s", log: osLog, type: .error, (file as NSString).lastPathComponent, line, message)
    }
    
    // MARK: - Fault Level (Critical)
    nonisolated func fault(_ message: String, file: String = #file, line: Int = #line) {
        os_log("[FAULT] %s:%d - %s", log: osLog, type: .fault, (file as NSString).lastPathComponent, line, message)
    }
}
