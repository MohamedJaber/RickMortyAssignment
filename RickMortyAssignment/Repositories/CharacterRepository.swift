//
//  CharacterRepository.swift
//  RickMortyAssignment
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import Foundation

// MARK: - Character Request Types

struct GetCharactersRequest: HTTPRequest {
    typealias Response = CharacterResponse

    let page: Int

    var endpoint: String { "character" }
    var queryParameters: [String: String]? { ["page": String(page)] }
}

// MARK: - Character Repository
protocol CharacterRepositoryProtocol {
    func getCharacters(page: Int) async throws -> CharacterResponse
}

final class CharacterRepository: CharacterRepositoryProtocol {
    private let httpClient: HTTPClientProtocol
    private var cachedCharacters: [Int: Character] = [:]

    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }
    
    func getCharacters(page: Int) async throws -> CharacterResponse {
        let request = GetCharactersRequest(page: page)
        return try await httpClient.execute(request)
    }
}

