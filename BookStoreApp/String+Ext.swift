//
//  String+Ext.swift
//  BookStoreApp
//
//  Created by Mine Rala on 4.02.2025.
//

import Foundation

extension String {
    // Tarihi "yyyy-MM-dd" formatında `Date` tipine dönüştürme
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Modeldeki tarih formatı
        dateFormatter.locale = Locale(identifier: "tr_TR") // Türkçe dil desteği
        return dateFormatter.date(from: self)
    }

    func convertToMonthDayYearFormat() -> String? {
            // Adım 1: "yyyy-MM-dd" formatındaki string'i Date'e çevir
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"

            guard let date = dateFormatter.date(from: self) else {
                return nil // Dönüşüm başarısızsa nil döndür
            }

            // Adım 2: Date'i "MM-dd-yyyy" formatında string'e çevir
            dateFormatter.dateFormat = "MM-dd-yyyy"
            return dateFormatter.string(from: date)
        }
}
