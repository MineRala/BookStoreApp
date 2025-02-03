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

    @IBOutlet weak var descLabel: UILabel!

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIBarButtonItem!

    var selectedBook: BookModel? // Ana sayfadan gelen veri


    override func viewDidLoad() {
        super.viewDidLoad()

        if let book = selectedBook {
            titleLabel.text = book.name
            descLabel.text = book.artistName
            dateLabel.text = book.date?.convertToMonthDayYearFormat()
            if let imageUrl = book.imageUrl {
                CacheManager.shared.loadImage(from: imageUrl) { [weak self] image in
                    guard let self else { return }
                    self.imageView.image = image
                }
            }
                }
    }

    @IBAction func favoriteButtonTapped(_ sender: Any) {
    }
    
}
