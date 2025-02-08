//
//  MockCoreDataManager.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 6.02.2025.
//
import Foundation
@testable import BookStoreApp

final class MockCoreDataManager: CoreDataManagerProtocol {
    var addFavoriteCalled = false
    var removeFavoriteCalled = false
    var toggleFavoriteCalled = false
    var isFavorite = false
    var favoriteBookPassed: BookModel?

    var favoriteBooks: [String: BookModel] = [:]

    func addFavorite(with book: BookModel) {
        addFavoriteCalled = true
        favoriteBookPassed = book
        favoriteBooks[book.id ?? ""] = book
    }

    func removeFavorite(bookId: String) {
        removeFavoriteCalled = true
        favoriteBooks.removeValue(forKey: bookId)
    }

    func toggleFavorite(book: BookModel) {
        toggleFavoriteCalled = true
        favoriteBookPassed = book

        if let bookId = book.id {
            if favoriteBooks[bookId] != nil {
                isFavorite = false
                removeFavorite(bookId: bookId)
            } else {
                isFavorite = true
                addFavorite(with: book)
            }
        }
    }

    func isBookFavorite(bookId: String) -> Bool {
        return favoriteBooks[bookId] != nil
    }
}
