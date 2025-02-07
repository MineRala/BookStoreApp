//
//  CollectionViewCellViewModelTest.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 6.02.2025.
//

import XCTest
@testable import BookStoreApp

final class CollectionViewCellViewModelTests: XCTestCase {
    var mockCell: MockCollectionViewCell!
    var viewModel: CollectionViewCellViewModel!
    var book: BookModel!
    var mockCoreDataManager: MockCoreDataManager!

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

    func testViewDidLoadCallsUpdateUI() {
        // When
        viewModel.viewDidLoad()

        // Then
        XCTAssertTrue(mockCell.updateUICalled, "ViewModel'in updateUI metodu çağrılmadı!")
        XCTAssertEqual(mockCell.bookPassed?.name, "Severance", "Kitap adı eşleşmiyor!")
        XCTAssertEqual(mockCell.bookPassed?.artistName, "Anonymous", "Sanatçı adı eşleşmiyor!")
        XCTAssertEqual(mockCell.bookPassed?.date, "2022-03-18", "Tarih eşleşmiyor!")
        XCTAssertEqual(mockCell.bookPassed?.imageUrl, "https://is1-ssl.mzstatic.com/image/thumb/Publication126/v4/0c/cf/d5/0ccfd594-6286-9daf-df93-3239b2f07e1c/SEV1_BookCover.jpg/100x134bb.png", "Resim URL'si eşleşmiyor!")
    }

    func testFavoriteButtonTapped() {
           // Given
           XCTAssertFalse(mockCoreDataManager.toggleFavoriteCalled, "Favori işlemi daha önce yapılmış!")

           // When
           viewModel.favoriteButtonTapped()

           // Then
           XCTAssertTrue(mockCoreDataManager.toggleFavoriteCalled, "favoriteButtonTapped() metodu CoreDataManager'ı tetiklemedi!")
           XCTAssertEqual(mockCoreDataManager.favoriteBookPassed?.name, "Severance", "Favori kitap doğru değil!")
       }

       func testToggleFavoriteUpdatesCoreData() {
           // Given
           XCTAssertFalse(mockCoreDataManager.isFavorite, "Başlangıçta favori olmamalı!")

           // When
           viewModel.favoriteButtonTapped()

           // Then
           XCTAssertTrue(mockCoreDataManager.isFavorite, "Favori durumu değişmedi!")

           // When
           viewModel.favoriteButtonTapped()

           // Then
           XCTAssertFalse(mockCoreDataManager.isFavorite, "Favori durumu geri alınmadı!")
       }
}
