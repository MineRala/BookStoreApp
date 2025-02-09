//
//  DetailViewModelTests.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 6.02.2025.
//

import XCTest
@testable import BookStoreApp

final class DetailViewModelTests: XCTestCase {
    // MARK: - Properties
    var viewModel: DetailViewModel!
    var mockViewController: MockDetailViewController!
    var mockCoreDataManager: MockCoreDataManager!
    var book: BookModel!

    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()

        book = BookModel(
            artistName: "Anonymous",
            id: "1613220757",
            name: "Severance",
            date: "2022-03-18",
            imageUrl: "https://is1-ssl.mzstatic.com/image/thumb/Publication126/v4/0c/cf/d5/0ccfd594-6286-9daf-df93-3239b2f07e1c/SEV1_BookCover.jpg/100x134bb.png"
        )

        mockViewController = MockDetailViewController()
        mockCoreDataManager = MockCoreDataManager()

        viewModel = DetailViewModel(book: book, coreDataManager: mockCoreDataManager, view: mockViewController)
    }

    override func tearDown() {
        viewModel = nil
        mockViewController = nil
        mockCoreDataManager = nil
        book = nil
        super.tearDown()
    }

    // MARK: - View Lifecycle Tests
    func testViewDidLoadCallsUpdateUIAndFavoriteButtonIcon() {
        // When
        viewModel.viewDidLoad()

        // Then
        XCTAssertTrue(mockViewController.updateUICalled, "updateUI method was not called!")
        XCTAssertTrue(mockViewController.updateFavoriteButtonIconCalled, "updateFavoriteButtonIcon method was not called!")
        XCTAssertEqual(mockViewController.lastFavoriteState, book.isFavorite, "Favorite button icon should be set to book's initial favorite state!")
    }

    func testViewWillAppearCallsRightBarButtonItem() {
        // When
        viewModel.viewWillAppear()

        // Then
        XCTAssertTrue(mockViewController.rightBarButtonItemCalled, "rightBarButtonItem method was not called!")
    }

    // MARK: - Favorite Button Tests
    func testFavoriteButtonTappedTogglesFavoriteAndUpdatesUI() {
        // Given
        let initialFavoriteState = book.isFavorite

        // When
        viewModel.favoriteButtonTapped()

        // Then
        XCTAssertTrue(mockCoreDataManager.toggleFavoriteCalled, "toggleFavorite method was not called!")
        XCTAssertTrue(mockViewController.updateFavoriteButtonIconCalled, "updateFavoriteButtonIcon method was not called!")
        XCTAssertNotEqual(mockCoreDataManager.isFavorite, initialFavoriteState, "Favorite state should be toggled!")
    }

    func testFavoriteButtonTappedPostsNotification() {
        // Given
        let expectation = XCTNSNotificationExpectation(name: NSNotification.Name(Constants.favoritesUpdatedNotification))

        // When
        viewModel.favoriteButtonTapped()

        // Then
        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockViewController.lastFavoriteState, book.isFavorite, "Favorite button should reflect the new favorite state!")
    }
}
