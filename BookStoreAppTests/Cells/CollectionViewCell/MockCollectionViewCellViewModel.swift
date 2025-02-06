//
//  MockCollectionViewCellViewModel.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 6.02.2025.
//

import Foundation
@testable import BookStoreApp

class MockCollectionViewCellViewModel: CollectionViewCellViewModelInterface {
    var favoriteButtonTappedCalled = false
    var viewDidLoadCalled = false

    func favoriteButtonTapped() {
        favoriteButtonTappedCalled = true
    }

    func viewDidLoad() {
        viewDidLoadCalled = true
    }
}

