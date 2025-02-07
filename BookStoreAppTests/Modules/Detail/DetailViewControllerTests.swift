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

        book = BookModel(
            artistName: "Anonymous",
            id: "1613220757",
            name: "Severance",
            date: "2022-03-18",
            imageUrl: "https://is1-ssl.mzstatic.com/image/thumb/Publication126/v4/0c/cf/d5/0ccfd594-6286-9daf-df93-3239b2f07e1c/SEV1_BookCover.jpg/100x134bb.png"
        )

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        detailViewController.loadViewIfNeeded()

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

    func testViewModelViewDidLoadCalled() {
        // Given
        detailViewController.book = book

        // When
        detailViewController.viewDidLoad()

        // Then
        XCTAssertTrue(mockViewModel.viewDidLoadCalled, "viewDidLoad metodu çağrılmadı!")
    }

    func testViewModelViewWillAppearCalled() {
        // When
        detailViewController.viewWillAppear(true)

        // Then
        XCTAssertTrue(mockViewModel.viewWillAppearCalled, "viewWillAppear metodu çağrılmadı!")
    }

    func testFavoriteButtonTappedCallsViewModelMethod() {
        // When
        detailViewController.favoriteButtonTapped()

        // Then
        XCTAssertTrue(mockViewModel.favoriteButtonTappedCalled, "favoriteButtonTapped metodu çağrılmadı!")
    }
}
