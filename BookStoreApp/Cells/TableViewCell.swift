//
//  TableViewCell.swift
//  BookStoreApp
//
//  Created by Mine Rala on 4.02.2025.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.image = nil
    }

    func configureCell(with model: BookModel) {
        dateLabel.text = model.date?.convertToMonthDayYearFormat()
        titleLabel.text = model.name
        authorLabel.text = model.artistName
        posterImageView.setImage(from: model.imageUrl)
    }
}
