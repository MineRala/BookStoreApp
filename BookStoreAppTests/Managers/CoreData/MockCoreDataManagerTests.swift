import Foundation
import CoreData
import XCTest
@testable import BookStoreApp

final class MockCoreDataManagerTests: XCTestCase {
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
        mockCoreDataManager = MockCoreDataManager()
    }

    override func tearDown() {
        mockCoreDataManager = nil
        book = nil
        super.tearDown()
    }

    func testAddFavorite() {
        let bookId = book.id ?? ""

        // When
        mockCoreDataManager.addFavorite(with: book)

        // Then
        XCTAssertTrue(mockCoreDataManager.addFavoriteCalled, "The addFavorite method was not called!")
        XCTAssertEqual(mockCoreDataManager.favoriteBookPassed?.name, "Severance", "The favorite book was passed incorrectly!")
        XCTAssertTrue(mockCoreDataManager.isBookFavorite(bookId: bookId), "The book was not added to favorites!")
    }

    func testRemoveFavorite() {
        let bookId = book.id ?? ""

        // Given
        mockCoreDataManager.addFavorite(with: book)
        XCTAssertTrue(mockCoreDataManager.isBookFavorite(bookId: bookId), "The book was not added to favorites!")

        // When
        mockCoreDataManager.removeFavorite(bookId: bookId)

        // Then
        XCTAssertFalse(mockCoreDataManager.isBookFavorite(bookId: bookId), "The book was not removed from favorites!")
    }


    func testToggleFavorite() {
        let bookId = book.id ?? ""

        XCTAssertFalse(mockCoreDataManager.isBookFavorite(bookId: bookId), "The book should not be a favorite initially!")

        mockCoreDataManager.toggleFavorite(book: book)

        XCTAssertTrue(mockCoreDataManager.toggleFavoriteCalled, "The toggleFavorite method was not called!")

        XCTAssertTrue(mockCoreDataManager.isBookFavorite(bookId: bookId), "The book was not added to favorites!")

        mockCoreDataManager.toggleFavorite(book: book)

        XCTAssertFalse(mockCoreDataManager.isBookFavorite(bookId: bookId), "The book was not removed from favorites!")
    }

}
