//
//  CharactersListViewModelTests.swift
//  RickMortyAssignmentTests
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import Testing
import Foundation
@testable import RickMortyAssignment

// MARK: - Mock Character Repository
final class MockCharacterRepository: CharacterRepositoryProtocol {
    var characters: [RickMortyAssignment.Character] = []
    var shouldThrowError = false
    var throwError: RickMortyAssignment.NetworkError = .unknown
    
    func getCharacters(page: Int) async throws -> RickMortyAssignment.CharacterResponse {
        if shouldThrowError {
            throw throwError
        }
        
        // Simulate pagination - 2 characters per page
        let start = (page - 1) * 2
        let end = min(start + 2, characters.count)
        let paginatedResults = start < characters.count ? Array(characters[start..<end]) : []
        
        return RickMortyAssignment.CharacterResponse(
            info: RickMortyAssignment.PageInfo(
                count: characters.count,
                pages: (characters.count + 1) / 2,
                next: page < ((characters.count + 1) / 2) ? "next_url" : nil,
                prev: page > 1 ? "prev_url" : nil
            ),
            results: paginatedResults
        )
    }
}

// MARK: - Test Characters
private let testCharacter1 = RickMortyAssignment.Character(
    id: 1, name: "Alice", status: "Dead", species: "Human", type: "", gender: "Female",
    origin: RickMortyAssignment.Character.Location(name: "Earth", url: ""),
    location: RickMortyAssignment.Character.Location(name: "Earth", url: ""),
    image: "", episode: [], url: "", created: ""
)

private let testCharacter2 = RickMortyAssignment.Character(
    id: 2, name: "Bob", status: "Alive", species: "Human", type: "", gender: "Male",
    origin: RickMortyAssignment.Character.Location(name: "Earth", url: ""),
    location: RickMortyAssignment.Character.Location(name: "Earth", url: ""),
    image: "", episode: [], url: "", created: ""
)

private let testCharacter3 = RickMortyAssignment.Character(
    id: 3, name: "Zoe", status: "Alive", species: "Human", type: "", gender: "Female",
    origin: RickMortyAssignment.Character.Location(name: "Earth", url: ""),
    location: RickMortyAssignment.Character.Location(name: "Earth", url: ""),
    image: "", episode: [], url: "", created: ""
)

private let testCharacter4 = RickMortyAssignment.Character(
    id: 4, name: "Charlie", status: "Dead", species: "Human", type: "", gender: "Male",
    origin: RickMortyAssignment.Character.Location(name: "Earth", url: ""),
    location: RickMortyAssignment.Character.Location(name: "Earth", url: ""),
    image: "", episode: [], url: "", created: ""
)

// MARK: - CharactersListViewModel Tests
@MainActor
struct CharactersListViewModelTests {
    
    @Test
    func testFetchCharactersSuccess() async {
        // Arrange
        let mockRepository = MockCharacterRepository()
        mockRepository.characters = [testCharacter1, testCharacter2, testCharacter3, testCharacter4]
        let persistence = RickMortyAssignment.PersistenceController()
        
        let viewModel = RickMortyAssignment.CharactersListViewModel(
            characterRepository: mockRepository,
            persistenceController: persistence
        )
        
        #expect(viewModel.characters.isEmpty)
        #expect(viewModel.isLoading == false)
        
        // Act
        await viewModel.fetchCharacters()
        
        // Assert
        #expect(viewModel.characters.count == 2)  // First page has 2 characters
        #expect(viewModel.characters[0].name == "Alice")
        #expect(viewModel.characters[1].name == "Bob")
        #expect(viewModel.isLoading == false)
    }
    
    @Test
    func testFetchCharactersError() async {
        // Arrange
        let mockRepository = MockCharacterRepository()
        mockRepository.shouldThrowError = true
        mockRepository.throwError = .noInternetConnection
        let persistence = RickMortyAssignment.PersistenceController()
        
        let viewModel = RickMortyAssignment.CharactersListViewModel(
            characterRepository: mockRepository,
            persistenceController: persistence
        )
        
        // Act
        await viewModel.fetchCharacters()
        
        // Assert - should not crash and characters remain empty
        #expect(viewModel.characters.isEmpty)
        #expect(viewModel.isLoading == false)
    }
    
