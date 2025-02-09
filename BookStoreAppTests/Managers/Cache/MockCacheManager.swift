//
//  MockCacheManager.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 6.02.2025.
//

import XCTest
@testable import BookStoreApp

final class MockCacheManager: CacheManagerInterface {
    // MARK: - Test Flags
    var loadImageCalled = false
    
    // MARK: - Properties
    var imageToReturn: UIImage?
    private var cachedImages = [String: UIImage]()

    // MARK: - Methods
    func getImage(for url: String) -> UIImage? {
        return cachedImages[url]
    }

    func cacheImage(_ image: UIImage, for url: String) {
        cachedImages[url] = image
    }

    func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        loadImageCalled = true
        completion(imageToReturn)
    }
}
