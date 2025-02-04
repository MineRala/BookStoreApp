//
//  CoreDataManager.swift
//  BookStoreApp
//
//  Created by Mine Rala on 4.02.2025.
//

import CoreData
import UIKit

class CoreDataManager {

    static let shared = CoreDataManager()

    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "FavoriteBookModel") // Model adını değiştir
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Core Data yüklenirken hata oluştu: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - 📌 Yeni Favori Ekleme
    func addFavorite(with book: BookModel) {
        let newFavorite = FavoriteBookModel(context: context)
        newFavorite.bookId = book.id
        newFavorite.bookName = book.name
        newFavorite.bookArtistName = book.artistName
        newFavorite.bookDate = book.date
        newFavorite.bookImageUrl = book.imageUrl
        saveContext()
        print("Favori eklendi: \(newFavorite.bookName)")
    }

    // MARK: - ❌ Favori Silme
    func removeFavorite(bookId: String) {
        let fetchRequest: NSFetchRequest<FavoriteBookModel> = FavoriteBookModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "bookId == %@", bookId) // ✅ UUID yerine String ile karşılaştır

        do {
            let favorites = try context.fetch(fetchRequest)
            if let favoriteToRemove = favorites.first {
                context.delete(favoriteToRemove)
                saveContext()
                print("Favori kaldırıldı: \(favoriteToRemove.bookName ?? "")")
            } else {
                print("Belirtilen ID ile eşleşen favori bulunamadı: \(bookId)")
            }
        } catch {
            print("Favori silme hatası: \(error)")
        }
    }

    // MARK: - 🔍 Favori Listesini Getirme
    func getFavorites() -> [FavoriteBookModel] {
        let fetchRequest: NSFetchRequest<FavoriteBookModel> = FavoriteBookModel.fetchRequest()

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Favori listesi alınırken hata oluştu: \(error)")
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
            print("Favori kontrol hatası: \(error)")
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


    // MARK: - ✅ Core Data Kaydetme
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Core Data kaydetme hatası: \(error)")
            }
        }
    }
}
