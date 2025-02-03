//
//  BookModel.swift
//  BookStoreApp
//
//  Created by Mine Rala on 3.02.2025.
//

import Foundation

struct ResultModel: Codable {
    var feed: FeedModel
}

struct FeedModel: Codable {
 var results: [BookModel]
}

struct BookModel: Codable {
    var artistName: String?
    var id: String?
    var name: String?
    var date: String?
    var kind: String?
    var imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case artistName, id, name, kind
        case date = "releaseDate"
        case imageUrl = "artworkUrl100"
       }
}
