//
//  UIImageView+Ext.swift
//  BookStoreApp
//
//  Created by Mine Rala on 4.02.2025.
//

import UIKit

extension UIImageView {
    func setImage(from url: String?, cacheManager: CacheManaging = CacheManager.shared) {
        guard let url else { return }
        cacheManager.loadImage(from: url) { [weak self] image in
            self?.image = image
        }
    }
}
