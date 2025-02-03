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
//    let imageCache = NSCache<NSString, UIImage>()
    var isFavorite: Bool = false // Favori durumu (Başlangıçta false)

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    @IBAction func favoriteButtonTapped(_ sender: Any) {
        isFavorite.toggle() // Durumu tersine çevir (Favoriye al/çıkar)

              // Butonun görselini güncelle
              updateFavoriteButton()
    }
    func updateFavoriteButton() {
            if isFavorite {
                // Eğer favori ise, buton dolu şekilde görünsün
                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                // Eğer favori değilse, buton boş şekilde görünsün
                favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
    func configureCell(with model: BookModel) {
            // Kitap ismini ayarla
            label.text = model.name

            // Resim URL'sini alıp yükle
            if let imageUrl = model.imageUrl {
                CacheManager.shared.loadImage(from: imageUrl) { [weak self] image in
                    guard let self else { return }
                    self.imageView.image = image
                }
            }
        }
}
