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
            id: "1613220757",
            name: "Severance",
            date: "2022-03-18",
            imageUrl: "https://is1-ssl.mzstatic.com/image/thumb/Publication126/v4/0c/cf/d5/0ccfd594-6286-9daf-df93-3239b2f07e1c/SEV1_BookCover.jpg/100x134bb.png"
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

    func testViewDidLoadCallsUpdateUIAndUpdateFavoriteButtonIcon() {
        // When
        viewModel.viewDidLoad()

        // Then
        XCTAssertTrue(mockView.updateUICalled, "updateUI metodu çağrılmadı!")
        XCTAssertTrue(mockView.updateFavoriteButtonIconCalled, "updateFavoriteButtonIcon metodu çağrılmadı!")
    }

    func testViewWillAppearCallsRightBarButtonItem() {
        // When
        viewModel.viewWillAppear()

        // Then
        XCTAssertTrue(mockView.rightBarButtonItemCalled, "rightBarButtonItem metodu çağrılmadı!")
    }

    func testFavoriteButtonTappedTogglesFavoriteAndUpdatesUI() {
        // When
        viewModel.favoriteButtonTapped()

        // Then
        XCTAssertTrue(mockCoreDataManager.toggleFavoriteCalled, "toggleFavorite metodu çağrılmadı!")
        XCTAssertTrue(mockView.updateFavoriteButtonIconCalled, "updateFavoriteButtonIcon metodu çağrılmadı!")
    }
}
