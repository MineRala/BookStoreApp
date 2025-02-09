//
//  HomeViewModelTests.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 7.02.2025.
//

import XCTest
@testable import BookStoreApp

// MARK: - HomeViewModelTests Tests
final class HomeViewModelTests: XCTestCase {
    // MARK: - Properties
    var viewModel: HomeViewModel!
    var mockViewController: MockHomeViewController!
    var mockNetworkManager: MockNetworkManager!
    var mockCoreDataManager: MockCoreDataManager!
    var initialBooks: [BookModel]!

    // MARK: - Setup & Teardown

    override func setUp() {
        super.setUp()

        initialBooks = [
            BookModel(artistName: "Dr. Ricken Lazlo Hale, PhD", name: "The You You Are", date: "2025-01-31"),
            BookModel(artistName: "Anonymous", name: "Severance", date: "2022-03-18")
        ]

        mockViewController = MockHomeViewController()
        mockNetworkManager = MockNetworkManager()
        mockCoreDataManager = MockCoreDataManager()

        viewModel = HomeViewModel(view: mockViewController, networkManager: mockNetworkManager)
    }

    override func tearDown() {
        viewModel = nil
        mockViewController = nil
        mockNetworkManager = nil
        mockCoreDataManager = nil
        super.tearDown()
    }

    // MARK: - View Model Initialization and Data Loading Tests
    func testViewDidLoad() {
        // Given
        let mockResult = ResultModel(feed: FeedModel(results: initialBooks))
        let mockData = try! JSONEncoder().encode(mockResult)
        mockNetworkManager.mockData = mockData

        let expectation = self.expectation(description: "collectionViewReload should be called")

        // When
        viewModel.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Then
            XCTAssertTrue(self.mockViewController.configureNavigationBarCalled, "Configure UI should be called.")
            XCTAssertTrue(self.mockViewController.isActivityIndicatorActiveCalled, "Activity Indicator should be hidden after data load.")
            XCTAssertTrue(self.mockViewController.collectionViewReloadDataCalled, "Table view should be reloaded after data is loaded.")

            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    // MARK: - Sorting Tests
    func testSortBooksWhenSortNewToOldShouldSortBooks() {
        // Given
        mockNetworkManager.mockBookList = initialBooks

        viewModel.viewDidLoad()

        let expectation = XCTestExpectation(description: "Books are loaded and sorted")

        // When
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.viewModel.createAction(sortType: .newToOld)

            // Then
            XCTAssertEqual(self.viewModel.getBook(index: 0).name, "The You You Are", "Books should be sorted from new to old based on the date.")
            XCTAssertEqual(self.viewModel.getBook(index: 1).name, "Severance", "Books should be sorted from new to old based on the date.")

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testSortBooksWhenSortOldToNewShouldSortBooks() {
        // Given
        mockNetworkManager.mockBookList = initialBooks

        viewModel.viewDidLoad()

        let expectation = XCTestExpectation(description: "Books are loaded and sorted")

        // When
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.viewModel.createAction(sortType: .oldToNew)

            // Then
            XCTAssertEqual(self.viewModel.getBook(index: 0).name, "Severance", "Books should be sorted from old to new based on the date.")
            XCTAssertEqual(self.viewModel.getBook(index: 1).name, "The You You Are", "Books should be sorted from old to new based on the date.")

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    // MARK: - Empty Label Visibility Tests
    func testUpdateEmptyLabelVisibilityWhenFavoritesSelectedAndEmptyShouldShowLabel() {
        // Given
        viewModel.createAction(sortType: .favoritesBook)

        mockCoreDataManager.favoriteBooks = [:]

        // When
        viewModel.refreshFavorites()

        // Then
        XCTAssertTrue(mockViewController.setEmptyLabelVisibilityCalled, "setEmptyLabelVisibility should be called when favorites are empty.")
    }

    func testSetEmptyLabelVisibility() {
        // Given
        mockViewController.setEmptyLabelVisibility(isVisible: true)

        // When
        mockViewController.setEmptyLabelVisibility(isVisible: true)

        // Then
        XCTAssertTrue(mockViewController.setEmptyLabelVisibilityCalled, "setEmptyLabelVisibility should be called.")
        XCTAssertTrue(mockViewController.emptyLabelIsVisible, "emptyLabelIsVisible should be true.")
    }

    func testUpdateEmptyLabelVisibilityWhenNoFavoritesShouldHideLabel() {
        // Given
        mockCoreDataManager.favoriteBooks = [:]

        // When
        viewModel.refreshFavorites()

        // Then
        XCTAssertTrue(mockViewController.setEmptyLabelVisibilityCalled, "setEmptyLabelVisibility should be called when visibility is false.")
        XCTAssertFalse(mockViewController.emptyLabelIsVisible, "Empty label should be hidden when no favorites.")
    }

    // MARK: - Pagination Tests
    func testWillDisplayWhenLastItemVisibleShouldLoadNextPage() {
        // Given
        let mockBooks = (1...100).map { i in
            BookModel(artistName: "Author \(i)", id: "\(i)", name: "Book \(i)")
        }

        mockNetworkManager.mockBookList = mockBooks

        viewModel.viewDidLoad()

        // When
        viewModel.willDisplay(index: 19)

        // Then
        XCTAssertTrue(mockNetworkManager.loadListOfBooksCalled, "Next page should be loaded when the last item is visible.")
    }

    // MARK: - Favorite Tests
    func testToggleFavoriteWhenBookIsNotFavoriteShouldAddFavorite() {
        // Given
        let book = BookModel(artistName: "Dr. Ricken Lazlo Hale, PhD", id: "6738364141", name: "The You You Are")

        // When
        mockCoreDataManager.toggleFavorite(book: book)

        // Then
        XCTAssertTrue(mockCoreDataManager.addFavoriteCalled, "Favorite book should be added.")
        XCTAssertEqual(mockCoreDataManager.favoriteBooks.count, 1, "Favorite books count should be 1 after adding a favorite.")

        // When
        mockCoreDataManager.toggleFavorite(book: book)

        // Then
        XCTAssertTrue(mockCoreDataManager.removeFavoriteCalled, "Favorite book should be removed.")
        XCTAssertEqual(mockCoreDataManager.favoriteBooks.count, 0, "Favorite books count should be 0 after removing a favorite.")
    }

    func testIsBookFavoriteShouldReturnCorrectFavoriteStatus() {
        // Given
        let book = BookModel(artistName: "Dr. Ricken Lazlo Hale, PhD", id: "6738364141", name: "The You You Are")
        mockCoreDataManager.addFavorite(with: book)

        // When
        let isFavorite = mockCoreDataManager.isBookFavorite(bookId: "6738364141")

        // Then
        XCTAssertTrue(isFavorite)
    }

    // MARK: - Error Handling Tests
    func testLoadBooksWhenNetworkErrorShouldReturnEmptyList() {
        // Given
        mockNetworkManager.shouldReturnError = true

        // When
        viewModel.viewDidLoad()

        // Then
        XCTAssertEqual(viewModel.numberOfItemsInSection, 0, "Book list should be empty when there is a network error.")
    }

    func testRefreshFavoritesWhenNoFavoritesShouldClearBookData() {
        // Given
        mockCoreDataManager.favoriteBooks = [:]

        // When
        viewModel.refreshFavorites()

        // Then
        XCTAssertEqual(viewModel.numberOfItemsInSection, 0)
    }
}

