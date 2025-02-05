//
//  SearchViewController.swift
//  BookStoreApp
//
//  Created by Mine Rala on 4.02.2025.
//

import UIKit

final class SearchViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var emptyLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // MARK: Properties
    private var books = [BookModel]()
    private var filteredBooks = [BookModel]()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadData()
    }
}

// MARK: - UI
extension SearchViewController {
    private func configureUI() {
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: Constants.tableViewCell, bundle: nil), forCellReuseIdentifier: Constants.tableViewCell)
        activityIndicator.setActiveState(isActive: true)
        tableView.isHidden = true
        activityIndicator.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        navigationItem.backButtonTitle = Constants.emptyString
        searchBar.placeholder = Strings.searchPlaceholder
    }

    private func updateEmptyLabelVisibility() {
        if books.isEmpty || filteredBooks.isEmpty {
            emptyLabel.isHidden = false
            tableView.isHidden = true
        } else {
            emptyLabel.isHidden = true
            tableView.isHidden = false
        }
    }
}

// MARK: - Logic
extension SearchViewController {
    private func loadData() {
        #warning("Pdf de search ekranında paginationdan bahsetmediği için eklemedim.")
        NetworkManager.shared.makeRequest(endpoint: .bookModel, type: ResultModel.self) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.activityIndicator.setActiveState(isActive: false)
                self.tableView.isHidden = false
                switch result {
                case .success(let resultModel):
                    self.books = resultModel.feed.results
                    self.filteredBooks = self.books
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

// MARK: - SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredBooks = books
        } else {
            filteredBooks = books.filter { book in
                if let bookName = book.name?.lowercased(),
                   let authorName = book.artistName?.lowercased() {
                    return bookName.contains(searchText.lowercased()) || authorName.contains(searchText.lowercased())
                }
                return false
            }
        }
        updateEmptyLabelVisibility()
        tableView.reloadData()
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
           searchBar.showsCancelButton = true
           return true
       }

       func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
           searchBar.text = Constants.emptyString
           searchBar.resignFirstResponder()
           searchBar.showsCancelButton = false
           filteredBooks = books
           updateEmptyLabelVisibility()
           tableView.reloadData()
       }
}

// MARK: - TableView DataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBooks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableViewCell, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.configureCell(with: filteredBooks[indexPath.row])
        return cell
    }
}

// MARK: - TableView Delegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: Constants.main, bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: Constants.detailViewController) as? DetailViewController {
            detailVC.selectedBook = filteredBooks[indexPath.row]
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
            print("DetailViewController not instantiate!")
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}
