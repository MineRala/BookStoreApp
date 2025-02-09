//
//  MockHomeViewModel.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 8.02.2025.
//

import Foundation
@testable import BookStoreApp

final class MockHomeViewModel: HomeViewModelInterface {
    // MARK: - Test Flags
    var viewDidLoadCalled = false
    var sortBooksCalled = false
    var getBookCalled = false
    var createActionCalled = false
    var isSortTypeSelectedCalled = false
    var willDisplayCalled = false
    var collectionViewReloadDataCalled = false
    var isUpdateEmptyLabelVisibilityCalled = false

    // MARK: Properties
    var selectedSort: SortType = .allBook
    var bookData = [BookModel]()
    var currentPage = 1
    var itemsPerPage = 20

    var optionList: [(String, SortType)] = [
        ("All Books", .allBook),
        ("New to Old", .newToOld),
        ("Old to New", .oldToNew),
        ("Favorites", .favoritesBook)
    ]

    var mockBooks: [BookModel] = [
        BookModel(artistName: "Dr. Ricken Lazlo Hale, PhD", id: "1", name: "The You You Are", date: "2025-01-31"),
        BookModel(artistName: "Anonymous", id: "2", name: "Severance", date: "2022-03-18")
    ]

    var numberOfItemsInSection: Int {
        return bookData.count
    }

    // MARK: - HomeViewModelInterface
    func viewDidLoad() {
        viewDidLoadCalled = true
        self.bookData = mockBooks
    }

    func sortBooks() {
        sortBooksCalled = true
        switch selectedSort {
        case .allBook:
            bookData = mockBooks
        case .favoritesBook:
            bookData = mockBooks.filter { $0.isFavorite }
        case .newToOld:
            bookData = mockBooks.sortByDateDescending()
        case .oldToNew:
            bookData = mockBooks.sortByDateAscending()
        }
        updateEmptyLabelVisibility()
        collectionViewReloadDataCalled = true
    }

    func updateEmptyLabelVisibility() {
        isUpdateEmptyLabelVisibilityCalled = true
    }

    func getBook(index: Int) -> BookModel {
        getBookCalled = true
        return bookData[index]
    }

    func createAction(sortType: SortType) {
        createActionCalled = true
        selectedSort = sortType
        sortBooks()
    }

    func isSortTypeSelected(_ sortType: SortType) -> Bool {
        isSortTypeSelectedCalled = true
        return selectedSort == sortType
    }

    func willDisplay(index: Int) {
        willDisplayCalled = true
        if index == bookData.count - 1 {
            currentPage += 1
        }
    }

    func calculateItemSize(for collectionViewWidth: CGFloat, spacing: CGFloat) -> CGSize {
        let totalSpacing = spacing * 2
        let width = (collectionViewWidth - totalSpacing) / 2
        return CGSize(width: width, height: width * 1.5)
    }
}

