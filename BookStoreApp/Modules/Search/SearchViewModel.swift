//
//  SearchViewModel.swift
//  BookStoreApp
//
//  Created by Mine Rala on 7.02.2025.
//

import Foundation

protocol SearchViewModelInterface {
    var numberOfRowsInSection: Int { get }
    var heightForRowAt: Double { get }

    func viewDidLoad()
    func updateEmptyLabelVisibility()
    func searchBarTexrDidChange(with text: String)
    func setFilteredBooksWithBooks()
    func getBook(index: Int) -> BookModel
}

final class SearchViewModel {
    // MARK: Properties
    private weak var view: SearchViewControllerInterface?
    var books = [BookModel]()
    var filteredBooks = [BookModel]()
    private let networkManager: NetworkManagerProtocol

    init(view: SearchViewControllerInterface, networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.view = view
        self.networkManager = networkManager
    }

    private func loadData() {
        #warning("Pdf de search ekranında paginationdan bahsetmediği için eklemedim.")
        networkManager.makeRequest(endpoint: .bookModel, type: ResultModel.self) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.view?.activityIndicatorHidden()
                switch result {
                case .success(let resultModel):
                    self.books = resultModel.feed.results
                    self.filteredBooks = self.books
                    self.view?.tableViewReload()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

// MARK: - SearchViewModelInterface
extension SearchViewModel: SearchViewModelInterface {
    var numberOfRowsInSection: Int {
        filteredBooks.count
    }

    var heightForRowAt: Double {
        140
    }

    func viewDidLoad() {
        view?.configureUI()
        loadData()
    }
    
    func updateEmptyLabelVisibility() {
        if books.isEmpty || filteredBooks.isEmpty {
            view?.setEmptyLabelVisibility(isVisible: true)
        } else {
            view?.setEmptyLabelVisibility(isVisible: false)
        }
    }

    func searchBarTexrDidChange(with text: String) {
        if text.isEmpty {
            filteredBooks = books
        } else {
            filteredBooks = books.filter { book in
                if let bookName = book.name?.lowercased(),
                   let authorName = book.artistName?.lowercased() {
                    return bookName.contains(text.lowercased()) || authorName.contains(text.lowercased())
                }
                return false
            }
        }
        updateEmptyLabelVisibility()
        view?.tableViewReload()
    }

    func setFilteredBooksWithBooks() {
        filteredBooks = books
    }

    func getBook(index: Int) -> BookModel {
        filteredBooks[index]
    }
}
