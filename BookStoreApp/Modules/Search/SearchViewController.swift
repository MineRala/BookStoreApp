//
//  SearchViewController.swift
//  BookStoreApp
//
//  Created by Mine Rala on 4.02.2025.
//

import UIKit

protocol SearchViewControllerInterface: AnyObject {
    func configureUI()
    func setEmptyLabelVisibility(isVisible: Bool)
    func tableViewReload()
    func activityIndicatorHidden()
}

final class SearchViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: Properties
    lazy var viewModel: SearchViewModelInterface = SearchViewModel(view: self)

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
}

// MARK: - SearchViewControllerInterface
extension SearchViewController: SearchViewControllerInterface {
    func configureUI() {
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

    func setEmptyLabelVisibility(isVisible: Bool) {
        emptyLabel.isHidden = !isVisible
        tableView.isHidden = isVisible
    }

    func tableViewReload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func activityIndicatorHidden() {
        DispatchQueue.main.async {
            self.activityIndicator.setActiveState(isActive: false)
            self.tableView.isHidden = false
        }
    }
}

// MARK: - SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchBarTexrDidChange(with: searchText)
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
           searchBar.showsCancelButton = true
           return true
       }

       func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
           searchBar.text = Constants.emptyString
           searchBar.resignFirstResponder()
           searchBar.showsCancelButton = false
           viewModel.setFilteredBooksWithBooks()
           viewModel.updateEmptyLabelVisibility()
           tableViewReload()
       }
}

// MARK: - TableView DataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableViewCell, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.configureCell(with: TableViewCellViewModel(book: viewModel.getBook(index: indexPath.row), view: cell))
        return cell
    }
}

// MARK: - TableView Delegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: Constants.main, bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: Constants.detailViewController) as? DetailViewController {
            detailVC.book = viewModel.getBook(index: indexPath.row)
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
            print("DetailViewController not instantiate!")
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.heightForRowAt
    }
}
