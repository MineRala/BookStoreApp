//
//  MockNetworkManager.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 7.02.2025.
//

import Foundation
@testable import BookStoreApp

final class MockNetworkManager: NetworkManagerProtocol {
    // MARK: - Test Flags
    var loadListOfBooksCalled = false
    var shouldReturnError = false

    // MARK: - Properties
    var mockData: Data?
    var mockBookList: [BookModel]?


    // MARK: - Methods
    func makeRequest<T: Decodable>(endpoint: Endpoint, type: T.Type, completed: @escaping (Result<T, BAError>) -> Void) {
        if shouldReturnError {
            completed(.failure(.unableToComplete))
            return
        }

        guard let data = mockData else {
            completed(.failure(.invalidData))
            return
        }

        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            completed(.success(decodedObject))
        } catch {
            completed(.failure(.invalidData))
        }
    }

    func loadListOfBooks(currentPage: Int, itemsPerPage: Int, completion: @escaping ([BookModel]) -> Void) {
        loadListOfBooksCalled = true // Bu fonksiyon her çağrıldığında bayrak true yapılır.

        if shouldReturnError {
            completion([])  // Hata durumunda boş liste döndürüyoruz
            return
        }

        guard let mockBookList = mockBookList else {
            completion([])  // Eğer mock verisi yoksa boş liste döndürüyoruz
            return
        }

        // Sayfalama işlemi
        let page = currentPage - 1 // Sayfayı 0'dan başlatmak için
        var bookList: [BookModel] = []

        // Toplamda 100 öğe olduğunu varsayıyoruz
        // Kullanıcının istediği sayfaya göre 20 öğe döndürülür
        if page * itemsPerPage < mockBookList.count {
            // Belirtilen sayfa numarasına göre kitapları filtrele
            for index in page * itemsPerPage..<min((currentPage * itemsPerPage), mockBookList.count) {
                bookList.append(mockBookList[index])
            }
        }

        // İşlem tamamlandığında kitapları döndür
        completion(bookList)
    }
}
