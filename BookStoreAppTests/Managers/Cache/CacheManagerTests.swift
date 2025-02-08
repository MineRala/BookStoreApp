//
//  CacheManagerTests.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 6.02.2025.
//
import XCTest
@testable import BookStoreApp

final class CacheManagerTests: XCTestCase {
    var mockCacheManager: MockCacheManager!

    let testImageURL = "https://is1-ssl.mzstatic.com/image/thumb/Publication126/v4/0c/cf/d5/0ccfd594-6286-9daf-df93-3239b2f07e1c/SEV1_BookCover.jpg/100x134bb.png"

    var testImage: UIImage?

    override func setUp() {
        super.setUp()
        mockCacheManager = MockCacheManager()

        testImage = UIImage(named: "image") // "image" asset ismi
    }

    override func tearDown() {
        mockCacheManager = nil
        testImage = nil
        super.tearDown()
    }

    func testCacheImageStoresImageCorrectly() {
        // Given
        guard let image = testImage else {
            XCTFail("Image could not be loaded from assets!")
            return
        }

        // When
        mockCacheManager.cacheImage(image, for: testImageURL)

        // Then
        let cachedImage = mockCacheManager.getImage(for: testImageURL)
        XCTAssertNotNil(cachedImage, "Image was not cached correctly!")
        XCTAssertEqual(cachedImage, image, "The cached image is not the same as the original image!")
    }

    func testLoadImageReturnsCachedImageWhenAvailable() {
        // Given
        guard let image = testImage else {
            XCTFail("Image could not be loaded from assets!")
            return
        }
        mockCacheManager.imageToReturn = image

        // When
        var returnedImage: UIImage?
        mockCacheManager.loadImage(from: testImageURL) { image in
            returnedImage = image
        }

        // Then
        XCTAssertTrue(mockCacheManager.loadImageCalled, "loadImage was not called!")
        XCTAssertEqual(returnedImage, image, "The cached image was not returned!")
    }

    func testLoadImageReturnsNilWhenImageNotInCache() {
        // Given
        // No image in cache

        // When
        var returnedImage: UIImage?
        mockCacheManager.loadImage(from: testImageURL) { image in
            returnedImage = image
        }

        // Then
        XCTAssertTrue(mockCacheManager.loadImageCalled, "loadImage was not called!")
        XCTAssertNil(returnedImage, "Image should be nil when not in cache!")
    }

    func testLoadImageReturnsImageFromURL() {
        // Given
        guard let expectedImage = testImage else {
            XCTFail("Image could not be loaded from assets!")
            return
        }
        mockCacheManager.imageToReturn = expectedImage

        // When
        var returnedImage: UIImage?
        mockCacheManager.loadImage(from: testImageURL) { image in
            returnedImage = image
        }

        // Then
        XCTAssertTrue(mockCacheManager.loadImageCalled, "loadImage was not called!")
        XCTAssertEqual(returnedImage, expectedImage, "The image returned from the URL is not correct!")
    }
}
