//
//  Enpoint.swift
//  BookStoreApp
//
//  Created by Mine Rala on 3.02.2025.
//

import Foundation


enum Endpoint {
    enum Constant {
        static let baseURL = "https://rss.applemarketingtools.com/api/v2/us/books/top-free/100/books.json"
    }

    case bookModel

    var url: URL? {
        switch self {
        case .bookModel:
            return URL(string: Constant.baseURL)

        }
    }
}

