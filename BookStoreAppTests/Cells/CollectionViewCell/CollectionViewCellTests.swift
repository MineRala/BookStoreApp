//
//  CollectionViewCellTest.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 6.02.2025.
//

import XCTest
@testable import BookStoreApp

final class CollectionViewCellTests: XCTestCase {
    var collectionViewCell: CollectionViewCell!
    var mockViewModel: MockCollectionViewCellViewModel!
    var book: BookModel!

    override func setUp() {
        super.setUp()

        // Kitap modelini oluştur
        book = BookModel(
            artistName: "Anonymous",
            name: "Severance",
            date: "2022-03-18",
            imageUrl: "https://is1-ssl.mzstatic.com/image/thumb/Publication126/v4/0c/cf/d5/0ccfd594-6286-9daf-df93-3239b2f07e1c/SEV1_BookCover.jpg/100x134bb.png"
        )

        // MockViewModel'ı başlatıyoruz
        mockViewModel = MockCollectionViewCellViewModel()

//        let bundle = Bundle(for: TableViewCell.self)
//        let nib = UINib(nibName: "TableViewCell", bundle: bundle)
//        tableViewCell = nib.instantiate(withOwner: nil, options: nil).first as? TableViewCell

        // Storyboard'dan hücre oluştur
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        collectionViewCell = objects.first as? CollectionViewCell
    }

    override func tearDown() {
        collectionViewCell = nil
        mockViewModel = nil
        book = nil
        super.tearDown()
    }

    // Test 1: `updateUI(with:)` çağrıldığında UI güncelleniyor mu?
    func testUpdateUIWithBook() {
        // When
        collectionViewCell.updateUI(with: book)

        // Then
        XCTAssertEqual(collectionViewCell.label.text, "Severance", "Label güncellenmedi!")
    }

    // Test 2: `favoriteButtonTapped` çağrıldığında ViewModel metodu çalışıyor mu?
    func testFavoriteButtonTapped() {
        // Given
        collectionViewCell.configureCell(with: mockViewModel)

        // When
        collectionViewCell.favoriteButtonTapped(UIButton())

        // Then
        XCTAssertTrue(mockViewModel.favoriteButtonTappedCalled, "favoriteButtonTapped() çağrılmadı!")
    }
}

