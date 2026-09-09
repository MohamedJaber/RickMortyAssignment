//
//  ImageCache.swift
//  RickMortyAssignment
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import Foundation
import UIKit

/// Thread-safe image cache using NSCache with automatic memory management
actor ImageCache {
    static let shared = ImageCache()

    private let cache = NSCache<NSString, UIImage>()

    private init() {
        // Configure NSCache with reasonable limits
        cache.countLimit = 50  // Max number of images
        cache.totalCostLimit = 50 * 1024 * 1024  // 50MB total
    }
    
    /// Retrieves an image from cache
    func image(for url: String) -> UIImage? {
        return cache.object(forKey: url as NSString)
    }
    
    /// Stores an image in cache with cost (image data size)
    func setImage(_ image: UIImage, for url: String) {
        let cost = Int(image.size.width * image.size.height * 4)  // Approximate bytes (RGBA)
        cache.setObject(image, forKey: url as NSString, cost: cost)
        AppLogger.network.debug("Image cached: \(url)")
    }
    
    /// Clears all cached images
    func clearCache() {
        cache.removeAllObjects()
        AppLogger.network.debug("Image cache cleared")
    }
    
    /// Gets current cache size
    func cacheSize() -> Int {
        return cache.countLimit
    }
}

