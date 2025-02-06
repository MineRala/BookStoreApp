//
//  CollectionViewCellModel.swift
//  BookStoreApp
//
//  Created by Mine Rala on 5.02.2025.
//

import Foundation

protocol CollectionViewCellViewModelInterface {
    func favoriteButtonTapped()
    func viewDidLoad()
}

final class CollectionViewCellViewModel {
    private weak var view: CollectionViewCellInterface?
    
    private var book: BookModel
    private var coreDataManager: CoreDataManager

    init(book: BookModel, coreDataManager: CoreDataManager = CoreDataManager.shared, view: CollectionViewCellInterface) {
        self.book = book
        self.coreDataManager = coreDataManager
        self.view = view
    }
}

// MARK: - CollectionViewCellViewModelInterface
extension CollectionViewCellViewModel: CollectionViewCellViewModelInterface {
    func favoriteButtonTapped() {
        coreDataManager.toggleFavorite(book: book)
        NotificationCenter.default.post(name: NSNotification.Name(Constants.favoritesUpdatedNotification), object: nil)
    }

    func viewDidLoad() {
        view?.updateUI(with: book)
    }
}
