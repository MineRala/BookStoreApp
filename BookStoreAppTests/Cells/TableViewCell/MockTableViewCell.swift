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

// ViewModel’in updateUI(with:BookModel) methodunun çağırılması kontrol edilir.
    func updateUI(with book: BookStoreApp.BookModel, cacheManager: any BookStoreApp.CacheManaging) {
        isUpdateUICalled = true
        updatedBook = book
    }
}
