//
//  TableViewCellViewModelTests.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 6.02.2025.
//

import XCTest
@testable import BookStoreApp

final class TableViewCellViewModelTests: XCTestCase {

    func testViewModelCallsUpdateUI() {
        // Given
        let book = BookModel(
            artistName: "Anonymous",
            name: "Severance",
            date: "2022-03-18",
            imageUrl: "https://is1-ssl.mzstatic.com/image/thumb/Publication126/v4/0c/cf/d5/0ccfd594-6286-9daf-df93-3239b2f07e1c/SEV1_BookCover.jpg/100x134bb.png"
        )
        let mockCell = MockTableViewCell()
        let viewModel = TableViewCellViewModel(book: book, view: mockCell)

        // When
        viewModel.viewDidLoad()

        // Then
        XCTAssertTrue(mockCell.isUpdateUICalled, "ViewModel'in updateUI metodu çağrılmadı!")
        XCTAssertEqual(mockCell.updatedBook?.name, "Severance")
        XCTAssertEqual(mockCell.updatedBook?.artistName, "Anonymous")
        XCTAssertEqual(mockCell.updatedBook?.date, "2022-03-18")
        XCTAssertEqual(mockCell.updatedBook?.imageUrl, "https://is1-ssl.mzstatic.com/image/thumb/Publication126/v4/0c/cf/d5/0ccfd594-6286-9daf-df93-3239b2f07e1c/SEV1_BookCover.jpg/100x134bb.png")
    }
}
