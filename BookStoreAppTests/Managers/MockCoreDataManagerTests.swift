import Foundation
import CoreData
@testable import BookStoreApp
import XCTest


final class MockCoreDataManagerTests: XCTestCase {

    var mockCoreDataManager: MockCoreDataManager!
    var book: BookModel!

    override func setUp() {
        super.setUp()

        // Test için bir kitap modelini oluşturuyoruz
        book = BookModel(
            artistName: "Anonymous",
            name: "Severance",
            date: "2022-03-18",
            imageUrl: "https://is1-ssl.mzstatic.com/image/thumb/Publication126/v4/0c/cf/d5/0ccfd594-6286-9daf-df93-3239b2f07e1c/SEV1_BookCover.jpg/100x134bb.png"
        )

        // MockCoreDataManager'ı başlatıyoruz
        mockCoreDataManager = MockCoreDataManager()
    }

    override func tearDown() {
        mockCoreDataManager = nil
        book = nil
        super.tearDown()
    }

    func testAddFavorite() {
        // When
        mockCoreDataManager.addFavorite(with: book)

        // Then
        XCTAssertTrue(mockCoreDataManager.addFavoriteCalled, "addFavorite metodu çağrılmadı!")
        XCTAssertEqual(mockCoreDataManager.favoriteBookPassed?.name, "Severance", "Favori kitap yanlış geçti!")
    }

    func testRemoveFavorite() {
        // When
        mockCoreDataManager.removeFavorite(bookId: book.id ?? "")

        // Then
        XCTAssertTrue(mockCoreDataManager.removeFavoriteCalled, "removeFavorite metodu çağrılmadı!")
//        XCTAssertEqual(mockCoreDataManager.bookIdPassed, book.id, "BookId yanlış geçti!")
    }

    func testToggleFavorite() {
        // When
        mockCoreDataManager.toggleFavorite(book: book)

        // Then
        XCTAssertTrue(mockCoreDataManager.toggleFavoriteCalled, "toggleFavorite metodu çağrılmadı!")
        XCTAssertEqual(mockCoreDataManager.favoriteBookPassed?.name, "Severance", "Favori kitap yanlış geçti!")
    }
}
