//
//  MockSearchViewModel.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 7.02.2025.
//
@testable import BookStoreApp
import Foundation

final class MockSearchViewModel: SearchViewModelInterface {
    // MARK: - Test Flags
    var isViewDidLoadCalled = false
    var isUpdateEmptyLabelVisibilityCalled = false
    var isSearchBarTextDidChangeCalled = false
    var isSetFilteredBooksWithBooksCalled = false

    // MARK: Properties
    var books: [BookModel] = []
    var filteredBooks: [BookModel] = []

    var numberOfRowsInSection: Int {
        filteredBooks.count
    }

    var heightForRowAt: Double {
        140
    }

    func viewDidLoad() {
        isViewDidLoadCalled = true

        let mockBook1 = BookModel(artistName: "Dr. Ricken Lazlo Hale, PhD", name: "The You You Are")
        let mockBook2 = BookModel(artistName: "Anonymous", name: "Severance")

        books = [mockBook1, mockBook2]

        filteredBooks = books
    }

    func updateEmptyLabelVisibility() {
        isUpdateEmptyLabelVisibilityCalled = true
    }

    func searchBarTextDidChange(with text: String) {
        isSearchBarTextDidChangeCalled = true

        if text.isEmpty {
            filteredBooks = books
        } else {
            filteredBooks = books.filter { book in
                let bookNameMatch = book.name?.lowercased().contains(text.lowercased()) ?? false
                let authorNameMatch = book.artistName?.lowercased().contains(text.lowercased()) ?? false
                return bookNameMatch || authorNameMatch
            }
        }
    }

    func setFilteredBooksWithBooks() {
        isSetFilteredBooksWithBooksCalled = true
        filteredBooks = books
    }

    func getBook(index: Int) -> BookModel {
        return filteredBooks[index]
    }
}
