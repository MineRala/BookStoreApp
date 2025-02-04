//
//  UIImageView+Ext.swift
//  BookStoreApp
//
//  Created by Mine Rala on 4.02.2025.
//

import UIKit

extension UIImageView {
    func setImage(from url: String?) {
        guard let url else { return }
        CacheManager.shared.loadImage(from: url) { [weak self] image in
            self?.image = image
        }
    }
}
