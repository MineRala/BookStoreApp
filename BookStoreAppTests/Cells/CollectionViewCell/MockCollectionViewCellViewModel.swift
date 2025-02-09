//
//  MockCollectionViewCellViewModel.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 6.02.2025.
//

import Foundation
@testable import BookStoreApp

final class MockCollectionViewCellViewModel: CollectionViewCellViewModelInterface {
    // MARK: - Test Flags
    var favoriteButtonTappedCalled = false
    var viewDidLoadCalled = false
    var mockCoreDataManager: MockCoreDataManager
    var book: BookModel

    init(book: BookModel, coreDataManager: MockCoreDataManager) {
        self.book = book
        self.mockCoreDataManager = coreDataManager
    }

    // MARK: - Methods
    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func favoriteButtonTapped() {
        favoriteButtonTappedCalled = true
        mockCoreDataManager.toggleFavorite(book: book)
    }
}
