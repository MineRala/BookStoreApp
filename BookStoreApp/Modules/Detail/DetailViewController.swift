//
//  DetailViewController.swift
//  BookStoreApp
//
//  Created by Mine Rala on 4.02.2025.
//
import UIKit

protocol DetailViewControllerInterface: AnyObject {
    func rightBarButtonItem()
    func updateUI(with book: BookModel, cacheManager: CacheManagerInterface)
    func updateFavoriteButtonIcon(isFavorite: Bool)
}

final class DetailViewController: UIViewController, DetailViewControllerInterface {
    // MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    // MARK: Attributes
    private lazy var favoriteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: Icons.starFill),
            style: .plain,
            target: self,
            action: #selector(favoriteButtonTapped)
        )
        return button
    }()

    // MARK: Properties
    var viewModel: DetailViewModelInterface?
    var book: BookModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let book else { return }

        // Unit testte viewDidLoadda tekrardan MockDetailViewModel() ' e setlesin diye bu kontrolü yapmam gerekti.
        if self.viewModel == nil {
            self.viewModel =  AppEnvironment.isTesting ? MockDetailViewModel() : DetailViewModel(book: book, view: self)
        }

        guard let viewModel else { return }
        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let viewModel else { return }
        viewModel.viewWillAppear()
    }
}

// MARK: - UI
extension DetailViewController {
    func rightBarButtonItem() {
        navigationItem.rightBarButtonItem = favoriteButton
    }

    func updateUI(with book: BookModel, cacheManager: CacheManagerInterface = CacheManager.shared) {
        titleLabel.text = book.name
        authorLabel.text = book.artistName
        dateLabel.text = book.date
        imageView.setImage(from: book.imageUrl, cacheManager: cacheManager)
    }

    func updateFavoriteButtonIcon(isFavorite: Bool) {
        favoriteButton.tintColor = isFavorite ? .yellow : .darkGray
    }
}

// MARK: - Actions
extension DetailViewController {
    @objc func favoriteButtonTapped() {
        guard let viewModel else { return }
        viewModel.favoriteButtonTapped()
//        DispatchQueue.main.async {
//
//        }
    }
}
