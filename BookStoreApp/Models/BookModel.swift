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

struct BookModel: Codable, Equatable {
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

extension BookModel {
    var isFavorite: Bool {
        guard let id else { return false }
        return CoreDataManager.shared.isBookFavorite(bookId: id)
    }

    static func from(favoriteBook: FavoriteBookModel) -> BookModel {
        return BookModel(
            artistName: favoriteBook.bookArtistName,
            id: favoriteBook.bookId,
            name: favoriteBook.bookName,
            date: favoriteBook.bookDate,
            kind: nil,
            imageUrl: favoriteBook.bookImageUrl
        )
    }
}
