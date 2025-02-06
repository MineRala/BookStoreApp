//
//  MockDeatilViewController.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 6.02.2025.
//

import Foundation
@testable import BookStoreApp

final class MockDetailViewController: DetailViewControllerInterface {
   
    var updateUICalled = false
    var updateFavoriteButtonIconCalled = false
    var rightBarButtonItemCalled = false

    func updateUI(with book: BookModel, cacheManager: any BookStoreApp.CacheManaging) {
        updateUICalled = true
    }

    func updateFavoriteButtonIcon(isFavorite: Bool) {
        updateFavoriteButtonIconCalled = true
    }

    func rightBarButtonItem() {
        rightBarButtonItemCalled = true
    }
}
