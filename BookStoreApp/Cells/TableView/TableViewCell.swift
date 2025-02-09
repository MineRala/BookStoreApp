//
//  TableViewCell.swift
//  BookStoreApp
//
//  Created by Mine Rala on 4.02.2025.
//

import UIKit

protocol TableViewCellInterface: AnyObject {
    func updateUI(with book: BookModel, cacheManager: CacheManagerInterface)
}

final class TableViewCell: UITableViewCell {
    // MARK: Outlets
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    private var viewModel: TableViewCellViewModelInterface?
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.image = nil
    }
}

// MARK: - UI
extension TableViewCell: TableViewCellInterface {
    func configureCell(with viewModel: TableViewCellViewModelInterface) {
          self.viewModel = viewModel
          viewModel.viewDidLoad()
      }

    func updateUI(with book: BookModel, cacheManager: CacheManagerInterface = CacheManager.shared) {
        titleLabel.text = book.name
        authorLabel.text = book.artistName
        dateLabel.text = book.date?.convertToMonthDayYearFormat()
        posterImageView.setImage(from: book.imageUrl, cacheManager: cacheManager)
    }
}
