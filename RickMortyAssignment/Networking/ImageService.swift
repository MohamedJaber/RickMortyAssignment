//
//  ImageService.swift
//  RickMortyAssignment
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import Foundation
import SwiftUI

/// Centralized service for image loading and caching
actor ImageService {
    static let shared = ImageService()

    private init() {}

    /// Load image from URL with caching
    /// - Parameter url: Image URL string
    /// - Returns: SwiftUI Image if successful, nil otherwise
    func loadImage(from url: String) async -> Image? {
        // Check cache first
        if let cached = await ImageCache.shared.image(for: url) {
            AppLogger.network.debug("Image loaded from cache: \(url)")
            return Image(uiImage: cached)
        }
        
        // Load from network
        guard let imageURL = URL(string: url) else {
            AppLogger.network.debug("Invalid URL: \(url)")
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: imageURL)
            guard let uiImage = UIImage(data: data) else {
                AppLogger.network.debug("Failed to decode image: \(url)")
                return nil
            }
            
            // Cache the image
            await ImageCache.shared.setImage(uiImage, for: url)
            AppLogger.network.debug("Image loaded from network: \(url)")
            return Image(uiImage: uiImage)
            
        } catch {
            AppLogger.network.debug("Failed to load image: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Get cached image without attempting to load
    /// - Parameter url: Image URL string
    /// - Returns: Cached SwiftUI Image if available
    func getCachedImage(for url: String) async -> Image? {
        guard let cached = await ImageCache.shared.image(for: url) else { return nil }
        return Image(uiImage: cached)
    }

    /// Clear all cached images
    func clearCache() async {
        await ImageCache.shared.clearCache()
    }
}
