//
//  MockCollectionViewCell.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 6.02.2025.
//

@testable import BookStoreApp
import UIKit

class MockCollectionViewCell: CollectionViewCellInterface {
    var updateUICalled = false
    var bookPassed: BookModel?

    func updateUI(with book: BookModel) {
        updateUICalled = true
        bookPassed = book
    }
}
