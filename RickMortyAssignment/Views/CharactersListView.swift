//
//  CharactersListView.swift
//  RickMortyAssignment
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import SwiftUI

struct CharactersListView: View {
    @Bindable var viewModel: CharactersListViewModel
    private let appFactory = AppFactory()
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                mainContent
                errorBanner
            }
            .navigationTitle("Characters")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: Character.self) { character in
                CharacterDetailView(
                    character: character,
                    appFactory: appFactory,
                    preloadedImage: nil
                )
            }
            .task {
                await viewModel.fetchCharacters()
            }
        }
    }
    
    // MARK: - View Sections
    
    private var mainContent: some View {
        Group {
            if viewModel.isLoading && viewModel.characters.isEmpty {
                LoadingView()
            } else {
                contentWithSearchAndList
            }
        }
    }
    
    private var contentWithSearchAndList: some View {
        VStack {
            searchAndFilterSection
            characterListSection
        }
    }
    
    private var searchAndFilterSection: some View {
        SearchAndFilterView(
            searchText: $viewModel.searchText,
            selectedStatus: $viewModel.selectedStatus,
            selectedSort: $viewModel.selectedSort,
            onSearchChange: viewModel.updateSearchText
        )
    }
    
    private var characterListSection: some View {
        CharacterListContent(
            characters: viewModel.filteredCharacters,
            allCharacters: viewModel.characters,
            isLoadingMore: viewModel.isFetchingNextPage,
            canLoadMore: viewModel.canLoadMore(),
            appFactory: appFactory,
            onLoadMore: viewModel.loadNextPage,
            onRefresh: viewModel.refresh,
            navigationPath: $navigationPath
        )
    }
    
    @ViewBuilder
    private var errorBanner: some View {
        if let error = viewModel.errorMessage {
            VStack {
                HStack {
                    Image(systemName: "exclamationmark.circle")
                        .foregroundColor(.red)
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                    Spacer()
                    retryButton
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
                .padding()
            }
        }
    }
    
    private var retryButton: some View {
        Button("Retry") {
            Task {
                await viewModel.retry()
            }
        }
        .font(.caption)
        .foregroundColor(.blue)
    }
}

#Preview {
    NavigationStack {
        CharactersListView(viewModel: CharactersListViewModel(
            characterRepository: CharacterRepository(httpClient: HTTPClient(configuration: NetworkConfiguration(baseURL: URL(string: "https://rickandmortyapi.com/api")!))),
            persistenceController: PersistenceController.shared
        ))
    }
}

