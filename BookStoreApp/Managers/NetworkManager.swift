//
//  NetworkManager.swift
//  BookStoreApp
//
//  Created by Mine Rala on 3.02.2025.
//

import Foundation

protocol NetworkManagerProtocol {
    func makeRequest<T: Decodable>(endpoint: Endpoint, type: T.Type, completed: @escaping (Result<T, BAError>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()

    func makeRequest<T: Decodable>(endpoint: Endpoint, type: T.Type, completed: @escaping (Result<T, BAError>) -> Void) {
        guard let url = endpoint.url else {
            completed(.failure(.invalidKeyword))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let decodedObject = try decoder.decode(T.self, from: data)
                completed(.success(decodedObject))
            } catch {
                completed(.failure(.invalidData))
            }
        }.resume()
    }

    func loadListOfBooks(currentPage: Int, itemsPerPage: Int, completion: @escaping ([BookModel]) -> Void) {
        let page = currentPage - 1 // Sayfayı 0'dan başlatmak için
        var bookList: [BookModel] = []

        // API URL'yi Endpoint'ten alıyoruz
        NetworkManager.shared.makeRequest(endpoint: .bookModel, type: ResultModel.self) { result in
            switch result {
            case .success(let resultModel):
                let bookResults = resultModel.feed.results

                // Toplamda 100 öğe olduğunu varsayıyoruz
                // Kullanıcının istediği sayfaya göre 20 öğe döndürülür
                if page * itemsPerPage < bookResults.count {
                    // Belirtilen sayfa numarasına göre kitapları filtrele
                    for index in page * itemsPerPage..<min((currentPage * itemsPerPage), bookResults.count) {
                        bookList.append(bookResults[index])
                    }
                }
                // İşlem tamamlandığında tamamlanan kitapları döndür
                completion(bookList)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

}
