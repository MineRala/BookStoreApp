//
//  TableViewCell.swift
//  BookStoreApp
//
//  Created by Mine Rala on 4.02.2025.
//

import UIKit

final class TableViewCell: UITableViewCell {
    // MARK: Outlets
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.image = nil
    }
}

// MARK: - UI
extension TableViewCell {
    func configureCell(with model: BookModel) {
        dateLabel.text = model.date?.convertToMonthDayYearFormat()
        titleLabel.text = model.name
        authorLabel.text = model.artistName
        posterImageView.setImage(from: model.imageUrl)
    }
}
