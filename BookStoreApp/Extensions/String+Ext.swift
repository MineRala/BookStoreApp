//
//  String+Ext.swift
//  BookStoreApp
//
//  Created by Mine Rala on 4.02.2025.
//

import Foundation

extension String {
    func convertToMonthDayYearFormat() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: self) else { return nil}
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
}
