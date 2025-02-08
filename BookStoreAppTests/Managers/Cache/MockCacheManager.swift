//
//  MockCacheManager.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 6.02.2025.
//

import XCTest
@testable import BookStoreApp

class MockCacheManager: CacheManagerInterface {
    var imageToReturn: UIImage?
    var loadImageCalled = false
    private var cachedImages = [String: UIImage]()

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
