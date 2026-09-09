//
//  Character.swift
//  RickMortyAssignment
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import Foundation

struct Character: Codable, Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Location
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    struct Location: Codable, Equatable, Hashable, Sendable {
        let name: String
        let url: String
    }
}