    @Test
    func testLoadNextPage() async {
        // Arrange
        let mockRepository = MockCharacterRepository()
        mockRepository.characters = [testCharacter1, testCharacter2, testCharacter3, testCharacter4]
        let persistence = RickMortyAssignment.PersistenceController()
        
        let viewModel = RickMortyAssignment.CharactersListViewModel(
            characterRepository: mockRepository,
            persistenceController: persistence
        )
        
        // First fetch
        await viewModel.fetchCharacters()
        #expect(viewModel.characters.count == 2)
        
        // Act - load next page
        viewModel.loadNextPage(currentCharacter: testCharacter2)
        // Give async task time to complete
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Assert - should have characters from both pages
        #expect(viewModel.characters.count == 4)
        #expect(viewModel.characters[2].name == "Zoe")
        #expect(viewModel.characters[3].name == "Charlie")
    }
    
    @Test
    func testRefresh() async {
        // Arrange
        let mockRepository = MockCharacterRepository()
        mockRepository.characters = [testCharacter1, testCharacter2, testCharacter3, testCharacter4]
        let persistence = RickMortyAssignment.PersistenceController()
        
        let viewModel = RickMortyAssignment.CharactersListViewModel(
            characterRepository: mockRepository,
            persistenceController: persistence
        )
        
        // First load - verify we get first page
        await viewModel.fetchCharacters()
        #expect(viewModel.characters.count == 2)
        
        // Load next page
        viewModel.loadNextPage(currentCharacter: testCharacter2)
        try? await Task.sleep(nanoseconds: 100_000_000)
        #expect(viewModel.characters.count == 4)
        
        // Act - refresh should reset
        await viewModel.refresh()
        
        // Assert - should be back to first page only
        #expect(viewModel.characters.count == 2)
        #expect(viewModel.characters[0].name == "Alice")
        #expect(viewModel.characters[1].name == "Bob")
    }
    
    @Test
    func testCanLoadMore() async {
        // Arrange
        let mockRepository = MockCharacterRepository()
        mockRepository.characters = [testCharacter1, testCharacter2, testCharacter3, testCharacter4]
        let persistence = RickMortyAssignment.PersistenceController()
        
        let viewModel = RickMortyAssignment.CharactersListViewModel(
            characterRepository: mockRepository,
            persistenceController: persistence
        )
        
        // Act & Assert - after first fetch
        await viewModel.fetchCharacters()
        #expect(viewModel.canLoadMore() == true)  // 2 pages total, currentPage=1
        
        // Load next page
        viewModel.loadNextPage(currentCharacter: testCharacter2)
        try? await Task.sleep(nanoseconds: 100_000_000)
        #expect(viewModel.canLoadMore() == false)  // No more pages after page 2
    }
    
    @Test
    func testSearchTextFiltering() {
        // Arrange
        let mockRepository = MockCharacterRepository()
        let persistence = RickMortyAssignment.PersistenceController()
        let viewModel = RickMortyAssignment.CharactersListViewModel(
            characterRepository: mockRepository,
            persistenceController: persistence
        )
        
        viewModel.characters = [testCharacter1, testCharacter2, testCharacter3]
        
        // Act - set debouncedSearchText directly (testing filter logic, not debounce timing)
        viewModel.debouncedSearchText = "Bo"
        
        // Assert
        let filtered = viewModel.filteredCharacters
        #expect(filtered.count == 1)
        #expect(filtered[0].name == "Bob")
    }
    
    @Test
    func testStatusFilterLogic() {
        // Arrange
        let mockRepository = MockCharacterRepository()
        let persistence = RickMortyAssignment.PersistenceController()
        let viewModel = RickMortyAssignment.CharactersListViewModel(
            characterRepository: mockRepository,
            persistenceController: persistence
        )
        
        viewModel.characters = [testCharacter1, testCharacter2, testCharacter3, testCharacter4]
        
        // Test Alive filter
        viewModel.selectedStatus = "Alive"
        var filtered = viewModel.filteredCharacters
        #expect(filtered.count == 2)
        #expect(filtered.allSatisfy { $0.status == "Alive" })
        
        // Test Dead filter
        viewModel.selectedStatus = "Dead"
        filtered = viewModel.filteredCharacters
        #expect(filtered.count == 2)
        #expect(filtered.allSatisfy { $0.status == "Dead" })
    }
    
    @Test
    func testSortOptionLogic() {
        let characters = [testCharacter3, testCharacter1, testCharacter2]
        
        // Test nameAsc
        let sortedByNameAsc = RickMortyAssignment.SortOption.nameAsc.sort(characters)
        #expect(sortedByNameAsc[0].name == "Alice")
        #expect(sortedByNameAsc[1].name == "Bob")
        #expect(sortedByNameAsc[2].name == "Zoe")
        
        // Test idDesc
        let sortedByIdDesc = RickMortyAssignment.SortOption.idDesc.sort(characters)
        #expect(sortedByIdDesc[0].id == 3)
        #expect(sortedByIdDesc[1].id == 2)
        #expect(sortedByIdDesc[2].id == 1)
    }
}

