//
//  TableViewCellViewModelTests.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 6.02.2025.
//

import XCTest
@testable import BookStoreApp

// MARK: - TableViewCellViewModel Tests
final class TableViewCellViewModelTests: XCTestCase {
    // MARK: - Properties
    var viewModel: TableViewCellViewModel!
    var book: BookModel!
    var mockCell: MockTableViewCell!

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

        mockCell = MockTableViewCell()
        viewModel = TableViewCellViewModel(book: book, view: mockCell)
    }

    override func tearDown() {
        viewModel = nil
        mockCell = nil
        book = nil
        super.tearDown()
    }

    // MARK: - Lifecycle Test
    func testViewDidLoad() {
        // When
        viewModel.viewDidLoad()

        // Then
        XCTAssertTrue(mockCell.isUpdateUICalled, "The ViewModel's updateUI method was not called!")
        XCTAssertEqual(mockCell.updatedBook?.name, "Severance", "The book name does not match!")
        XCTAssertEqual(mockCell.updatedBook?.artistName, "Anonymous", "The artist name does not match!")
        XCTAssertEqual(mockCell.updatedBook?.date, "2022-03-18", "The date does not match!")
        XCTAssertEqual(mockCell.updatedBook?.imageUrl, "https://is1-ssl.mzstatic.com/image/thumb/Publication126/v4/0c/cf/d5/0ccfd594-6286-9daf-df93-3239b2f07e1c/SEV1_BookCover.jpg/100x134bb.png", "The image URL does not match!")
    }
}
