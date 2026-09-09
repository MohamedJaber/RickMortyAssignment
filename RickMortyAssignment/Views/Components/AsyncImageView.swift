//
//  AsyncImageView.swift
//  RickMortyAssignment
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import SwiftUI

struct AsyncImageView: View {
    var url: String?
    var preloadedImage: Image?
    
    @State private var image: Image?
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            // Show preloaded image first, otherwise show loaded image
            if let display = preloadedImage ?? image {
                display
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .cornerRadius(12)
                    .clipped()
                    .transition(.opacity)
                    
            } else if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                    
            } else {
                Image(systemName: "person.crop.square.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
            }
        }
        .task {
            // Only load if preloadedImage not provided and URL exists
            if preloadedImage == nil, let url = url {
                await loadImage(from: url)
            }
        }
    }
    
    private func loadImage(from url: String) async {
        isLoading = true
        defer { isLoading = false }
        image = await ImageService.shared.loadImage(from: url)
    }
}

#Preview {
    AsyncImageView(url: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
}

