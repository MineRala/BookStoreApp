//
//  CollectionViewCellViewModelTest.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 6.02.2025.
//

import XCTest
@testable import BookStoreApp

final class CollectionViewCellViewModelTests: XCTestCase {
    var mockView: MockCollectionViewCell!
    var viewModel: CollectionViewCellViewModel!
    var book: BookModel!

    override func setUp() {
        super.setUp()

        book = BookModel(
            artistName: "Anonymous",
            name: "Severance",
            date: "2022-03-18",
            imageUrl: "https://is1-ssl.mzstatic.com/image/thumb/Publication126/v4/0c/cf/d5/0ccfd594-6286-9daf-df93-3239b2f07e1c/SEV1_BookCover.jpg/100x134bb.png"
        )

        mockView = MockCollectionViewCell()
        viewModel = CollectionViewCellViewModel(book: book, view: mockView)
    }

    override func tearDown() {
        viewModel = nil
        mockView = nil
        book = nil
        super.tearDown()
    }

    func testFavoriteButtonTapped() {
        // Given
        let mockCoreDataManager = MockCoreDataManager()
        let testViewModel = CollectionViewCellViewModel(book: book, coreDataManager: mockCoreDataManager, view: mockView)

        // When
        testViewModel.favoriteButtonTapped()

        // Then
        XCTAssertTrue(mockCoreDataManager.toggleFavoriteCalled, "favoriteButtonTapped() metodu CoreDataManager'ı tetiklemedi!")
    }


    func testViewDidLoadCallsUpdateUI() {
        // When
        viewModel.viewDidLoad()

        // Then
        XCTAssertTrue(mockView.updateUICalled, "updateUI metodu çağrılmadı!")
        XCTAssertEqual(mockView.bookPassed?.name, "Severance", "Kitap adı yanlış!")
    }

}
