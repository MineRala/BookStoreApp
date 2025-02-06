//
//  CollectionViewCell.swift
//  BookStoreApp
//
//  Created by Mine Rala on 3.02.2025.
//

import UIKit

protocol CollectionViewCellInterface: AnyObject {
    func updateUI(with book: BookModel)

}

final class CollectionViewCell: UICollectionViewCell {
    // MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    // MARK: - Properties
    private var viewModel: CollectionViewCellViewModelInterface?

    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        updateFavoriteButtonIcon(isFavorite: false)
    }

    // MARK: Private
    private func updateFavoriteButtonIcon(isFavorite: Bool) {
        favoriteButton.setImage(
            UIImage(systemName:  Icons.starFill)?
                .withTintColor(isFavorite ? .yellow : .darkGray, renderingMode: .alwaysOriginal),
            for: .normal
        )
    }
}

// MARK: - UI
extension CollectionViewCell {
    func configureCell(with viewModel: CollectionViewCellViewModelInterface) {
        self.viewModel = viewModel
        viewModel.viewDidLoad()
    }
}

// MARK: - Actions
extension CollectionViewCell {
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        guard let viewModel else { return }
        viewModel.favoriteButtonTapped()
    }
}

// MARK: - CollectionViewCellInterface
extension CollectionViewCell: CollectionViewCellInterface {
    func updateUI(with book: BookModel) {
        label.text = book.name
        imageView.setImage(from: book.imageUrl)
        updateFavoriteButtonIcon(isFavorite: book.isFavorite)
    }
}
