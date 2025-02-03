//
//  UIActivityIndicatorView+Ext.swift
//  BookStoreApp
//
//  Created by Mine Rala on 3.02.2025.
//

import UIKit

extension UIActivityIndicatorView {
    func setActiveState(isActive: Bool) {
        if isActive {
            self.isHidden = false
            self.startAnimating()
        } else {
            self.stopAnimating()
            self.isHidden = true
        }
    }
}
