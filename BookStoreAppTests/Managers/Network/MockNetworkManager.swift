//
//  MockNetworkManager.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 7.02.2025.
//

import Foundation
@testable import BookStoreApp

final class MockNetworkManager: NetworkManagerProtocol {
    var shouldReturnError = false
    var mockData: Data?

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
}
