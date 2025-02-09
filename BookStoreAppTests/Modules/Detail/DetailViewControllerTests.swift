//
//  DetailViewControllerTests.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 6.02.2025.
//

import XCTest
@testable import BookStoreApp

final class DetailViewControllerTests: XCTestCase {
    // MARK: - Properties
    var viewController: DetailViewController!
    var mockViewModel: MockDetailViewModel!
    var mockCacheManager: MockCacheManager!
    var book: BookModel!

    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()

        book = BookModel(
            artistName: "Anonymous",
            id: "1613220757",
            name: "Severance",
            date: "2022-03-18",
            imageUrl: "https://is1-ssl.mzstatic.com/image/thumb/Publication126/v4/0c/cf/d5/0ccfd594-6286-9daf-df93-3239b2f07e1c/SEV1_BookCover.jpg/100x134bb.png"
        )

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        viewController.loadViewIfNeeded()

        mockCacheManager = MockCacheManager()
        mockCacheManager.imageToReturn = UIImage(named: "image")

        mockViewModel = MockDetailViewModel()
        viewController.viewModel = mockViewModel
        viewController.book = book
    }

    override func tearDown() {
        viewController = nil
        mockViewModel = nil
        mockCacheManager = nil
        book = nil
        super.tearDown()
    }

    // MARK: - View Lifecycle Tests
    func testViewModelViewDidLoadCalled() {
        // Given
        XCTAssertNotNil(viewController.viewModel, "ViewModel should not be nil!")

        // When
        viewController.viewDidLoad()

        // Then
        XCTAssertTrue(mockViewModel.viewDidLoadCalled, "viewDidLoad method was not called!")
    }

    func testViewModelViewWillAppearCalled() {
        // Given
        XCTAssertNotNil(viewController.viewModel, "ViewModel should not be nil!")

        // When
        viewController.viewWillAppear(true)

        // Then
        XCTAssertTrue(mockViewModel.viewWillAppearCalled, "viewWillAppear method was not called!")
    }

    // MARK: - UI Update Tests
    func testUpdateUIWithBook() {
        // When
        viewController.updateUI(with: book, cacheManager: mockCacheManager)

        // Then
        XCTAssertEqual(viewController.titleLabel.text, "Severance", "Book title is incorrect!")
        XCTAssertEqual(viewController.authorLabel.text, "Anonymous", "Author name is incorrect!")

        let expectedDate = book.date?.convertToMonthDayYearFormat()
        XCTAssertEqual(viewController.dateLabel.text, expectedDate, "Date label should display the correct date format!")

        XCTAssertNotNil(viewController.imageView.image, "Image was not loaded!")
        XCTAssertTrue(mockCacheManager.loadImageCalled, "loadImage method was not called on cache manager!")
        XCTAssertEqual(viewController.imageView.image, mockCacheManager.imageToReturn, "Loaded image does not match the expected mock image!")
    }

    // MARK: - Favorite Button Tests
    func testFavoriteButtonTappedCallsViewModelMethod() {
        // Given
        XCTAssertNotNil(viewController.viewModel, "ViewModel should not be nil!")

        // When
        viewController.favoriteButtonTapped()

        // Then
        XCTAssertTrue(mockViewModel.favoriteButtonTappedCalled, "favoriteButtonTapped method was not called!")
    }

    func testFavoriteButtonIconUpdates() {
        // When
        viewController.updateFavoriteButtonIcon(isFavorite: true)

        // Then
        XCTAssertEqual(viewController.favoriteButton.tintColor, .yellow, "Favorite button should be yellow when favorite.")

        // When
        viewController.updateFavoriteButtonIcon(isFavorite: false)

        // Then
        XCTAssertEqual(viewController.favoriteButton.tintColor, .darkGray, "Favorite button should be gray when not favorite.")
    }
}
