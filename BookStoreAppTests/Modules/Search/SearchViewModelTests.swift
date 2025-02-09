import XCTest
@testable import BookStoreApp

// MARK: - SearchViewModel Tests
final class SearchViewModelTests: XCTestCase {
    // MARK: - Properties
    var viewModel: SearchViewModel!
    var mockViewController: MockSearchViewController!
    var mockNetworkManager: MockNetworkManager!
    var initialBooks: [BookModel]!

    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        initialBooks = [
            BookModel(artistName: "Dr. Ricken Lazlo Hale, PhD", name: "The You You Are"),
            BookModel(artistName: "Anonymous", name: "Severance")
        ]

        mockViewController = MockSearchViewController()
        mockNetworkManager = MockNetworkManager()

        viewModel = SearchViewModel(view: mockViewController, networkManager: mockNetworkManager)
    }

    override func tearDown() {
        viewModel = nil
        mockViewController = nil
        mockNetworkManager = nil
        initialBooks = nil
        super.tearDown()
    }

    // MARK: - ViewModel Initialization Tests
    func testViewDidLoad() {
        // Given
        let mockResult = ResultModel(feed: FeedModel(results: initialBooks))
        let mockData = try! JSONEncoder().encode(mockResult)
        mockNetworkManager.mockData = mockData

        let expectation = self.expectation(description: "tableViewReload should be called")

        // When
        viewModel.viewDidLoad()

        DispatchQueue.main.async {
            // Then
            XCTAssertTrue(self.mockViewController.isConfigureUICalled, "Configure UI should be called after data load.")
            XCTAssertTrue(self.mockViewController.isActivityIndicatorHiddenCalled, "Activity Indicator should be hidden after data load.")
            XCTAssertTrue(self.mockViewController.isTableViewReloadCalled, "Table view should be reloaded after data is loaded.")

            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    // MARK: - Search Bar Tests
    func testSearchBarTextDidChangeWithEmptyText() {
        // Given
        viewModel.books = initialBooks
        viewModel.filteredBooks = initialBooks

        // When
        viewModel.searchBarTextDidChange(with: "")

        // Then
        XCTAssertEqual(viewModel.filteredBooks.count, 2, "Filtered books should contain all books when search text is empty.")
        XCTAssertTrue(mockViewController.isSetEmptyLabelVisibilityCalled, "Empty label visibility should be updated.")
        XCTAssertFalse(mockViewController.isEmptyLabelVisible, "Empty label should be visible when search text is empty.")
        XCTAssertTrue(self.mockViewController.isTableViewReloadCalled, "Table view should be reloaded when search text is cleared.")
    }

    func testSearchBarTextDidChangeWithNonEmptyText() {
        // Given
        viewModel.books = initialBooks

        // When
        viewModel.searchBarTextDidChange(with: "Severance")

        // Then
        XCTAssertEqual(viewModel.filteredBooks.count, 1, "Filtered books should contain only one book when search text matches 'Severance'.")
        XCTAssertEqual(viewModel.filteredBooks.first?.name, "Severance", "The filtered book should be 'Severance'.")
        XCTAssertTrue(mockViewController.isSetEmptyLabelVisibilityCalled, "Empty label visibility should be updated.")
        XCTAssertFalse(mockViewController.isEmptyLabelVisible, "Empty label should be hidden when books are filtered.")
        XCTAssertTrue(self.mockViewController.isTableViewReloadCalled, "Table view should be reloaded after search text is applied.")
    }

    // MARK: - Empty Label Tests
    func testUpdateEmptyLabelVisibilityWhenBooksAreEmpty() {
        // Given
        viewModel.books = []
        viewModel.filteredBooks = []

        // When
        viewModel.updateEmptyLabelVisibility()

        // Then
        XCTAssertTrue(mockViewController.isSetEmptyLabelVisibilityCalled, "Empty label visibility should be updated when there are no books.")
        XCTAssertTrue(mockViewController.isEmptyLabelVisible, "Empty label should be visible when no books are available.")
    }

    func testUpdateEmptyLabelVisibilityWhenBooksAreNotEmpty() {
        // Given
        viewModel.books = initialBooks
        viewModel.filteredBooks = initialBooks

        // When
        viewModel.updateEmptyLabelVisibility()

        // Then
        XCTAssertTrue(mockViewController.isSetEmptyLabelVisibilityCalled, "Empty label visibility should be updated when books are available.")
        XCTAssertFalse(mockViewController.isEmptyLabelVisible, "Empty label should be hidden when there are books available.")
    }

    // MARK: - Filtered Books Tests
    func testSetFilteredBooksWithBooks() {
        // Given
        viewModel.books = initialBooks
        viewModel.filteredBooks = [BookModel]()

        // When
        viewModel.setFilteredBooksWithBooks()

        // Then
        XCTAssertEqual(viewModel.filteredBooks, viewModel.books, "filteredBooks should be equal to books after calling setFilteredBooksWithBooks.")
    }

    func testGetBook() {
        // Given
        viewModel.books = initialBooks
        viewModel.filteredBooks = initialBooks

        // When
        let book = viewModel.getBook(index: 1)

        // Then
        XCTAssertEqual(book.name, "Severance", "The returned book should have the name 'Severance'.")
        XCTAssertEqual(book.artistName, "Anonymous", "The returned book should have the artist name 'Anonymous'.")
    }

    // MARK: - TableView Tests
    func testNumberOfRowsInSection() {
        // Given
        viewModel.filteredBooks = initialBooks

        // When
        let rowCount = viewModel.numberOfRowsInSection

        // Then
        XCTAssertEqual(rowCount, 2, "Number of rows in section should match the count of filteredBooks.")
    }

    func testHeightForRowAt() {
        // Given
        let expectedHeight: Double = 140

        // When
        let rowHeight = viewModel.heightForRowAt

        // Then
        XCTAssertEqual(rowHeight, expectedHeight, "The row height should be equal to \(expectedHeight).")
    }
}
