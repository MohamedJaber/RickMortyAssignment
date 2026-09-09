//
//  CharacterRowView.swift
//  RickMortyAssignment
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import SwiftUI

struct CharacterRowView: View {
    let character: Character
    @State private var image: Image?
    @State private var isLoading = false
    
    var body: some View {
        HStack(spacing: 12) {
            characterImage
            characterInfo
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(character.name), \(character.status), \(character.species)")
        .accessibilityHint("Double tap to view details")
        .task {
            await loadImage()
        }
    }
    
    // MARK: - View Sections
    
    private var characterImage: some View {
        ZStack {
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                    .clipped()
            } else if isLoading {
                ProgressView()
                    .frame(width: 80, height: 80)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            } else {
                placeholderImage
            }
        }
    }
    
    private var placeholderImage: some View {
        Image(systemName: "person.crop.square.fill")
            .font(.system(size: 40))
            .foregroundColor(.gray)
            .frame(width: 80, height: 80)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
    }
    
    private var characterInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            characterName
            statusAndSpecies
            originName
        }
    }
    
    private var characterName: some View {
        Text(character.name)
            .font(.subheadline)
            .fontWeight(.semibold)
            .lineLimit(1)
            .truncationMode(.tail)
    }
    
    private var statusAndSpecies: some View {
        HStack(spacing: 8) {
            StatusBadge(status: character.status)
            Text(character.species)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
    
    private var originName: some View {
        Text(character.origin.name)
            .font(.caption)
            .foregroundColor(.gray)
            .lineLimit(1)
    }
    
    private func loadImage() async {
        // Try to load from cache first (non-blocking)
        if let cachedImage = await ImageService.shared.getCachedImage(for: character.image) {
            image = cachedImage
            return
        }

        // If not in cache, show loading indicator and fetch
        isLoading = true
        defer { isLoading = false }
        image = await ImageService.shared.loadImage(from: character.image)
    }
}

struct StatusBadge: View {
    let status: String
    
    var body: some View {
        let statusEnum = StatusService.status(for: status)
        
        HStack(spacing: 4) {
            Circle()
                .fill(statusEnum.color)
                .frame(width: 8, height: 8)
            
            Text(status)
                .font(.caption2)
                .foregroundColor(statusEnum.color)
                .lineLimit(1)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .background(statusEnum.color.opacity(0.1))
        .cornerRadius(4)
    }
}

#Preview {
    CharacterRowView(
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
        )
    )
}

