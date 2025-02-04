//
//  DetailViewController.swift
//  BookStoreApp
//
//  Created by Mine Rala on 4.02.2025.
//
import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    private lazy var favoriteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "star"),
            style: .plain,
            target: self,
            action: #selector(favoriteButtonTapped)
        )
        return button
    }()

    var selectedBook: BookModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = favoriteButton
        configure()
    }

    private func configure() {
        guard let selectedBook else { return }
        titleLabel.text = selectedBook.name
        authorLabel.text = selectedBook.artistName
        dateLabel.text = selectedBook.date?.convertToMonthDayYearFormat()
        imageView.setImage(from: selectedBook.imageUrl)
        updateFavoriteButtonIcon()
    }

    @objc private func favoriteButtonTapped() {
        guard let book = selectedBook, let bookId = book.id else { return }
        CoreDataManager.shared.toggleFavorite(book: book)
        updateFavoriteButtonIcon()
        NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdated"), object: nil)
    }

    private func updateFavoriteButtonIcon() {
        guard let book = selectedBook else { return }
        favoriteButton.image = UIImage(systemName: book.isFavorite ?  "star.fill" : "star")
        favoriteButton.tintColor = book.isFavorite ? .yellow : .darkGray
    }
}
