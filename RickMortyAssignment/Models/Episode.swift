//
//  Episode.swift
//  RickMortyAssignment
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import Foundation

struct Episode: Codable, Identifiable, Hashable, Sendable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, characters, url, created, episode
        case airDate = "air_date"
    }
}

