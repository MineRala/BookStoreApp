//
//  MockTableViewCell.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 6.02.2025.
//

@testable import BookStoreApp
import UIKit

final class MockTableViewCell: TableViewCellInterface {
    var isUpdateUICalled = false
    var updatedBook: BookModel?

    func updateUI(with book: BookStoreApp.BookModel, cacheManager: any BookStoreApp.CacheManagerInterface) {
        isUpdateUICalled = true
        updatedBook = book
    }
}
