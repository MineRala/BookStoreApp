//
//  NetworkManagerTests.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 7.02.2025.
//

import XCTest
@testable import BookStoreApp

final class NetworkManagerTests: XCTestCase {
    // MARK: - Properties
    var mockNetworkManager: MockNetworkManager!

    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
    }

    override func tearDown() {
        mockNetworkManager = nil
        super.tearDown()
    }

    func testMakeRequestSuccess() {
        // Given
        let json = """
        {
            "feed": {
                "results": [
                    {
                    "artistName": "Dr. Ricken Lazlo Hale, PhD",
                    "id": "6738364141",
                    "name": "The You You Are",
                    "releaseDate": "2025-01-31",
                    "kind": "books",
                    "artistId": "1780413759",
                    "artistUrl": "https://books.apple.com/us/author/dr-ricken-lazlo-hale-phd/id1780413759",
                    "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Publication221/v4/15/0b/7e/150b7e65-2ae6-69cb-2281-6ecb8190fc37/SEV2_E-Book_1524x2339_sRGB_FIN01a.jpg/100x153bb.png"
                      },
                    {
                    "artistName": "Anonymous",
                    "id": "1613220757",
                    "name": "Severance",
                    "releaseDate": "2022-03-18",
                    "kind": "books",
                    "artistId": "1616260245",
                    "artistUrl": "https://books.apple.com/us/author/anonymous/id1616260245",
                    "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Publication126/v4/0c/cf/d5/0ccfd594-6286-9daf-df93-3239b2f07e1c/SEV1_BookCover.jpg/100x134bb.png",
                    }
                ]
            }
        }
        """.data(using: .utf8)!

        mockNetworkManager.mockData = json

        let expectation = self.expectation(description: "The API call should be successful.")

        // When
        mockNetworkManager.makeRequest(endpoint: .bookModel, type: ResultModel.self) { result in
            switch result {
            case .success(let resultModel):
                XCTAssertEqual(resultModel.feed.results.count, 2, "The number of books should be 2.")
                XCTAssertEqual(resultModel.feed.results[0].name, "The You You Are", "The title of the first book is incorrect.")
                XCTAssertEqual(resultModel.feed.results[1].name, "Severance", "The title of the second book is incorrect.")
                expectation.fulfill()
            case .failure:
                XCTFail("The API call that was supposed to succeed failed.")
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testMakeRequestFailure() {
        // Given
        mockNetworkManager.shouldReturnError = true // Hata döndürmesini sağla

        let expectation = self.expectation(description: "The API call should fail.")

        // When
        mockNetworkManager.makeRequest(endpoint: .bookModel, type: ResultModel.self) { result in
            switch result {
            case .success:
                XCTFail("The API call that was supposed to fail succeeded.")
            case .failure(let error):
                XCTAssertEqual(error, .unableToComplete, "The returned error code is incorrect.")
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testLoadListOfBooksSuccess() {
        // Given
        let mockBooks: [BookModel] = [
            BookModel(artistName: "Dr. Ricken Lazlo Hale, PhD", name: "The You You Are"),
            BookModel(artistName: "Anonymous", name: "Severance")
        ]

        mockNetworkManager.mockBookList = mockBooks

        let expectation = self.expectation(description: "The loadListOfBooks function should return paginated results.")

        // When
        mockNetworkManager.loadListOfBooks(currentPage: 1, itemsPerPage: 1) { books in
            // First page should return only 1 book (pagination test)
            XCTAssertEqual(books.count, 1, "The number of books in the first page should be 1.")
            XCTAssertEqual(books.first?.name, "The You You Are", "The title of the first book is incorrect.")

            // When we load the second page
            self.mockNetworkManager.loadListOfBooks(currentPage: 2, itemsPerPage: 1) { books in
                XCTAssertEqual(books.count, 1, "The number of books in the second page should be 1.")
                XCTAssertEqual(books.first?.name, "Severance", "The title of the second book is incorrect.")

                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testLoadListOfBooksFailure() {
        // Given
        mockNetworkManager.shouldReturnError = true

        let expectation = self.expectation(description: "The loadListOfBooks function should return an empty array on error.")

        // When
        mockNetworkManager.loadListOfBooks(currentPage: 1, itemsPerPage: 10) { books in
            XCTAssertEqual(books.count, 0, "The number of books should be 0 on failure.")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }
}
