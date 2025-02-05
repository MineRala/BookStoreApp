//
//  Constants.swift
//  BookStoreApp
//
//  Created by Mine Rala on 5.02.2025.
//

import Foundation

struct Constants {
    static let favoritePersistentContainerName = "FavoriteBookModel"
    static let favoritesUpdatedNotification = "FavoritesUpdated"

    static let tableViewCell = "TableViewCell"
    static let collectionViewCell = "CollectionViewCell"

    static let main = "Main"
    static let detailViewController = "DetailViewController"
    static let showDetailIdentifier = "showDetail"
    static let searchBookIdentifier = "searchBook"

    static let titleTextColor = "titleTextColor"
    static let emptyString = ""


}


struct Strings {
    static let allBook = "📚 All Book"
    static let newToOld = "📅 New To Old"
    static let oldToNew = "⏳ Old To New"
    static let onlyFavorites = "⭐ Only Favorites"
    static let sortingOptions = "Sorting Options"
    static let selectOption = "Select the option you want to sort by"
    static let cancel = "Cancel"
    static let searchPlaceholder = "Search by book title or author name"
}

struct Icons {
    static let starFill = "star.fill"
}
