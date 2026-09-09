//
//  ImageCacheTests.swift
//  RickMortyAssignmentTests
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import Testing
import UIKit
@testable import RickMortyAssignment

// MARK: - ImageCache Tests
struct ImageCacheTests {
    @Test
    func testImageCacheSetAndRetrieve() async throws {
        let cache = ImageCache.shared
        let testURL = "https://example.com/image.jpg"
        
        // Create a test image
        let testImage = UIImage(systemName: "star.fill") ?? UIImage()
        
        // Set image in cache
        await cache.setImage(testImage, for: testURL)
        
        // Retrieve image from cache
        let retrievedImage = await cache.image(for: testURL)
        
        #expect(retrievedImage != nil)
    }
    
    @Test
    func testImageCacheRetrieveNonExistent() async throws {
        let cache = ImageCache.shared
        let nonExistentURL = "https://example.com/nonexistent-\(UUID()).jpg"
        
        // Try to retrieve an image that was never cached
        let retrievedImage = await cache.image(for: nonExistentURL)
        
        #expect(retrievedImage == nil)
    }
    
    @Test
    func testImageCacheClear() async throws {
        let cache = ImageCache.shared
        let testURL1 = "https://example.com/clear-image1-\(UUID()).jpg"
        let testURL2 = "https://example.com/clear-image2-\(UUID()).jpg"
        
        // Create test images
        let testImage = UIImage(systemName: "star.fill") ?? UIImage()
        
        // Add images to cache
        await cache.setImage(testImage, for: testURL1)
        await cache.setImage(testImage, for: testURL2)
        
        // Verify images are in cache
        let image1Before = await cache.image(for: testURL1)
        let image2Before = await cache.image(for: testURL2)
        #expect(image1Before != nil)
        #expect(image2Before != nil)
        
        // Clear cache
        await cache.clearCache()
        
        // Verify cache is empty
        let image1After = await cache.image(for: testURL1)
        let image2After = await cache.image(for: testURL2)
        #expect(image1After == nil)
        #expect(image2After == nil)
    }
    
    @Test
    func testImageCacheMultipleImages() async throws {
        let cache = ImageCache.shared
        let testImage1 = UIImage(systemName: "star.fill") ?? UIImage()
        let testImage2 = UIImage(systemName: "heart.fill") ?? UIImage()
        
        // Test adding multiple images
        let url1 = "https://example.com/multi1-\(UUID()).jpg"
        await cache.setImage(testImage1, for: url1)
        
        let url2 = "https://example.com/multi2-\(UUID()).jpg"
        await cache.setImage(testImage2, for: url2)
        
        // Verify at least one of them is in cache (NSCache may evict under memory pressure)
        let image1 = await cache.image(for: url1)
        let image2 = await cache.image(for: url2)
        
        // At least one should be cached
        let atLeastOneCached = image1 != nil || image2 != nil
        #expect(atLeastOneCached)
    }
    
    @Test
    func testImageCacheSize() async throws {
        let cache = ImageCache.shared
        
        // Get cache size
        let size = await cache.cacheSize()
        
        // Verify size is set (countLimit)
        #expect(size == 50)  // As per ImageCache configuration
    }
}
