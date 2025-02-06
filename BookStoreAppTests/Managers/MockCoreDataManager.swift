//
//  MockCoreDataManager.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 6.02.2025.
//
import Foundation
@testable import BookStoreApp

final class MockCoreDataManager: CoreDataManager {

    override init() {
        super.init()
    }

    var addFavoriteCalled = false
    var removeFavoriteCalled = false
    var toggleFavoriteCalled = false

    var favoriteBookPassed: BookModel?
    var bookIdPassed: String?

    // Mock methods
    override func addFavorite(with book: BookModel) {
        addFavoriteCalled = true
        favoriteBookPassed = book
    }

    override func removeFavorite(bookId: String) {
        removeFavoriteCalled = true
        bookIdPassed = bookId
    }

    override func toggleFavorite(book: BookModel) {
        toggleFavoriteCalled = true
        favoriteBookPassed = book
    }
}
