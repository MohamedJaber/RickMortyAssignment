//
//  CharacterDetailViewModel.swift
//  RickMortyAssignment
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import Foundation
import SwiftUI

@Observable
@MainActor
final class CharacterDetailViewModel {
    var character: Character
    var episodes: [Episode] = []
    var episodesLoadingState: LoadingState = .idle
    
    private let episodeRepository: EpisodeRepositoryProtocol
    private let persistenceController: PersistenceController
    
    init(
        character: Character,
        episodeRepository: EpisodeRepositoryProtocol,
        persistenceController: PersistenceController
    ) {
        self.character = character
        self.episodeRepository = episodeRepository
        self.persistenceController = persistenceController
    }
    
    func loadEpisodes() async {
        guard episodesLoadingState == .idle, !character.episode.isEmpty else { return }
        
        episodesLoadingState = .loading
        
        // Extract episode IDs from URLs
        let episodeIds = character.episode.compactMap { url -> Int? in
            let components = url.split(separator: "/")
            return Int(components.last ?? "")
        }
        
        AppLogger.ui.debug("Loading \(episodeIds.count) episodes for character: \(character.name)")

        do {
            let loadedEpisodes = try await episodeRepository.getEpisodes(ids: episodeIds)
            self.episodes = loadedEpisodes.sorted { $0.episode < $1.episode }
            self.episodesLoadingState = .success
            AppLogger.ui.debug("Successfully loaded \(loadedEpisodes.count) episodes")
        } catch let error as NetworkError {
            AppLogger.ui.error("Error loading episodes: \(error.errorDescription ?? "Unknown")")
            self.episodesLoadingState = .error(error)
        } catch {
            AppLogger.ui.error("Unknown error loading episodes")
            self.episodesLoadingState = .error(.unknown)
        }
    }
    
    var statusColor: Color {
        StatusService.color(for: character.status)
    }
    
    var statusIcon: String {
        StatusService.icon(for: character.status)
    }
    
    func saveToFavorites() async {
        await persistenceController.saveCharacter(character)
    }
    
    func removeFromFavorites() async {
        await persistenceController.removeFromFavorites(id: character.id)
    }
    
    func isFavorited() async -> Bool {
        return await persistenceController.isFavorited(id: character.id)
    }
}

