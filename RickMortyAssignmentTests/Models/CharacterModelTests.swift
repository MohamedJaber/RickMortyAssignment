//
//  CharacterModelTests.swift
//  RickMortyAssignmentTests
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import Testing
import Foundation
@testable import RickMortyAssignment

struct CharacterModelTests {
    
    // MARK: - Test Data
    private let characterJSON = """
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
        "image": "https://raw.githubusercontent.com/adrianhajdin/rick_and_morty/master/public/characters/avatar/1.jpeg",
        "episode": [
            "https://rickandmortyapi.com/api/episode/1",
            "https://rickandmortyapi.com/api/episode/2"
        ],
        "url": "https://rickandmortyapi.com/api/character/1",
        "created": "2017-11-04T18:48:46.250Z"
    }
    """
    
    // MARK: - Tests: Decoding
    
    @Test
    func characterDecodingFromJSON() throws {
        let data = characterJSON.data(using: .utf8)!
        let character = try JSONDecoder().decode(Character.self, from: data)
        
        #expect(character.id == 1)
        #expect(character.name == "Rick Sanchez")
        #expect(character.status == "Alive")
        #expect(character.species == "Human")
        #expect(character.gender == "Male")
        #expect(character.episode.count == 2)
    }
    
    @Test
    func characterLocationDecoding() throws {
        let data = characterJSON.data(using: .utf8)!
        let character = try JSONDecoder().decode(Character.self, from: data)
        
        #expect(character.origin.name == "Earth (C-137)")
        #expect(character.location.name == "Earth (Replacement Dimension)")
    }
    
    // MARK: - Tests: Encoding
    
    @Test
    func characterEncodingAndDecoding() throws {
        let data = characterJSON.data(using: .utf8)!
        let originalCharacter = try JSONDecoder().decode(Character.self, from: data)
        
        let encodedData = try JSONEncoder().encode(originalCharacter)
        let decodedCharacter = try JSONDecoder().decode(Character.self, from: encodedData)
        
        #expect(originalCharacter == decodedCharacter)
    }
    
    // MARK: - Tests: Equatable
    
    @Test
    func characterEquatable() throws {
        let data = characterJSON.data(using: .utf8)!
        let character1 = try JSONDecoder().decode(Character.self, from: data)
        let character2 = try JSONDecoder().decode(Character.self, from: data)
        
        #expect(character1 == character2)
    }
    
    @Test
    func characterInequatable() throws {
        let data = characterJSON.data(using: .utf8)!
        let character1 = try JSONDecoder().decode(Character.self, from: data)
        
        let modifiedJSON = characterJSON.replacingOccurrences(of: "Rick Sanchez", with: "Morty Smith")
        let data2 = modifiedJSON.data(using: .utf8)!
        let character2 = try JSONDecoder().decode(Character.self, from: data2)
        
        #expect(character1 != character2)
    }
    
    // MARK: - Tests: Identifiable
    
    @Test
    func characterIdentifiable() throws {
        let data = characterJSON.data(using: .utf8)!
        let character = try JSONDecoder().decode(Character.self, from: data)
        
        #expect(character.id == 1)
    }
    
    // MARK: - Tests: Hashable
    
    @Test
    func characterHashable() throws {
        let data = characterJSON.data(using: .utf8)!
        let character1 = try JSONDecoder().decode(Character.self, from: data)
        let character2 = try JSONDecoder().decode(Character.self, from: data)
        
        var set = Set<Character>()
        set.insert(character1)
        set.insert(character2)
        
        #expect(set.count == 1)
    }
    
    // MARK: - Tests: LocationEquatable
    
    @Test
    func locationEquatable() throws {
        let location1 = Character.Location(name: "Earth", url: "url1")
        let location2 = Character.Location(name: "Earth", url: "url1")
        
        #expect(location1 == location2)
    }
}
