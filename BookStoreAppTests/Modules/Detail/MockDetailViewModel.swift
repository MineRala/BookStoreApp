//
//  MockDetailViewModel.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 6.02.2025.
//

import Foundation
@testable import BookStoreApp

final class MockDetailViewModel: DetailViewModelInterface {
    var favoriteButtonTappedCalled = false
    var viewDidLoadCalled = false
    var viewWillAppearCalled = false

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
