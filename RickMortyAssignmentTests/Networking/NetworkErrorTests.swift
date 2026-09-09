//
//  NetworkErrorTests.swift
//  RickMortyAssignmentTests
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import Testing
@testable import RickMortyAssignment

struct NetworkErrorTests {
    
    // MARK: - Tests: Error Description
    
    @Test
    func invalidURLErrorDescription() {
        let error = NetworkError.invalidURL
        #expect(error.errorDescription == "The URL is invalid.")
    }
    
    @Test
    func noInternetConnectionErrorDescription() {
        let error = NetworkError.noInternetConnection
        #expect(error.errorDescription == "No internet connection. Please check your network.")
    }
    
    @Test
    func requestTimeoutErrorDescription() {
        let error = NetworkError.requestTimeout
        #expect(error.errorDescription == "Request timeout. Please try again.")
    }
    
    @Test
    func invalidResponseErrorDescription() {
        let error = NetworkError.invalidResponse
        #expect(error.errorDescription == "Invalid server response.")
    }
    
    @Test
    func decodingErrorDescription() {
        let error = NetworkError.decodingError
        #expect(error.errorDescription == "Failed to decode server response.")
    }
    
    @Test
    func serverErrorDescription() {
        let error = NetworkError.serverError(500)
        #expect(error.errorDescription == "Server error: 500")
    }
    
    @Test
    func notFoundErrorDescription() {
        let error = NetworkError.notFound
        #expect(error.errorDescription == "The requested resource was not found.")
    }
    
    @Test
    func unauthorizedErrorDescription() {
        let error = NetworkError.unauthorized
        #expect(error.errorDescription == "You are not authorized to access this resource.")
    }
    
    @Test
    func forbiddenErrorDescription() {
        let error = NetworkError.forbidden
        #expect(error.errorDescription == "Access to this resource is forbidden.")
    }
    
    @Test
    func badRequestErrorDescription() {
        let error = NetworkError.badRequest
        #expect(error.errorDescription == "The request is invalid.")
    }
    
    @Test
    func unknownErrorDescription() {
        let error = NetworkError.unknown
        #expect(error.errorDescription == "An unknown error occurred.")
    }
    
    // MARK: - Tests: Equatable
    
    @Test
    func errorEquatable() {
        let error1 = NetworkError.invalidURL
        let error2 = NetworkError.invalidURL
        #expect(error1 == error2)
    }
    
    @Test
    func errorInequatable() {
        let error1 = NetworkError.invalidURL
        let error2 = NetworkError.noInternetConnection
        #expect(error1 != error2)
    }
    
    @Test
    func serverErrorEquatable() {
        let error1 = NetworkError.serverError(500)
        let error2 = NetworkError.serverError(500)
        #expect(error1 == error2)
    }
    
    @Test
    func serverErrorInequatable() {
        let error1 = NetworkError.serverError(500)
        let error2 = NetworkError.serverError(404)
        #expect(error1 != error2)
    }
}

