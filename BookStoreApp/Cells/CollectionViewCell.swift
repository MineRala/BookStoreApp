//
//  CollectionViewCell.swift
//  BookStoreApp
//
//  Created by Mine Rala on 3.02.2025.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    var book: BookModel?

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

    @IBAction func favoriteButtonTapped(_ sender: Any) {
        guard let book = book else { return }
        CoreDataManager.shared.toggleFavorite(book: book)
        NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdated"), object: nil)
    }

    private func updateFavoriteButtonIcon(isFavorite: Bool) {
        favoriteButton.setImage(
            UIImage(systemName: isFavorite ? "star.fill" : "star")?
                .withTintColor(isFavorite ? .yellow : .darkGray, renderingMode: .alwaysOriginal),
            for: .normal
        )
    }

    func configureCell(with model: BookModel) {
        self.book = model
        label.text = model.name
        imageView.setImage(from: model.imageUrl)
        updateFavoriteButtonIcon(isFavorite: model.isFavorite)
    }
}
