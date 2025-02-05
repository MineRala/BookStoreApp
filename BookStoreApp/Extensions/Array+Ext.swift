//
//  Array+Ext.swift
//  BookStoreApp
//
//  Created by Mine Rala on 4.02.2025.
//

import Foundation

extension Array where Element == BookModel {
    func sortByDateAscending() -> [BookModel] {
        return self.sorted { $0.date ?? "" < $1.date ?? "" }
    }

    func sortByDateDescending() -> [BookModel] {
        return self.sorted { $0.date ?? "" > $1.date ?? "" }
    }
}
