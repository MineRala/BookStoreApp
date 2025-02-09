//
//  CollectionViewCellTest.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 6.02.2025.
//

import XCTest
@testable import BookStoreApp

// MARK: - CollectionViewCell Tests
final class CollectionViewCellTests: XCTestCase {
    // MARK: - Properties
    var collectionViewCell: CollectionViewCell!
    var mockViewModel: MockCollectionViewCellViewModel!
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
        mockViewModel = MockCollectionViewCellViewModel(book: book, coreDataManager: mockCoreDataManager)

        let bundle = Bundle(for: CollectionViewCell.self)
        let nib = UINib(nibName: "CollectionViewCell", bundle: bundle)
        collectionViewCell = nib.instantiate(withOwner: nil, options: nil).first as? CollectionViewCell
    }

    override func tearDown() {
        collectionViewCell = nil
        mockCoreDataManager = nil
        mockViewModel = nil
        book = nil
        super.tearDown()
    }

    // MARK: - Lifecycle Test
    func testViewModelViewDidLoadCalled() {
        // When
        collectionViewCell.configureCell(with: mockViewModel)

        // Then
        XCTAssertTrue(mockViewModel.viewDidLoadCalled, "viewDidLoad should be called in the view model when the cell is configured")
    }

    // MARK: -  UI Test
    func testUpdateUIWithBook() {
        // When
        collectionViewCell.updateUI(with: book)

        // Then
        XCTAssertEqual(collectionViewCell.label.text, "Severance", "Label not updated!")

        let expectedImage = UIImage(systemName: "star.fill")?
            .withTintColor(.yellow, renderingMode: .alwaysOriginal)

        XCTAssertEqual(collectionViewCell.favoriteButton.image(for: .normal)?.cgImage, expectedImage?.cgImage, "Favori butonunun ikonu doğru değil!")
    }

    // MARK: - Favorite Button Test
    func testFavoriteButtonTapped() {
        // Given
        collectionViewCell.configureCell(with: mockViewModel)

        XCTAssertFalse(mockCoreDataManager.isFavorite, "It should not be a favorite initially!")

        // When
        collectionViewCell.favoriteButtonTapped(UIButton())

        // Then
        XCTAssertTrue(mockViewModel.favoriteButtonTappedCalled, "favoriteButtonTapped() was not called!")
        XCTAssertTrue(mockCoreDataManager.isFavorite, "Favorite status was not updated correctly!")

        // When
        collectionViewCell.favoriteButtonTapped(UIButton())

        // Then
        XCTAssertFalse(mockCoreDataManager.isFavorite, "The favorite status was not reverted!")
    }
}
