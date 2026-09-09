//
//  NetworkConfiguration.swift
//  RickMortyAssignment
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import Foundation

/// Configuration for the HTTP client
final class NetworkConfiguration {
    let baseURL: URL
    let defaultHeaders: [String: String]
    let timeoutInterval: TimeInterval
    let environment: Environment
    
    enum Environment {
        case production
        case staging
        case development
    }
    
    init(
        baseURL: URL,
        environment: Environment = .production,
        timeoutInterval: TimeInterval = 30,
        defaultHeaders: [String: String] = [:]
    ) {
        self.baseURL = baseURL
        self.environment = environment
        self.timeoutInterval = timeoutInterval
        
        // Add standard headers
        var headers = defaultHeaders
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"
        headers["User-Agent"] = "RickMortyExplorer/1.0"
        self.defaultHeaders = headers
    }
}

