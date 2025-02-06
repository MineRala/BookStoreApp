//
//  TableViewCellViewModel.swift
//  BookStoreApp
//
//  Created by Mine Rala on 5.02.2025.
//

import Foundation

protocol TableViewCellViewModelInterface {
    func viewDidLoad()
}

final class TableViewCellViewModel {
    private var book: BookModel
    private weak var view: TableViewCellInterface?

    init(book: BookModel, view: TableViewCellInterface) {
        self.book = book
        self.view = view

    }
}

extension TableViewCellViewModel: TableViewCellViewModelInterface {
    func viewDidLoad() {
        view?.updateUI(with: book, cacheManager: CacheManager.shared)
    }
}
