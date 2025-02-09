//
//  MockDeatilViewController.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 6.02.2025.
//

import Foundation
@testable import BookStoreApp

final class MockDetailViewController: DetailViewControllerInterface {
    // MARK: - Test Flags
    var updateUICalled = false
    var updateFavoriteButtonIconCalled = false
    var rightBarButtonItemCalled = false
    var lastFavoriteState: Bool?

    // MARK: - Methods
    func updateUI(with book: BookModel, cacheManager: any BookStoreApp.CacheManagerInterface) {
        updateUICalled = true
    }

    func updateFavoriteButtonIcon(isFavorite: Bool) {
        updateFavoriteButtonIconCalled = true
        lastFavoriteState = isFavorite
    }

    func rightBarButtonItem() {
        rightBarButtonItemCalled = true
    }
}
