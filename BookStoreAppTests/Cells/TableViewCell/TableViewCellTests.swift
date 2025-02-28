//
//  TableViewCellTests.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 6.02.2025.
//

import XCTest
@testable import BookStoreApp

// MARK: - TableViewCell Tests
final class TableViewCellTests: XCTestCase {
    // MARK: - Properties
    var tableViewCell: TableViewCell!
    var mockViewModel: MockTableViewCellViewModel!
    var mockCacheManager: MockCacheManager!
    var book: BookModel!

    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()

        // BookModel instance
        book = BookModel(
            artistName: "Anonymous",
            id: "1613220757",
            name: "Severance",
            date: "2022-03-18",
            imageUrl: "https://is1-ssl.mzstatic.com/image/thumb/Publication126/v4/0c/cf/d5/0ccfd594-6286-9daf-df93-3239b2f07e1c/SEV1_BookCover.jpg/100x134bb.png"
        )

        mockViewModel = MockTableViewCellViewModel()
        mockCacheManager = MockCacheManager()
        mockCacheManager.imageToReturn = UIImage(named: "image")

        let bundle = Bundle(for: TableViewCell.self)
        let nib = UINib(nibName: "TableViewCell", bundle: bundle)
        tableViewCell = nib.instantiate(withOwner: nil, options: nil).first as? TableViewCell
    }

    override func tearDown() {
        tableViewCell = nil
        mockViewModel = nil
        mockCacheManager = nil
        book = nil
        super.tearDown()
    }

    // MARK: - Lifecycle Test
    func testViewModelViewDidLoadCalled() {
        // When
        tableViewCell.configureCell(with: mockViewModel)

        // Then
        XCTAssertTrue(mockViewModel.viewDidLoadCalled, "viewDidLoad should be called in the view model when the cell is configured")
    }

    // MARK: Update UI Test
    func testUpdateUIWithBook() {
        // When
        tableViewCell.updateUI(with: book, cacheManager: mockCacheManager)

        // Then
        XCTAssertEqual(tableViewCell.titleLabel.text, "Severance", "Title label should display the correct book name")
        XCTAssertEqual(tableViewCell.authorLabel.text, "Anonymous", "Author label should display the correct author name")
        XCTAssertEqual(tableViewCell.dateLabel.text, "18.03.2022", "Date label should display the correct date format")
        XCTAssertNotNil(tableViewCell.posterImageView.image, "Poster image should not be nil")
    }
}
