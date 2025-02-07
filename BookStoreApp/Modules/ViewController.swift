//
//  ViewController.swift
//  BookStoreApp
//
//  Created by Mine Rala on 3.02.2025.
//

import UIKit

final class ViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var emptyLabel: UILabel!

    // MARK: Properties
    private var selectedSort: SortType = .allBook
    private var isLoading = false
    private var bookData = [BookModel]()
    private var bookDataDefault = [BookModel]()
    private var currentPage = 1
    private let itemsPerPage = 20

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCollectionView()
        configureActivityIndicator()
        loadBooks()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshFavorites), name: NSNotification.Name(Constants.favoritesUpdatedNotification), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UI
extension ViewController {
    private func configureActivityIndicator() {
        self.activityIndicator.setActiveState(isActive: true)
        self.activityIndicator.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
    }

    private func configureNavigationBar() {
        navigationItem.backButtonTitle = Constants.emptyString
        navigationController?.navigationBar.tintColor = .gray
    }

    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        collectionView.register(UINib(nibName: Constants.collectionViewCell, bundle: nil), forCellWithReuseIdentifier: Constants.collectionViewCell)
        collectionView.collectionViewLayout = layout
    }

    private func updateViewVisibility() {
        let isFavoritesSelected = selectedSort == .favoritesBook
        let isEmpty = bookData.isEmpty
        emptyLabel.isHidden = !(isEmpty && isFavoritesSelected)
        collectionView.isHidden = isEmpty && isFavoritesSelected ? true : false
    }
}

// MARK: - Logic
extension ViewController {
    private func loadBooks() {
        guard !isLoading else { return }
        isLoading = true

        NetworkManager.shared.loadListOfBooks(currentPage: currentPage, itemsPerPage: itemsPerPage) { [weak self] books in
            guard let self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                self.activityIndicator.setActiveState(isActive: false)
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
                self.collectionView.reloadData()
            }
        }
    }

    private func sortBooks() {
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
        updateViewVisibility()
        collectionView.reloadData()
    }
}

// MARK: - Navigation Preparation
extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.showDetailIdentifier {
            if let detailVC = segue.destination as? DetailViewController,
               let indexPath = collectionView.indexPathsForSelectedItems?.first {
                detailVC.book = bookData[indexPath.row]
            }
        }
    }
}

// MARK: - Actions
extension ViewController {
    @objc private func refreshFavorites() {
        if selectedSort == .favoritesBook {
            let favoriBook = CoreDataManager.shared.getFavorites()
            let bookModels = favoriBook.map { BookModel.from(favoriteBook: $0) }
            self.bookData = bookModels
        }
        updateViewVisibility()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    @IBAction private func sortButtonAction(_ sender: Any) {
        let actionSheet = UIAlertController(title: Strings.sortingOptions, message: Strings.selectOption, preferredStyle: .actionSheet)

        let options: [(title: String, sortType: SortType)] = [
            (Strings.allBook, .allBook),
            (Strings.newToOld, .newToOld),
            (Strings.oldToNew, .oldToNew),
            (Strings.onlyFavorites, .favoritesBook)
        ]

        for option in options {
            actionSheet.addAction(createAction(title: option.title, sortType: option.sortType))
        }

        actionSheet.addAction(UIAlertAction(title: Strings.cancel, style: .cancel, handler: nil))

        present(actionSheet, animated: true, completion: nil)
    }

    private func createAction(title: String, sortType: SortType) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: .default) { [weak self] _ in
            guard let self else { return }
            self.selectedSort = sortType
            self.sortBooks()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if !self.bookData.isEmpty {
                    let indexPath = IndexPath(item: 0, section: 0)
                    self.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
                }
            }
        }
        if selectedSort == sortType {
            action.setValue(UIColor.red, forKey: Constants.titleTextColor)
        }
        return action
    }

    @IBAction private func searchButtonAction(_ sender: Any) {
        performSegue(withIdentifier: Constants.searchBookIdentifier, sender: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionViewCell, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(with: CollectionViewCellViewModel(book: bookData[indexPath.item], view: cell))
        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10
        let totalSpacing = spacing * 2
        let width = (collectionView.frame.width - totalSpacing) / 2
        return CGSize(width: width, height: width * 1.5)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        let storyboard = UIStoryboard(name: Constants.main, bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: Constants.detailViewController) as? DetailViewController {
            detailVC.book = bookData[indexPath.item]
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
            print("DetailViewController not instantiate!")
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if selectedSort == .favoritesBook { return }
        if indexPath.row == bookData.count - 1 && !isLoading {
            currentPage += 1
            loadBooks()
        }
    }
}
