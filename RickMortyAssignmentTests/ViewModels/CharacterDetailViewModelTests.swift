//
//  CharacterDetailViewModelTests.swift
//  RickMortyAssignmentTests
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import Testing
import Foundation
@testable import RickMortyAssignment

// MARK: - Mock Episode Repository
final class MockEpisodeRepository: EpisodeRepositoryProtocol {
    var shouldThrowError = false
    var throwError: RickMortyAssignment.NetworkError = .unknown
    var mockEpisodes: [RickMortyAssignment.Episode] = []
    
    func getEpisodes(ids: [Int]) async throws -> [RickMortyAssignment.Episode] {
        if shouldThrowError {
            throw throwError
        }
        return mockEpisodes
    }
}

// MARK: - CharacterDetailViewModel Tests
@MainActor
struct CharacterDetailViewModelTests {
    private static let testCharacter = RickMortyAssignment.Character(
        id: 1,
        name: "Rick Sanchez",
        status: "Alive",
        species: "Human",
        type: "Scientist",
        gender: "Male",
        origin: RickMortyAssignment.Character.Location(name: "Earth (C-137)", url: ""),
        location: RickMortyAssignment.Character.Location(name: "Earth (Replacement Dimension)", url: ""),
        image: "https://example.com/rick.jpg",
        episode: ["https://rickandmortyapi.com/api/episode/1", "https://rickandmortyapi.com/api/episode/2"],
        url: "",
        created: ""
    )
    
    private static let testEpisodes = [
        RickMortyAssignment.Episode(id: 1, name: "Pilot", airDate: "2013-12-02", episode: "S01E01", characters: [], url: "", created: ""),
        RickMortyAssignment.Episode(id: 2, name: "Lawnmower Dog", airDate: "2013-12-09", episode: "S01E02", characters: [], url: "", created: "")
    ]
    
    @Test
    func testLoadEpisodesSuccess() async {
        // Arrange
        let mockEpisodeRepository = MockEpisodeRepository()
        mockEpisodeRepository.mockEpisodes = Self.testEpisodes
        let persistence = RickMortyAssignment.PersistenceController()
        
        let viewModel = RickMortyAssignment.CharacterDetailViewModel(
            character: Self.testCharacter,
            episodeRepository: mockEpisodeRepository,
            persistenceController: persistence
        )
        
        // Initially should be idle
        #expect(viewModel.episodesLoadingState == .idle)
        
        // Act - load episodes
        await viewModel.loadEpisodes()
        
        // Assert - should be success and episodes loaded
        #expect(viewModel.episodesLoadingState == .success)
        #expect(viewModel.episodes.count == 2)
        #expect(viewModel.episodes[0].name == "Pilot")
        #expect(viewModel.episodes[1].name == "Lawnmower Dog")
    }
    
    @Test
    func testLoadEpisodesError() async {
        // Arrange
        let mockEpisodeRepository = MockEpisodeRepository()
        mockEpisodeRepository.shouldThrowError = true
        mockEpisodeRepository.throwError = .noInternetConnection
        let persistence = RickMortyAssignment.PersistenceController()
        
        let viewModel = RickMortyAssignment.CharacterDetailViewModel(
            character: Self.testCharacter,
            episodeRepository: mockEpisodeRepository,
            persistenceController: persistence
        )
        
        // Act
        await viewModel.loadEpisodes()
        
        // Assert - should be error state
        #expect(viewModel.episodesLoadingState == .error(.noInternetConnection))
        #expect(viewModel.episodes.isEmpty)
    }
    
    @Test
    func testLoadEpisodesGuardClause() async {
        // Arrange - character with no episodes
        let characterNoEpisodes = RickMortyAssignment.Character(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            type: "Scientist",
            gender: "Male",
            origin: RickMortyAssignment.Character.Location(name: "Earth (C-137)", url: ""),
            location: RickMortyAssignment.Character.Location(name: "Earth (Replacement Dimension)", url: ""),
            image: "https://example.com/rick.jpg",
            episode: [],
            url: "",
            created: ""
        )
        let mockEpisodeRepository = MockEpisodeRepository()
        let persistence = RickMortyAssignment.PersistenceController()
        
        let viewModel = RickMortyAssignment.CharacterDetailViewModel(
            character: characterNoEpisodes,
            episodeRepository: mockEpisodeRepository,
            persistenceController: persistence
        )
        
        // Act - try to load episodes for character with no episodes
        await viewModel.loadEpisodes()
        
        // Assert - should remain idle (guard clause prevents loading)
        #expect(viewModel.episodesLoadingState == .idle)
        #expect(viewModel.episodes.isEmpty)
    }
    
    @Test
    func testSaveToFavorites() async {
        // Arrange
        let persistence = RickMortyAssignment.PersistenceController()
        let mockEpisodeRepository = MockEpisodeRepository()
        
        let viewModel = RickMortyAssignment.CharacterDetailViewModel(
            character: Self.testCharacter,
            episodeRepository: mockEpisodeRepository,
            persistenceController: persistence
        )
        
        // Act - save to favorites
        await viewModel.saveToFavorites()
        
        // Assert - character should be saved and isFavorited returns true
        let isFavorited = await viewModel.isFavorited()
        #expect(isFavorited == true)
    }
    
    @Test
    func testRemoveFromFavorites() async {
        // Arrange
        let persistence = RickMortyAssignment.PersistenceController()
        let mockEpisodeRepository = MockEpisodeRepository()
        
        let viewModel = RickMortyAssignment.CharacterDetailViewModel(
            character: Self.testCharacter,
            episodeRepository: mockEpisodeRepository,
            persistenceController: persistence
        )
        
        // Act - save to favorites first
        await viewModel.saveToFavorites()
        
        // Assert - character should be favorited
        var isFavorited = await viewModel.isFavorited()
        #expect(isFavorited == true)
        
        // Act - remove from favorites
        await viewModel.removeFromFavorites()
        
        // Assert - character should no longer be favorited
        isFavorited = await viewModel.isFavorited()
        #expect(isFavorited == false)
    }
    
    @Test
    func testStatusColorDifferencesByStatus() {
        let aliveColor = RickMortyAssignment.StatusService.color(for: "Alive")
        let deadColor = RickMortyAssignment.StatusService.color(for: "Dead")
        let unknownColor = RickMortyAssignment.StatusService.color(for: "unknown")
        
        #expect(aliveColor != deadColor)
        #expect(deadColor != unknownColor)
        #expect(aliveColor != unknownColor)
    }
    
    @Test
    func testStatusIconIsNotEmpty() {
        let aliveIcon = RickMortyAssignment.StatusService.icon(for: "Alive")
        let deadIcon = RickMortyAssignment.StatusService.icon(for: "Dead")
        let unknownIcon = RickMortyAssignment.StatusService.icon(for: "unknown")
        
        #expect(!aliveIcon.isEmpty)
        #expect(!deadIcon.isEmpty)
        #expect(!unknownIcon.isEmpty)
        #expect(aliveIcon != deadIcon)
        #expect(deadIcon != unknownIcon)
    }
}


