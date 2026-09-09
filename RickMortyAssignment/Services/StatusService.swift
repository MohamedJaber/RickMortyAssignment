//
//  StatusService.swift
//  RickMortyAssignment
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import SwiftUI

/// Centralized service for character status handling
enum StatusService {
    enum CharacterStatus: String, CaseIterable, Hashable {
        case alive = "Alive"
        case dead = "Dead"
        case unknown = "Unknown"
        
        init?(rawValue: String) {
            let normalized = rawValue.trimmingCharacters(in: .whitespaces).lowercased()
            switch normalized {
            case "alive": self = .alive
            case "dead": self = .dead
            default: self = .unknown
            }
        }
        
        var color: Color {
            switch self {
            case .alive: return .green
            case .dead: return .red
            case .unknown: return .gray
            }
        }
        
        var icon: String {
            switch self {
            case .alive: return "✓"
            case .dead: return "✕"
            case .unknown: return "?"
            }
        }
    }
    
    /// Get status from raw string value
    static func status(for rawValue: String) -> CharacterStatus {
        CharacterStatus(rawValue: rawValue) ?? .unknown
    }
    
    /// Get color for status string
    static func color(for status: String) -> Color {
        Self.status(for: status).color
    }
    
    /// Get icon for status string
    static func icon(for status: String) -> String {
        Self.status(for: status).icon
    }
    
    /// All available status values for UI
    static var allStatusOptions: [String] {
        CharacterStatus.allCases.map { $0.rawValue }
    }
}

