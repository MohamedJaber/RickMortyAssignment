//
//  APIResponse.swift
//  RickMortyAssignment
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import Foundation

struct CharacterResponse: Codable, Sendable {
    let info: PageInfo
    let results: [Character]
}

struct EpisodeResponse: Codable, Sendable {
    let info: PageInfo
    let results: [Episode]
}

struct PageInfo: Codable, Equatable, Sendable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

