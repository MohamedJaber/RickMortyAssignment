//
//  CharacterDetailView.swift
//  RickMortyAssignment
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import SwiftUI

struct CharacterDetailView: View {
    let character: Character
    let appFactory: AppFactory
    var viewModel: CharacterDetailViewModel
    @State private var isFavorite = false
    var preloadedImage: Image? = nil  // Accept pre-loaded image
    
    init(character: Character, appFactory: AppFactory, preloadedImage: Image? = nil) {
        self.character = character
        self.appFactory = appFactory
        self.viewModel = appFactory.createCharacterDetailViewModel(character: character)
        self.preloadedImage = preloadedImage
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                characterImageSection
                characterInfoSection
                episodesSection
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadEpisodes()
            isFavorite = await viewModel.isFavorited()
        }
    }
    
    // MARK: - View Sections
    
    private var characterImageSection: some View {
        if preloadedImage != nil {
            return AnyView(AsyncImageView(preloadedImage: preloadedImage))
        } else {
            return AnyView(AsyncImageView(url: character.image))
        }
    }
    
    private var characterInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            nameAndFavoriteButton
            
            InfoRow(label: "Status", value: character.status, color: viewModel.statusColor)
            InfoRow(label: "Species", value: character.species)
            InfoRow(label: "Gender", value: character.gender)
            InfoRow(label: "Origin", value: character.origin.name)
            InfoRow(label: "Location", value: character.location.name)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var nameAndFavoriteButton: some View {
        HStack {
            Text(character.name)
                .font(.system(size: 28, weight: .bold))
                .accessibilityIdentifier("characterNameLabel")
            Spacer()
            Button(action: {
                Task {
                    if isFavorite {
                        await viewModel.removeFromFavorites()
                        isFavorite = false
                        AppLogger.ui.debug("Character removed from favorites: \(character.name)")
                    } else {
                        await viewModel.saveToFavorites()
                        isFavorite = true
                        AppLogger.ui.debug("Character added to favorites: \(character.name)")
                    }
                }
            }) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(.red)
            }
            .accessibilityIdentifier("favoriteButton")
            .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
        }
    }
    
    private var episodesSection: some View {
        Group {
            if !character.episode.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    episodeHeader
                    episodeContent
                }
            }
        }
    }
    
    private var episodeHeader: some View {
        Text("Episodes (\(character.episode.count))")
            .font(.headline)
            .padding(.horizontal)
    }
    
    private var episodeContent: some View {
        Group {
            switch viewModel.episodesLoadingState {
            case .idle:
                Text("Loading episodes...")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
            case .loading:
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .padding()
                
            case .success:
                if viewModel.episodes.isEmpty {
                    Text("No episodes found")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                } else {
                    episodesList
                }
                
            case .error(let error):
                ErrorView(error: error, retryAction: {
                    await viewModel.loadEpisodes()
                })
            }
        }
    }
    
    private var episodesList: some View {
        VStack(spacing: 8) {
            ForEach(viewModel.episodes) { episode in
                EpisodeRow(episode: episode)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    let color: Color?
    
    init(label: String, value: String, color: Color? = nil) {
        self.label = label
        self.value = value
        self.color = color
    }
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
            Spacer()
            HStack(spacing: 6) {
                if let color = color {
                    Circle()
                        .fill(color)
                        .frame(width: 8, height: 8)
                }
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
        }
    }
}

struct EpisodeRow: View {
    let episode: Episode

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(episode.episode)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                Spacer()
                Text(episode.airDate)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        
            Text(episode.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        CharacterDetailView(
            character: Character(
                id: 1,
                name: "Rick Sanchez",
                status: "Alive",
                species: "Human",
                type: "",
                gender: "Male",
                origin: .init(name: "Earth (C-137)", url: ""),
                location: .init(name: "Earth (Replacement Dimension)", url: ""),
                image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                episode: [],
                url: "",
                created: ""
            ),
            appFactory: AppFactory()
        )
    }
}

