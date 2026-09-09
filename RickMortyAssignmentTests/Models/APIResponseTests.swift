//
//  APIResponseTests.swift
//  RickMortyAssignmentTests
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import Testing
import Foundation

@testable import RickMortyAssignment

struct APIResponseTests {
    
    // MARK: - Tests: PageInfo
    
    @Test
    func pageInfoDecoding() {
        let pageInfoJSON = """
        {
            "count": 826,
            "pages": 42,
            "next": "https://rickandmortyapi.com/api/character/?page=2",
            "prev": null
        }
        """
        
        let data = pageInfoJSON.data(using: .utf8)!
        let pageInfo = try! JSONDecoder().decode(PageInfo.self, from: data)
        
        #expect(pageInfo.count == 826)
        #expect(pageInfo.pages == 42)
        #expect(pageInfo.next == "https://rickandmortyapi.com/api/character/?page=2")
        #expect(pageInfo.prev == nil)
    }
    
    @Test
    func pageInfoEquatable() {
        let pageInfo1 = PageInfo(count: 10, pages: 1, next: nil, prev: nil)
        let pageInfo2 = PageInfo(count: 10, pages: 1, next: nil, prev: nil)
        #expect(pageInfo1 == pageInfo2)
    }
    
    @Test
    func pageInfoInequatable() {
        let pageInfo1 = PageInfo(count: 10, pages: 1, next: nil, prev: nil)
        let pageInfo2 = PageInfo(count: 20, pages: 2, next: nil, prev: nil)
        #expect(pageInfo1 != pageInfo2)
    }
    
    @Test
    func pageInfoWithPagination() {
        let pageInfo = PageInfo(
            count: 826,
            pages: 42,
            next: "https://rickandmortyapi.com/api/character/?page=2",
            prev: "https://rickandmortyapi.com/api/character/?page=1"
        )
        #expect(pageInfo.next != nil)
        #expect(pageInfo.prev != nil)
    }
    
    // MARK: - Tests: CharacterResponse
    
    @Test
    func characterResponseDecoding() throws {
        let characterJSON = """
        {
            "id": 1,
            "name": "Rick Sanchez",
            "status": "Alive",
            "species": "Human",
            "type": "Human with Cyborg enhancements",
            "gender": "Male",
            "origin": {
                "name": "Earth (C-137)",
                "url": "https://rickandmortyapi.com/api/location/1"
            },
            "location": {
                "name": "Earth (Replacement Dimension)",
                "url": "https://rickandmortyapi.com/api/location/20"
            },
            "image": "https://example.com/1.jpeg",
            "episode": ["https://rickandmortyapi.com/api/episode/1"],
            "url": "https://rickandmortyapi.com/api/character/1",
            "created": "2017-11-04T18:48:46.250Z"
        }
        """
        
        let responseJSON = """
        {
            "info": {
                "count": 826,
                "pages": 42,
                "next": "https://rickandmortyapi.com/api/character/?page=2",
                "prev": null
            },
            "results": [\(characterJSON)]
        }
        """
        
        let data = responseJSON.data(using: .utf8)!
        let response = try JSONDecoder().decode(CharacterResponse.self, from: data)
        
        #expect(response.info.count == 826)
        #expect(response.results.count == 1)
        #expect(response.results.first?.name == "Rick Sanchez")
    }
    
    @Test
    func characterResponseEmptyResults() throws {
        let responseJSON = """
        {
            "info": {
                "count": 0,
                "pages": 0,
                "next": null,
                "prev": null
            },
            "results": []
        }
        """
        
        let data = responseJSON.data(using: .utf8)!
        let response = try JSONDecoder().decode(CharacterResponse.self, from: data)
        
        #expect(response.results.count == 0)
        #expect(response.info.count == 0)
    }
    
    // MARK: - Tests: EpisodeResponse
    
    @Test
    func episodeResponseDecoding() throws {
        let episodeJSON = """
        {
            "id": 1,
            "name": "Pilot",
            "air_date": "December 2, 2013",
            "episode": "S01E01",
            "characters": ["https://rickandmortyapi.com/api/character/1"],
            "url": "https://rickandmortyapi.com/api/episode/1",
            "created": "2017-11-10T12:56:33.798Z"
        }
        """
        
        let responseJSON = """
        {
            "info": {
                "count": 51,
                "pages": 3,
                "next": "https://rickandmortyapi.com/api/episode/?page=2",
                "prev": null
            },
            "results": [\(episodeJSON)]
        }
        """
        
        let data = responseJSON.data(using: .utf8)!
        let response = try JSONDecoder().decode(EpisodeResponse.self, from: data)
        
        #expect(response.results.count == 1)
        #expect(response.results.first?.name == "Pilot")
    }
    
    @Test
    func episodeResponseMultipleEpisodes() throws {
        let episodeJSON = """
        {
            "id": 1,
            "name": "Pilot",
            "air_date": "December 2, 2013",
            "episode": "S01E01",
            "characters": [],
            "url": "https://rickandmortyapi.com/api/episode/1",
            "created": "2017-11-10T12:56:33.798Z"
        }
        """
        
        let responseJSON = """
        {
            "info": {
                "count": 51,
                "pages": 3,
                "next": null,
                "prev": null
            },
            "results": [\(episodeJSON), \(episodeJSON)]
        }
        """
        
        let data = responseJSON.data(using: .utf8)!
        let response = try JSONDecoder().decode(EpisodeResponse.self, from: data)
        
        #expect(response.results.count == 2)
    }
    
    @Test
    func sendableConformance() {
        let pageInfo = PageInfo(count: 1, pages: 1, next: nil, prev: nil)
        // If this compiles, Sendable conformance is working
        #expect(pageInfo.count == 1)
    }
}
