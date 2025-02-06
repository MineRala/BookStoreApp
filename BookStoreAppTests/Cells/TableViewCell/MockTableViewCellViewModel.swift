//
//  MockTableViewCellViewModel.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 6.02.2025.
//

@testable import BookStoreApp
import UIKit

final class MockTableViewCellViewModel: TableViewCellViewModelInterface {
    var viewDidLoadCalled = false

    func viewDidLoad() {
        viewDidLoadCalled = true
    }
}
