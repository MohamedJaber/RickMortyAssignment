//
//  NetworkError.swift
//  RickMortyAssignment
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import Foundation

enum NetworkError: LocalizedError, Equatable, Sendable {
    case invalidURL
    case noInternetConnection
    case requestTimeout
    case invalidResponse
    case decodingError
    case serverError(Int)
    case notFound
    case unauthorized
    case forbidden
    case badRequest
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .noInternetConnection:
            return "No internet connection. Please check your network."
        case .requestTimeout:
            return "Request timeout. Please try again."
        case .invalidResponse:
            return "Invalid server response."
        case .decodingError:
            return "Failed to decode server response."
        case .serverError(let code):
            return "Server error: \(code)"
        case .notFound:
            return "The requested resource was not found."
        case .unauthorized:
            return "You are not authorized to access this resource."
        case .forbidden:
            return "Access to this resource is forbidden."
        case .badRequest:
            return "The request is invalid."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

