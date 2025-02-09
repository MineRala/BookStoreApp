//
//  MockCollectionViewCell.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 6.02.2025.
//

@testable import BookStoreApp
import UIKit

final class MockCollectionViewCell: CollectionViewCellInterface {
    // MARK: - Test Flags
    var updateUICalled = false
    var bookPassed: BookModel?

    // MARK: - Methods
    func updateUI(with book: BookModel) {
        updateUICalled = true
        bookPassed = book
    }
}
