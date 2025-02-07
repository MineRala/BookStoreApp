//
//  DetailViewModel.swift
//  BookStoreApp
//
//  Created by Mine Rala on 5.02.2025.
//

import Foundation

protocol DetailViewModelInterface {
    func viewDidLoad()
    func viewWillAppear()
    func favoriteButtonTapped()
}

final class DetailViewModel {
    private var book: BookModel
    private let coreDataManager: CoreDataManagerProtocol
    private var view: DetailViewControllerInterface?

    init(book: BookModel, coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared, view: DetailViewControllerInterface) {
        self.book = book
        self.coreDataManager = coreDataManager
        self.view = view
    }
}

// MARK: - DetailViewModelInterface
extension DetailViewModel: DetailViewModelInterface {
    func viewDidLoad() {
        view?.updateUI(with: book, cacheManager: CacheManager.shared)
        view?.updateFavoriteButtonIcon(isFavorite: book.isFavorite)
    }

    func viewWillAppear() {
        view?.rightBarButtonItem()
    }

    func favoriteButtonTapped() {
        coreDataManager.toggleFavorite(book: book)
        NotificationCenter.default.post(name: NSNotification.Name(Constants.favoritesUpdatedNotification), object: nil)
        view?.updateFavoriteButtonIcon(isFavorite: book.isFavorite)
    }
}
