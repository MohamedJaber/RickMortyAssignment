//
//  EpisodeModelTests.swift
//  RickMortyAssignmentTests
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import Testing
import Foundation
@testable import RickMortyAssignment

struct EpisodeModelTests {
    
    // MARK: - Test Data
    
    private let episodeJSON = """
    {
        "id": 1,
        "name": "Pilot",
        "air_date": "December 2, 2013",
        "episode": "S01E01",
        "characters": [
            "https://rickandmortyapi.com/api/character/1",
            "https://rickandmortyapi.com/api/character/2"
        ],
        "url": "https://rickandmortyapi.com/api/episode/1",
        "created": "2017-11-10T12:56:33.798Z"
    }
    """
    
    // MARK: - Tests: Decoding
    
    @Test
    func episodeDecodingFromJSON() throws {
        let data = episodeJSON.data(using: .utf8)!
        let episode = try JSONDecoder().decode(Episode.self, from: data)
        
        #expect(episode.id == 1)
        #expect(episode.name == "Pilot")
        #expect(episode.airDate == "December 2, 2013")
        #expect(episode.episode == "S01E01")
        #expect(episode.characters.count == 2)
    }
    
    @Test
    func episodeDecodingAirDateMapping() throws {
        let data = episodeJSON.data(using: .utf8)!
        let episode = try JSONDecoder().decode(Episode.self, from: data)
        
        #expect(episode.airDate == "December 2, 2013")
    }
    
    // MARK: - Tests: Encoding
    
    @Test
    func episodeEncodingAndDecoding() throws {
        let data = episodeJSON.data(using: .utf8)!
        let originalEpisode = try JSONDecoder().decode(Episode.self, from: data)
        
        let encodedData = try JSONEncoder().encode(originalEpisode)
        let decodedEpisode = try JSONDecoder().decode(Episode.self, from: encodedData)
        
        #expect(originalEpisode.id == decodedEpisode.id)
        #expect(originalEpisode.name == decodedEpisode.name)
        #expect(originalEpisode.episode == decodedEpisode.episode)
    }
    
    // MARK: - Tests: Identifiable
    
    @Test
    func episodeIdentifiable() throws {
        let data = episodeJSON.data(using: .utf8)!
        let episode = try JSONDecoder().decode(Episode.self, from: data)
        
        #expect(episode.id == 1)
    }
    
    // MARK: - Tests: Hashable
    
    @Test
    func episodeHashable() throws {
        let data = episodeJSON.data(using: .utf8)!
        let episode1 = try JSONDecoder().decode(Episode.self, from: data)
        let episode2 = try JSONDecoder().decode(Episode.self, from: data)
        
        var set = Set<Episode>()
        set.insert(episode1)
        set.insert(episode2)
        
        #expect(set.count == 1)
    }
    
    // MARK: - Tests: Properties
    
    @Test
    func episodeProperties() throws {
        let data = episodeJSON.data(using: .utf8)!
        let episode = try JSONDecoder().decode(Episode.self, from: data)
        
        #expect(episode.url == "https://rickandmortyapi.com/api/episode/1")
        #expect(episode.created == "2017-11-10T12:56:33.798Z")
        #expect(episode.characters.contains("https://rickandmortyapi.com/api/character/1"))
    }
}
