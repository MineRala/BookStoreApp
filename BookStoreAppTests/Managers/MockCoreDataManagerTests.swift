import Foundation
import CoreData
import XCTest
@testable import BookStoreApp

final class MockCoreDataManagerTests: XCTestCase {

    var mockCoreDataManager: MockCoreDataManager!
    var book: BookModel!

    override func setUp() {
        super.setUp()

        // Test için bir kitap modelini oluşturuyoruz
        book = BookModel(
            artistName: "Anonymous",
            id: "1613220757",
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
        let bookId = book.id ?? ""

        // When: Kitap favorilere ekleniyor
        mockCoreDataManager.addFavorite(with: book)

        // Then: addFavorite çağrılmış mı?
        XCTAssertTrue(mockCoreDataManager.addFavoriteCalled, "addFavorite metodu çağrılmadı!")

        // Eklenen kitabın adı doğru mu?
        XCTAssertEqual(mockCoreDataManager.favoriteBookPassed?.name, "Severance", "Favori kitap yanlış geçti!")

        // Kitap gerçekten favorilere eklenmiş mi?
        XCTAssertTrue(mockCoreDataManager.isBookFavorite(bookId: bookId), "Kitap favorilere eklenmedi!")
    }


    func testRemoveFavorite() {
        let bookId = book.id ?? ""

        // Given: Önce kitabı favorilere ekleyelim
        mockCoreDataManager.addFavorite(with: book)
        XCTAssertTrue(mockCoreDataManager.isBookFavorite(bookId: bookId), "Kitap favorilere eklenmedi!")

        // When: Favorilerden kaldırılıyor
        mockCoreDataManager.removeFavorite(bookId: bookId)

        // Then: Favorilerde olmamalı
        XCTAssertFalse(mockCoreDataManager.isBookFavorite(bookId: bookId), "Kitap favorilerden silinmedi!")
    }


    func testToggleFavorite() {
        let bookId = book.id ?? ""

        // Başlangıçta kitap favorilere eklenmemiş olmalı
        XCTAssertFalse(mockCoreDataManager.isBookFavorite(bookId: bookId), "Başlangıçta kitap favori olmamalı!")

        // When: Kitap favorilere ekleniyor
        mockCoreDataManager.toggleFavorite(book: book)

        // Then: toggleFavorite çağrılmış olmalı
        XCTAssertTrue(mockCoreDataManager.toggleFavoriteCalled, "toggleFavorite metodu çağrılmadı!")

        // Kitap favorilere eklenmiş olmalı
        XCTAssertTrue(mockCoreDataManager.isBookFavorite(bookId: bookId), "Kitap favorilere eklenmedi!")

        // When: Kitap favorilerden çıkarılıyor
        mockCoreDataManager.toggleFavorite(book: book)

        // Then: Kitap favorilerden çıkarılmış olmalı
        XCTAssertFalse(mockCoreDataManager.isBookFavorite(bookId: bookId), "Kitap favorilerden çıkarılmadı!")
    }

}
