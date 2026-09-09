//
//  HTTPClient.swift
//  RickMortyAssignment
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import Foundation

/// Generic HTTP client for making network requests
protocol HTTPClientProtocol {
    func execute<Request: HTTPRequest>(_ request: Request) async throws -> Request.Response
}

final class HTTPClient: HTTPClientProtocol {
    private let session: URLSession
    private let configuration: NetworkConfiguration
    private let interceptors: [NetworkInterceptor]
    private let logger: NetworkLogger
    
    init(
        configuration: NetworkConfiguration,
        session: URLSession = .shared,
        interceptors: [NetworkInterceptor] = [],
        logger: NetworkLogger = DefaultNetworkLogger()
    ) {
        self.configuration = configuration
        self.session = session
        self.interceptors = interceptors
        self.logger = logger
    }
    
    func execute<Request: HTTPRequest>(_ request: Request) async throws -> Request.Response {
        // Build URL request
        var urlRequest = try buildURLRequest(for: request)
        
        // Apply interceptors (pre-request)
        for interceptor in interceptors {
            urlRequest = try interceptor.onRequest(urlRequest)
        }
        
        logger.logRequest(urlRequest)
        
        // Execute request
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.logError("Invalid response type")
            throw NetworkError.invalidResponse
        }
        
        logger.logResponse(httpResponse, data: data)
        
        // Apply interceptors (post-response)
        for interceptor in interceptors {
            try interceptor.onResponse(httpResponse)
        }
        
        // Validate status code
        try validateStatusCode(httpResponse.statusCode)
        
        // Decode response
        return try decodeResponse(Request.Response.self, from: data)
    }
    
    private func buildURLRequest<Request: HTTPRequest>(for request: Request) throws -> URLRequest {
        // Build URL
        var urlComponents = URLComponents(url: configuration.baseURL.appendingPathComponent(request.endpoint), resolvingAgainstBaseURL: true)
        
        if let queryParameters = request.queryParameters {
            urlComponents?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents?.url else {
            throw NetworkError.invalidURL
        }
        
        // Create request
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.timeoutInterval = configuration.timeoutInterval
        
        // Add default headers
        for (key, value) in configuration.defaultHeaders {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add custom headers
        if let headers = request.headers {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Add body if needed
        if let body = request.body {
            urlRequest.httpBody = try JSONEncoder().encode(body)
        }
        
        return urlRequest
    }
    
    private func validateStatusCode(_ statusCode: Int) throws {
        switch statusCode {
        case 200...299:
            break
        case 400:
            throw NetworkError.badRequest
        case 401:
            throw NetworkError.unauthorized
        case 403:
            throw NetworkError.forbidden
        case 404:
            throw NetworkError.notFound
        case 500...599:
            throw NetworkError.serverError(statusCode)
        default:
            throw NetworkError.invalidResponse
        }
    }
    
    private func decodeResponse<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(type, from: data)
        } catch {
            logger.logError("Decoding error: \(error.localizedDescription)")
            throw NetworkError.decodingError
        }
    }
}

// MARK: - Network Interceptor

protocol NetworkInterceptor {
    func onRequest(_ request: URLRequest) throws -> URLRequest
    func onResponse(_ response: HTTPURLResponse) throws
}

extension NetworkInterceptor {
    func onRequest(_ request: URLRequest) throws -> URLRequest { request }
    func onResponse(_ response: HTTPURLResponse) throws {}
}

// MARK: - Network Logger

protocol NetworkLogger {
    func logRequest(_ request: URLRequest)
    func logResponse(_ response: HTTPURLResponse, data: Data)
    func logError(_ message: String)
}

struct DefaultNetworkLogger: NetworkLogger {
    func logRequest(_ request: URLRequest) {
        AppLogger.network.debug("📡 Request: \(request.httpMethod ?? "GET") \(request.url?.absoluteString ?? "")")
    }
    
    func logResponse(_ response: HTTPURLResponse, data: Data) {
        AppLogger.network.debug("✅ Response: \(response.statusCode) from \(response.url?.absoluteString ?? "")")
    }
    
    func logError(_ message: String) {
        AppLogger.network.error("❌ Error: \(message)")
    }
}
