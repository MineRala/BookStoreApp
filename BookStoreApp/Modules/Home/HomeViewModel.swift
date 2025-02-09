//
//  HomeViewModel.swift
//  BookStoreApp
//
//  Created by Mine Rala on 8.02.2025.
//

import Foundation

protocol HomeViewModelInterface {
    var numberOfItemsInSection: Int { get }
    var optionList: [(String, SortType)] { get }

    func viewDidLoad()
    func sortBooks()
    func getBook(index: Int) -> BookModel
    func createAction(sortType: SortType)
    func isSortTypeSelected(_ sortType: SortType) -> Bool
    func willDisplay(index: Int)
    func calculateItemSize(for collectionViewWidth: CGFloat, spacing: CGFloat) -> CGSize
}

final class HomeViewModel {
    // MARK: Properties
    private weak var view: HomeViewControllerInterface?
    private var selectedSort: SortType = .allBook
    private var isLoading = false
    private var bookData = [BookModel]()
    private var bookDataDefault = [BookModel]()
    private var currentPage = 1
    private let itemsPerPage = 20
    private let networkManager: NetworkManagerProtocol

    init(view: HomeViewControllerInterface, networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.view = view
        self.networkManager = networkManager
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func loadBooks() {
        guard !isLoading else { return }
        isLoading = true

        #warning("Pagination olduğundan sorting sadece aynı page'deki itemlar arasında oluyor.")
        networkManager.loadListOfBooks(currentPage: currentPage, itemsPerPage: itemsPerPage) { [weak self] books in
            guard let self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                if self.currentPage == 1 {
                    self.bookDataDefault = books
                }
                switch self.selectedSort {
                case .newToOld:
                    self.bookData.append(contentsOf: books.sortByDateDescending())
                case .oldToNew:
                    self.bookData.append(contentsOf: books.sortByDateAscending())
                default:
                    self.bookData.append(contentsOf: books)
                }
                self.view?.isActivityIndicatorActive(isActive: false)
                self.view?.collectionViewReloadData()
            }
        }
    }

    private func updateEmptyLabelVisibility() {
        let isFavoritesSelected = selectedSort == .favoritesBook
        let isEmpty = bookData.isEmpty
        view?.setEmptyLabelVisibility(isVisible: isFavoritesSelected && isEmpty)
    }

    @objc func refreshFavorites() {
        if selectedSort == .favoritesBook {
            let favoriBook = CoreDataManager.shared.getFavorites()
            let bookModels = favoriBook.map { BookModel.from(favoriteBook: $0) }
            self.bookData = bookModels
        }
        updateEmptyLabelVisibility()
        view?.collectionViewReloadData()
    }
}

// MARK: - HomeViewModelInterface
extension HomeViewModel: HomeViewModelInterface {
    var optionList: [(String, SortType)] {
        [
            (Strings.allBook, .allBook),
            (Strings.newToOld, .newToOld),
            (Strings.oldToNew, .oldToNew),
            (Strings.onlyFavorites, .favoritesBook)
        ]
    }

    var numberOfItemsInSection: Int {
        bookData.count
    }

    func viewDidLoad() {
        view?.configureNavigationBar()
        view?.configureCollectionView()
        view?.configureActivityIndicator()
        loadBooks()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshFavorites), name: NSNotification.Name(Constants.favoritesUpdatedNotification), object: nil)
    }

    func sortBooks() {
        currentPage = 1
        switch selectedSort {
        case .allBook:
            bookData = bookDataDefault
        case .favoritesBook:
            let favoriBook = CoreDataManager.shared.getFavorites()
            let bookModels = favoriBook.map { BookModel.from(favoriteBook: $0) }
            bookData = bookModels
        case .newToOld:
            bookData = bookDataDefault.sortByDateDescending()
        case .oldToNew:
            bookData = bookDataDefault.sortByDateAscending()
        }
        updateEmptyLabelVisibility()
        view?.collectionViewReloadData()
    }

    func getBook(index: Int) -> BookModel {
        bookData[index]
    }

    func createAction(sortType: SortType) {
        self.selectedSort = sortType
        self.sortBooks()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self else { return }
            if !self.bookData.isEmpty {
                let indexPath = IndexPath(item: 0, section: 0)
                self.view?.collectionViewScroll(index: indexPath)
            }
        }
    }

    func isSortTypeSelected(_ sortType: SortType) -> Bool {
        selectedSort == sortType
    }

    func willDisplay(index: Int) {
        if selectedSort == .favoritesBook { return }
        if index == bookData.count - 1 && !isLoading {
            currentPage += 1
            loadBooks()
        }
    }

    func calculateItemSize(for collectionViewWidth: CGFloat, spacing: CGFloat) -> CGSize {
        let totalSpacing = spacing * 2
        let width = (collectionViewWidth - totalSpacing) / 2
        return CGSize(width: width, height: width * 1.5)
    }
}
