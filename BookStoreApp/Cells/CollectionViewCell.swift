//
//  CollectionViewCell.swift
//  BookStoreApp
//
//  Created by Mine Rala on 3.02.2025.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    // MARK: Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!

    // MARK: Properties
    private var book: BookModel?

    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        book = nil
        updateFavoriteButtonIcon(isFavorite: false)
    }
}

// MARK: - UI
extension CollectionViewCell {
    func configureCell(with model: BookModel) {
        self.book = model
        label.text = model.name
        imageView.setImage(from: model.imageUrl)
        updateFavoriteButtonIcon(isFavorite: model.isFavorite)
    }

    private func updateFavoriteButtonIcon(isFavorite: Bool) {
        favoriteButton.setImage(
            UIImage(systemName:  Icons.starFill)?
                .withTintColor(isFavorite ? .yellow : .darkGray, renderingMode: .alwaysOriginal),
            for: .normal
        )
    }
}

// MARK: - Actions
extension CollectionViewCell {
    @IBAction private func favoriteButtonTapped(_ sender: Any) {
        guard let book else { return }
        CoreDataManager.shared.toggleFavorite(book: book)
        NotificationCenter.default.post(name: NSNotification.Name(Constants.favoritesUpdatedNotification), object: nil)
    }
}
