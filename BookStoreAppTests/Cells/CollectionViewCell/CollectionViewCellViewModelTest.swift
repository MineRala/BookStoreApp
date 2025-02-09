//
//  CollectionViewCellViewModelTest.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 6.02.2025.
//

import XCTest
@testable import BookStoreApp

// MARK: - CollectionViewCellViewModel Tests
final class CollectionViewCellViewModelTests: XCTestCase {
    // MARK: - Properties
    var mockCell: MockCollectionViewCell!
    var viewModel: CollectionViewCellViewModel!
    var book: BookModel!
    var mockCoreDataManager: MockCoreDataManager!

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

        mockCoreDataManager = MockCoreDataManager()
        mockCell = MockCollectionViewCell()
        viewModel = CollectionViewCellViewModel(book: book, coreDataManager: mockCoreDataManager, view: mockCell)
    }

    override func tearDown() {
        viewModel = nil
        mockCell = nil
        book = nil
        mockCoreDataManager = nil
        super.tearDown()
    }

    // MARK: - Lifecycle Test
    func testViewDidLoadCallsUpdateUI() {
        // When
        viewModel.viewDidLoad()

        // Then
        XCTAssertTrue(mockCell.updateUICalled, "The ViewModel's updateUI method was not called!")
        XCTAssertEqual(mockCell.bookPassed?.name, "Severance", "The book name doesn't match!")
        XCTAssertEqual(mockCell.bookPassed?.artistName, "Anonymous", "The artist name doesn't match!")
        XCTAssertEqual(mockCell.bookPassed?.date, "2022-03-18", "The date doesn't match!")
        XCTAssertEqual(mockCell.bookPassed?.imageUrl, "https://is1-ssl.mzstatic.com/image/thumb/Publication126/v4/0c/cf/d5/0ccfd594-6286-9daf-df93-3239b2f07e1c/SEV1_BookCover.jpg/100x134bb.png", "The image URL doesn't match!")
    }

    // MARK: - Favorite Button Test
    func testFavoriteButtonTapped() {
        // Given
        XCTAssertFalse(mockCoreDataManager.toggleFavoriteCalled, "The favorite action has been performed earlier!")

        // When
        viewModel.favoriteButtonTapped()

        // Then
        XCTAssertTrue(mockCoreDataManager.toggleFavoriteCalled, "The favoriteButtonTapped() method did not trigger CoreDataManager!")
        XCTAssertEqual(mockCoreDataManager.favoriteBookPassed?.name, "Severance", "The favorite book is incorrect!")
    }

    // MARK: - Toggle Favorite Updates Core Data Test
    func testToggleFavoriteUpdatesCoreData() {
        // Given
        XCTAssertFalse(mockCoreDataManager.isFavorite, "It should not be a favorite initially!")

        // When
        viewModel.favoriteButtonTapped()

        // Then
        XCTAssertTrue(mockCoreDataManager.isFavorite, "The favorite status did not change!")

        // When
        viewModel.favoriteButtonTapped()

        // Then
        XCTAssertFalse(mockCoreDataManager.isFavorite, "The favorite status was not reverted!")
    }
}

