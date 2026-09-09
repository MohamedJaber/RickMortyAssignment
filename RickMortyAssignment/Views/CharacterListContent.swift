//
//  CharacterListContent.swift
//  RickMortyAssignment
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import SwiftUI

struct CharacterListContent: View {
    var characters: [Character]
    var allCharacters: [Character]
    var isLoadingMore: Bool
    var canLoadMore: Bool
    var appFactory: AppFactory
    var onLoadMore: (Character) -> Void
    var onRefresh: () async -> Void
    
    var body: some View {
        Group {
            if characters.isEmpty {
                emptyState
            } else {
                characterList
            }
        }
    }

    // MARK: - View Sections
    
    private var emptyState: some View {
        CharacterListEmptyState()
    }
    
    private var characterList: some View {
        List {
            ForEach(characters) { character in
                CharacterRowView(character: character)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
            }
            
            // Add loading trigger at the end if there are more pages
            if shouldShowLoadMoreTrigger {
                loadingIndicator
                    .frame(height: 40)
                    .onAppear {
                        // Trigger load next page
                        if let lastCharacter = characters.last {
                            onLoadMore(lastCharacter)
                        }
                    }
            }
        }
        .listStyle(.plain)
        .refreshable {
            await onRefresh()
        }
    }
    
    private var loadingIndicator: some View {
        HStack {
            Spacer()
            if isLoadingMore {
                ProgressView()
            }
            Spacer()
        }
    }
    
    private var shouldShowLoadMoreTrigger: Bool {
        // Show load more trigger if we have characters and there are more pages available
        !characters.isEmpty && canLoadMore
    }
}

#Preview {
    CharacterListContent(
        characters: [],
        allCharacters: [],
        isLoadingMore: false,
        canLoadMore: true,
        appFactory: AppFactory(),
        onLoadMore: { _ in },
        onRefresh: { }
    )
}

