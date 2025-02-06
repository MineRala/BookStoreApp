//
//  DetailViewModelTests.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 6.02.2025.
//

import XCTest
@testable import BookStoreApp

final class DetailViewModelTests: XCTestCase {
    var viewModel: DetailViewModel!
    var mockView: MockDetailViewController!
    var mockCoreDataManager: MockCoreDataManager!
    var book: BookModel!

    override func setUp() {
        super.setUp()

        book = BookModel(
            artistName: "Anonymous",
            name: "Severance",
            date: "2022-03-18",
            imageUrl: "https://example.com/image.jpg"
        )

        mockView = MockDetailViewController()
        mockCoreDataManager = MockCoreDataManager()

        viewModel = DetailViewModel(book: book, coreDataManager: mockCoreDataManager, view: mockView)
    }

    override func tearDown() {
        viewModel = nil
        mockView = nil
        mockCoreDataManager = nil
        book = nil
        super.tearDown()
    }

    func testViewDidLoad_CallsUpdateUIAndUpdateFavoriteButtonIcon() {
        // When
        viewModel.viewDidLoad()

        // Then
        XCTAssertTrue(mockView.updateUICalled, "updateUI metodu çağrılmadı!")
        XCTAssertTrue(mockView.updateFavoriteButtonIconCalled, "updateFavoriteButtonIcon metodu çağrılmadı!")
    }

    func testViewWillAppear_CallsRightBarButtonItem() {
        // When
        viewModel.viewWillAppear()

        // Then
        XCTAssertTrue(mockView.rightBarButtonItemCalled, "rightBarButtonItem metodu çağrılmadı!")
    }

    func testFavoriteButtonTapped_TogglesFavoriteAndUpdatesUI() {
        // When
        viewModel.favoriteButtonTapped()

        // Then
        XCTAssertTrue(mockCoreDataManager.toggleFavoriteCalled, "toggleFavorite metodu çağrılmadı!")
        XCTAssertTrue(mockView.updateFavoriteButtonIconCalled, "updateFavoriteButtonIcon metodu çağrılmadı!")
    }
}
