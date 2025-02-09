//
//  MockDetailViewModel.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 6.02.2025.
//

import Foundation
@testable import BookStoreApp

final class MockDetailViewModel: DetailViewModelInterface {
    // MARK: - Test Flags
    var favoriteButtonTappedCalled = false
    var viewDidLoadCalled = false
    var viewWillAppearCalled = false

    // MARK: - Methods
    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func viewWillAppear() {
        viewWillAppearCalled = true
    }

    func favoriteButtonTapped() {
        favoriteButtonTappedCalled = true
    }
}
