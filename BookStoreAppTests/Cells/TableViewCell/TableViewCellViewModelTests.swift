//
//  TableViewCellViewModelTests.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 6.02.2025.
//

import XCTest
@testable import BookStoreApp

final class TableViewCellViewModelTests: XCTestCase {
    var viewModel: TableViewCellViewModel!
    var book: BookModel!
    var mockCell: MockTableViewCell!

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

    func testViewDidLoadCallsUpdateUI() {
        // When
        viewModel.viewDidLoad()

        // Then
        XCTAssertTrue(mockCell.isUpdateUICalled, "ViewModel'in updateUI metodu çağrılmadı!")
        XCTAssertEqual(mockCell.updatedBook?.name, "Severance", "Kitap adı eşleşmiyor!")
        XCTAssertEqual(mockCell.updatedBook?.artistName, "Anonymous", "Sanatçı adı eşleşmiyor!")
        XCTAssertEqual(mockCell.updatedBook?.date, "2022-03-18", "Tarih eşleşmiyor!")
        XCTAssertEqual(mockCell.updatedBook?.imageUrl, "https://is1-ssl.mzstatic.com/image/thumb/Publication126/v4/0c/cf/d5/0ccfd594-6286-9daf-df93-3239b2f07e1c/SEV1_BookCover.jpg/100x134bb.png", "Resim URL'si eşleşmiyor!")
    }
}
