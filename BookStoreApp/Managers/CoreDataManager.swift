//
//  CoreDataManager.swift
//  BookStoreApp
//
//  Created by Mine Rala on 4.02.2025.
//

import CoreData
import UIKit

protocol CoreDataManagerProtocol {
    func addFavorite(with book: BookModel)
    func removeFavorite(bookId: String)
    func toggleFavorite(book: BookModel)
    func isBookFavorite(bookId: String) -> Bool
}

class CoreDataManager: CoreDataManagerProtocol {

    static let shared = CoreDataManager()

    let persistentContainer: NSPersistentContainer

    init() {
        persistentContainer = NSPersistentContainer(name: Constants.favoritePersistentContainerName)
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Error loading Core Data: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Add Favorite Book
    func addFavorite(with book: BookModel) {
        let newFavorite = FavoriteBookModel(context: context)
        newFavorite.bookId = book.id
        newFavorite.bookName = book.name
        newFavorite.bookArtistName = book.artistName
        newFavorite.bookDate = book.date
        newFavorite.bookImageUrl = book.imageUrl
        saveContext()
        print("Favorite added: \(newFavorite.bookName)")
    }

    // MARK: - Delete Favorite Book
    func removeFavorite(bookId: String) {
        let fetchRequest: NSFetchRequest<FavoriteBookModel> = FavoriteBookModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "bookId == %@", bookId) // ✅ UUID yerine String ile karşılaştır

        do {
            let favorites = try context.fetch(fetchRequest)
            if let favoriteToRemove = favorites.first {
                context.delete(favoriteToRemove)
                saveContext()
                print("Favorite removed: \(favoriteToRemove.bookName ?? "")")
            } else {
                print("No favorites matching the specified ID were found: \(bookId)")
            }
        } catch {
            print("Favorite deletion error: \(error)")
        }
    }

    // MARK: - Get Favorite Book List
    func getFavorites() -> [FavoriteBookModel] {
        let fetchRequest: NSFetchRequest<FavoriteBookModel> = FavoriteBookModel.fetchRequest()

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error retrieving favorites list: \(error)")
            return []
        }
    }

    func isBookFavorite(bookId: String) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteBookModel> = FavoriteBookModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "bookId == %@", bookId)

        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Favorite control error: \(error)")
            return false
        }
    }

    func toggleFavorite(book: BookModel) {
           guard let bookId = book.id else { return }
           if isBookFavorite(bookId: bookId) {
               removeFavorite(bookId: bookId)
           } else {
               addFavorite(with: book)
           }
       }


    // MARK: - Save Data
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Core Data saving error: \(error)")
            }
        }
    }
}
