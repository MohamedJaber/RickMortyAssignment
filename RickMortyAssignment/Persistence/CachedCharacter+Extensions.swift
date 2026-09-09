//
//  CachedCharacter+Extensions.swift
//  RickMortyAssignment
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import Foundation

extension CachedCharacter {
    static func from(_ character: Character) -> CachedCharacter {
        CachedCharacter(
            id: character.id,
            name: character.name,
            status: character.status,
            species: character.species,
            imageURL: character.image
        )
    }

    var statusColor: String {
        switch status {
        case "Alive":
            return "green"
        case "Dead":
            return "red"
        default:
            return "gray"
        }
    }

    var statusIcon: String {
        switch status {
        case "Alive":
            return "✓"
        case "Dead":
            return "✕"
        default:
            return "?"
        }
    }
}

