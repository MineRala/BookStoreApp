//
//  DetailViewControllerTests.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 6.02.2025.
//

import XCTest
@testable import BookStoreApp

final class DetailViewControllerTests: XCTestCase {

    var detailViewController: DetailViewController!
    var mockViewModel: MockDetailViewModel!
    var mockCacheManager: MockCacheManager!
    var book: BookModel!

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        detailViewController.loadViewIfNeeded()

        book = BookModel(
            artistName: "Anonymous",
            name: "Severance",
            date: "2022-03-18",
            imageUrl: "https://example.com/image.jpg"
        )


        mockCacheManager = MockCacheManager()
        mockCacheManager.imageToReturn = UIImage(named: "image")

        mockViewModel = MockDetailViewModel()
        detailViewController.viewModel = mockViewModel
    }

    override func tearDown() {
        detailViewController = nil
        mockViewModel = nil
        mockCacheManager = nil
        book = nil
        super.tearDown()
    }

    func testUpdateUIWithBook() {
        // When
        detailViewController.updateUI(with: book, cacheManager: mockCacheManager)

        // Then
        XCTAssertEqual(detailViewController.titleLabel.text, "Severance", "Kitap adı yanlış!")
        XCTAssertEqual(detailViewController.authorLabel.text, "Anonymous", "Yazar adı yanlış!")
        XCTAssertNotNil(detailViewController.imageView.image, "Resim yüklenmedi!")
    }

    func testFavoriteButtonTapped_CallsViewModelMethod() {
        // When
        detailViewController.favoriteButtonTapped()

        // Then
        XCTAssertTrue(mockViewModel.favoriteButtonTappedCalled, "favoriteButtonTapped metodu çağrılmadı!")
    }
}
