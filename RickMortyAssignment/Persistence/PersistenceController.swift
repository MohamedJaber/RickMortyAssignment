//
//  PersistenceController.swift
//  RickMortyAssignment
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import Foundation
import SwiftData

@Model
final class CachedCharacter {
    @Attribute(.unique) var id: Int
    var name: String
    var status: String
    var species: String
    var imageURL: String
    var viewedDate: Date
    var isFavorite: Bool

    init(id: Int, name: String, status: String, species: String, imageURL: String, isFavorite: Bool = false) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.imageURL = imageURL
        self.viewedDate = Date()
        self.isFavorite = isFavorite
    }
}

actor PersistenceController {
    static let shared = PersistenceController()
    
    private let modelContainer: ModelContainer
    
    init() {
        let schema = Schema([CachedCharacter.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            self.modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }
    
    func saveCharacter(_ character: Character) async {
        let cached = CachedCharacter(
            id: character.id,
            name: character.name,
            status: character.status,
            species: character.species,
            imageURL: character.image,
            isFavorite: true
        )
        
        let context = ModelContext(modelContainer)
        
        do {
            // Check if character already exists
            let descriptor = FetchDescriptor<CachedCharacter>(
                predicate: #Predicate { $0.id == character.id }
            )
            if let existing = try context.fetch(descriptor).first {
                // Update existing character's favorite status
                existing.isFavorite = true
            } else {
                // Insert new character
                context.insert(cached)
            }
            try context.save()
            AppLogger.persistence.debug("Character saved as favorite: \(character.name)")
        } catch {
            AppLogger.persistence.error("Failed to save character: \(error.localizedDescription)")
        }
    }
    
    func isFavorited(id: Int) -> Bool {
        let context = ModelContext(modelContainer)
        
        do {
            let descriptor = FetchDescriptor<CachedCharacter>(
                predicate: #Predicate { $0.id == id && $0.isFavorite == true }
            )
            let result = try context.fetch(descriptor).first
            return result != nil
        } catch {
            AppLogger.persistence.error("Failed to check favorite status: \(error.localizedDescription)")
            return false
        }
    }
    
    func removeFromFavorites(id: Int) async {
        let context = ModelContext(modelContainer)
        
        do {
            let descriptor = FetchDescriptor<CachedCharacter>(
                predicate: #Predicate { $0.id == id }
            )
            if let existing = try context.fetch(descriptor).first {
                existing.isFavorite = false
                try context.save()
                AppLogger.persistence.debug("Character removed from favorites: id=\(id)")
            }
        } catch {
            AppLogger.persistence.error("Failed to remove character from favorites: \(error.localizedDescription)")
        }
    }
    
    func getAllCachedCharacters() -> [CachedCharacter] {
        let context = ModelContext(modelContainer)
        
        do {
            let descriptor = FetchDescriptor<CachedCharacter>(
                sortBy: [SortDescriptor(\.viewedDate, order: .reverse)]
            )
            let results = try context.fetch(descriptor)
            AppLogger.persistence.debug("Fetched \(results.count) cached characters")
            return results
        } catch {
            AppLogger.persistence.error("Failed to fetch characters: \(error.localizedDescription)")
            return []
        }
    }
    
    func clearCache() async {
        let context = ModelContext(modelContainer)
        
        do {
            try context.delete(model: CachedCharacter.self)
            AppLogger.persistence.debug("Cache cleared successfully")
        } catch {
            AppLogger.persistence.error("Failed to clear cache: \(error.localizedDescription)")
        }
    }
}

