//
//  EpisodeRepository.swift
//  RickMortyAssignment
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import Foundation

// MARK: - Episode Request Types

struct GetEpisodesRequest: HTTPRequest {
    typealias Response = EpisodeBatch
    
    let ids: [Int]

    var endpoint: String {
        let idString = ids.map(String.init).joined(separator: ",")
        return "episode/\(idString)"
    }
}

// Helper type for decoding multiple episodes
struct EpisodeBatch: Decodable {
    let episodes: [Episode]
    
    init(from decoder: Decoder) throws {
        // Handle both single episode and array of episodes
        let container = try decoder.singleValueContainer()
        if let episode = try? container.decode(Episode.self) {
            episodes = [episode]
        } else {
            episodes = try container.decode([Episode].self)
        }
    }
}

// MARK: - Episode Repository

protocol EpisodeRepositoryProtocol {
    func getEpisodes(ids: [Int]) async throws -> [Episode]
}

final class EpisodeRepository: EpisodeRepositoryProtocol {
    private let httpClient: HTTPClientProtocol
    private var cachedEpisodes: [Int: Episode] = [:]
    
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }
    
    func getEpisodes(ids: [Int]) async throws -> [Episode] {
        var uncachedIds: [Int] = []
        var cachedEpisodes: [Episode] = []
        
        for id in ids {
            if let cached = self.cachedEpisodes[id] {
                cachedEpisodes.append(cached)
            } else {
                uncachedIds.append(id)
            }
        }
        
        if !uncachedIds.isEmpty {
            let request = GetEpisodesRequest(ids: uncachedIds)
            let batch = try await httpClient.execute(request)
            for episode in batch.episodes {
                self.cachedEpisodes[episode.id] = episode
            }
            cachedEpisodes.append(contentsOf: batch.episodes)
        }
        
        return cachedEpisodes
    }
}

