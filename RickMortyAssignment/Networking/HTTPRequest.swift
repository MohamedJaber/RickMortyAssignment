//
//  HTTPRequest.swift
//  RickMortyAssignment
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import Foundation

/// Generic HTTP request protocol for any API
protocol HTTPRequest {
    associatedtype Response: Decodable
    
    var endpoint: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryParameters: [String: String]? { get }
    var body: Encodable? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

extension HTTPRequest {
    var method: HTTPMethod { .get }
    var headers: [String: String]? { nil }
    var queryParameters: [String: String]? { nil }
    var body: Encodable? { nil }
}

