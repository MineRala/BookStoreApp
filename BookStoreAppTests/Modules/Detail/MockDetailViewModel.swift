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

    func viewDidLoad() { }
    func viewWillAppear() { }
    func favoriteButtonTapped() {
        favoriteButtonTappedCalled = true
    }
}
