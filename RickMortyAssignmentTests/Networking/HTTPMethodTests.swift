//
//  HTTPMethodTests.swift
//  RickMortyAssignmentTests
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import Testing
import Foundation
@testable import RickMortyAssignment

// MARK: - Mock HTTP Request

struct MockHTTPRequest: HTTPRequest {
    typealias Response = MockResponse
    
    let endpoint: String = "test"
    let method: HTTPMethod = .get
    let queryParameters: [String: String]? = nil
}

struct MockResponse: Decodable {}

// MARK: - Tests: HTTPMethod

struct HTTPMethodTests {
    
    @Test
    func httpMethodRawValues() {
        #expect(HTTPMethod.get.rawValue == "GET")
        #expect(HTTPMethod.post.rawValue == "POST")
        #expect(HTTPMethod.put.rawValue == "PUT")
        #expect(HTTPMethod.delete.rawValue == "DELETE")
        #expect(HTTPMethod.patch.rawValue == "PATCH")
    }
    
    @Test
    func httpMethodCount() {
        let methods = [HTTPMethod.get, .post, .put, .delete, .patch]
        #expect(methods.count == 5)
    }
}

// MARK: - Tests: HTTPRequest

struct HTTPRequestTests {
    
    @Test
    func httpRequestDefaults() {
        let request = MockHTTPRequest()
        #expect(request.method == .get)
        #expect(request.headers == nil)
        #expect(request.queryParameters == nil)
        #expect(request.body == nil)
    }
    
    @Test
    func getCharactersRequest() {
        let request = GetCharactersRequest(page: 2)
        #expect(request.endpoint == "character")
        #expect(request.method == .get)
        #expect(request.queryParameters?["page"] == "2")
    }
    
    @Test
    func getEpisodesRequest() {
        let request = GetEpisodesRequest(ids: [1, 2, 3])
        #expect(request.endpoint == "episode/1,2,3")
        #expect(request.method == .get)
    }
    @MainActor
    @Test
    func getCharactersRequestPage1() {
        let request = GetCharactersRequest(page: 1)
        #expect(request.queryParameters?["page"] == "1")
    }
}

// MARK: - Tests: NetworkConfiguration

struct NetworkConfigurationTests {
    
    private let testURL = URL(string: "https://rickandmortyapi.com/api")!
    
    // MARK: - Tests: Initialization
    
    @Test
    func networkConfigurationInitialization() {
        let config = NetworkConfiguration(baseURL: testURL)
        
        #expect(config.baseURL == testURL)
        #expect(config.environment == NetworkConfiguration.Environment.production)
        #expect(config.timeoutInterval == 30)
    }
    
    @Test
    func networkConfigurationCustomTimeout() {
        let config = NetworkConfiguration(baseURL: testURL, timeoutInterval: 60)
        
        #expect(config.timeoutInterval == 60)
    }
    
    @Test
    func networkConfigurationEnvironment() {
        let production = NetworkConfiguration(baseURL: testURL, environment: .production)
        let staging = NetworkConfiguration(baseURL: testURL, environment: .staging)
        let development = NetworkConfiguration(baseURL: testURL, environment: .development)
        
        #expect(production.environment == NetworkConfiguration.Environment.production)
        #expect(staging.environment == NetworkConfiguration.Environment.staging)
        #expect(development.environment == NetworkConfiguration.Environment.development)
    }
    
    @Test
    func networkConfigurationDefaultHeaders() {
        let config = NetworkConfiguration(baseURL: testURL)
        
        #expect(config.defaultHeaders["Accept"] == "application/json")
        #expect(config.defaultHeaders["Content-Type"] == "application/json")
        #expect(config.defaultHeaders["User-Agent"] == "RickMortyExplorer/1.0")
    }
    
    @Test
    func networkConfigurationCustomHeaders() {
        let customHeaders = ["Authorization": "Bearer token123"]
        let config = NetworkConfiguration(
            baseURL: testURL,
            defaultHeaders: customHeaders
        )
        
        #expect(config.defaultHeaders["Authorization"] == "Bearer token123")
        #expect(config.defaultHeaders["Accept"] == "application/json")
    }
    
    @Test
    func networkConfigurationHeadersMerge() {
        let customHeaders = ["X-Custom": "value"]
        let config = NetworkConfiguration(
            baseURL: testURL,
            defaultHeaders: customHeaders
        )
        
        #expect(config.defaultHeaders["X-Custom"] == "value")
        #expect(config.defaultHeaders["Accept"] != nil)
    }
    
    @Test
    func environmentEnum() {
        let environments: [NetworkConfiguration.Environment] = [.production, .staging, .development]
        #expect(environments.count == 3)
    }
}

