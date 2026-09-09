//
//  CharactersListViewModel.swift
//  RickMortyAssignment
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import Foundation
import SwiftUI

enum SortOption: String, CaseIterable {
    case nameAsc = "Name A-Z"
    case nameDesc = "Name Z-A"
    case idAsc = "ID (Oldest)"
    case idDesc = "ID (Newest)"
    
    func sort(_ characters: [Character]) -> [Character] {
        switch self {
        case .nameAsc:
            return characters.sorted { $0.name < $1.name }
        case .nameDesc:
            return characters.sorted { $0.name > $1.name }
        case .idAsc:
            return characters.sorted { $0.id < $1.id }
        case .idDesc:
            return characters.sorted { $0.id > $1.id }
        }
    }
}

// Loading state for CharacterDetailViewModel only
enum LoadingState: Equatable {
    case idle
    case loading
    case success
    case error(NetworkError)
}

@Observable
@MainActor
final class CharactersListViewModel {
    var characters: [Character] = []
    var isLoading = false
    var errorMessage: String?
    var isFetchingNextPage = false
    
    // View state (UI filters/sorting)
    var searchText: String = ""
    var debouncedSearchText: String = ""
    var selectedStatus: String?
    var selectedSort: SortOption = .nameAsc
    
    private var currentPage = 1
    private var totalPages = 1
    private var lastFetchedPage = 0
    private var searchTask: Task<Void, Never>?
    
    private let characterRepository: CharacterRepositoryProtocol
    private let persistenceController: PersistenceController
    
    init(
        characterRepository: CharacterRepositoryProtocol,
        persistenceController: PersistenceController
    ) {
        self.characterRepository = characterRepository
        self.persistenceController = persistenceController
    }
    
    /// Filters and sorts characters based on UI state
    var filteredCharacters: [Character] {
        let filtered = characters.filter { character in
            // Search filter
            guard debouncedSearchText.isEmpty || character.name.localizedCaseInsensitiveContains(debouncedSearchText) else {
                return false
            }
            
            // Status filter
            guard let selectedStatus = selectedStatus?.trimmingCharacters(in: .whitespaces), !selectedStatus.isEmpty else {
                return true  // No status filter applied
            }
            let characterStatus = character.status.trimmingCharacters(in: .whitespaces)
            return selectedStatus.lowercased() == characterStatus.lowercased()
        }
        
        return selectedSort.sort(filtered)
    }
    
    /// Update search with debounce
    func updateSearchText(_ text: String) {
        searchTask?.cancel()
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000)  // 500ms
            debouncedSearchText = text
        }
    }
    
    /// Fetch characters - handles both initial and pagination
    func fetchCharacters() async {
        guard !isLoading, !isFetchingNextPage, currentPage != lastFetchedPage else { return }
        
        isLoading = true
        isFetchingNextPage = true
        
        defer {
            isLoading = false
            isFetchingNextPage = false
        }
        
        do {
            let response = try await characterRepository.getCharacters(page: currentPage)
            characters.append(contentsOf: response.results)
            totalPages = response.info.pages
            lastFetchedPage = currentPage
            errorMessage = nil
        } catch let error as NetworkError {
            AppLogger.ui.error("Error loading characters: \(error.errorDescription ?? "Unknown error")")
        } catch {
            AppLogger.ui.error("Unknown error loading characters: \(error.localizedDescription)")
        }
    }
    
    /// Trigger next page load when user scrolls to last character
    func loadNextPage(currentCharacter: Character) {
        Task {
            currentPage += 1
            await fetchCharacters()
        }
    }
    
    /// Reset pagination state
    private func resetPaginationState() {
        currentPage = 1
        lastFetchedPage = 0
        characters.removeAll()
    }
    
    /// Reset and reload first page
    func refresh() async {
        resetPaginationState()
        await fetchCharacters()
    }
    
    /// Retry on error
    func retry() async {
        resetPaginationState()
        await fetchCharacters()
    }
    
    /// Check if more pages available
    /// Returns true if there are more pages to load, which is important for filtered results
    /// since a page may contain few or no characters matching the current filter
    func canLoadMore() -> Bool {
        currentPage < totalPages
    }
}


