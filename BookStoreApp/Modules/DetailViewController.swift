//
//  DetailViewController.swift
//  BookStoreApp
//
//  Created by Mine Rala on 4.02.2025.
//
import UIKit

final class DetailViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet private  weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

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
    var selectedBook: BookModel?

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = favoriteButton
        configure()
    }
}

// MARK: - UI
extension DetailViewController {
    private func configure() {
        guard let selectedBook else { return }
        titleLabel.text = selectedBook.name
        authorLabel.text = selectedBook.artistName
        dateLabel.text = selectedBook.date?.convertToMonthDayYearFormat()
        imageView.setImage(from: selectedBook.imageUrl)
        updateFavoriteButtonIcon()
    }

    private func updateFavoriteButtonIcon() {
        guard let book = selectedBook else { return }
        favoriteButton.tintColor = book.isFavorite ? .yellow : .darkGray
    }
}

// MARK: - Actions
extension DetailViewController {
    @objc private func favoriteButtonTapped() {
        guard let book = selectedBook else { return }
        CoreDataManager.shared.toggleFavorite(book: book)
        updateFavoriteButtonIcon()
        NotificationCenter.default.post(name: NSNotification.Name(Constants.favoritesUpdatedNotification), object: nil)
    }
}
