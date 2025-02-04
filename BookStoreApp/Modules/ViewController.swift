//
//  ViewController.swift
//  BookStoreApp
//
//  Created by Mine Rala on 3.02.2025.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    private var selectedSort: SortType = .allBook

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    var bookData: [BookModel]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.activityIndicator.setActiveState(isActive: false)
            }
        }
    }

    @objc private func refreshFavorites() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCollectionView()
        self.activityIndicator.setActiveState(isActive: true)
        activityIndicator.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)

        NotificationCenter.default.addObserver(self, selector: #selector(refreshFavorites), name: NSNotification.Name("FavoritesUpdated"), object: nil)


        NetworkManager.shared.makeRequest(endpoint: .bookModel, type: ResultModel.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let resultModel):
                self.bookData = resultModel.feed.results
            case .failure(let error):
                print(error)
                self.activityIndicator.setActiveState(isActive: false)
            }
        }
    }

    private func configureNavigationBar() {
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .gray
    }

    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        collectionView.collectionViewLayout = layout
    }

    // Filtreleme türlerine göre kitapları filtrele
    private func sortBooks() {
        switch selectedSort {
        case .allBook:
            print("")
            //               sortBooks = books // Tüm kitapları göster
        case .favoritesBook:
            print("")
            //               sortBooks = books.filter { $0.isFavorite } // Sadece favori kitapları göster
        case .newToOld:
            print("")
        case .oldToNew:
            print("")
        }

        //        collectionView.reloadData()
    }
    private func createAction(title: String, sortType: SortType) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: .default) { [weak self] _ in
            guard let self else { return }
            self.selectedSort = sortType
            self.sortBooks()
            print("\(title) seçildi")
        }
        if selectedSort == sortType {
            action.setValue(UIColor.red, forKey: "titleTextColor")
        }
        return action
    }


    @IBAction func sortButtonAction(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Sıralama Seçenekleri", message: "Sıralamak istediğiniz seçeneği seçin", preferredStyle: .actionSheet)

        let options: [(title: String, sortType: SortType)] = [
            ("📚 Tümü", .allBook),
            ("📅 Yeniden Eskiye", .newToOld),
            ("⏳ Eskiden Yeniye", .oldToNew),
            ("⭐ Sadece Beğenilenler", .favoritesBook)
        ]

        for option in options {
            actionSheet.addAction(createAction(title: option.title, sortType: option.sortType))
        }

        actionSheet.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))

        present(actionSheet, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let detailVC = segue.destination as? DetailViewController,
               let indexPath = collectionView.indexPathsForSelectedItems?.first, let book =  bookData?[indexPath.row] {
                detailVC.selectedBook = book
            }
        }
    }

    @IBAction func searchButtonAction(_ sender: Any) {

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookData?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let book = bookData?[indexPath.item] {

            cell.configureCell(with: book)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10
        let totalSpacing = spacing * 2
        let width = (collectionView.frame.width - totalSpacing) / 2

        return CGSize(width: width, height: width * 1.5)
    }
}

