import XCTest
@testable import BookStoreApp

final class SearchViewModelTests: XCTestCase {
    var viewModel: SearchViewModel!
    var mockViewController: MockSearchViewController!
    var mockNetworkManager: MockNetworkManager!
    var initialBooks: [BookModel]!

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

    func testViewDidLoad() {
        // Given
        let mockResult = ResultModel(feed: FeedModel(results: [BookModel(artistName: "Author", name: "Test Book")]))
        let mockData = try! JSONEncoder().encode(mockResult)
        mockNetworkManager.mockData = mockData

        let expectation = self.expectation(description: "tableViewReload should be called")

        viewModel.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Then
            XCTAssertTrue(self.mockViewController.isConfigureUICalled, "Configure UI should be called.")
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
        viewModel.searchBarTexrDidChange(with: "")

        // Then
        XCTAssertEqual(viewModel.filteredBooks.count, 2, "Filtered books should contain all books when search text is empty.")
    }

    func testSearchBarTextDidChangeWithNonEmptyText() {
        // Given
        viewModel.books = initialBooks

        // When
        viewModel.searchBarTexrDidChange(with: "Severance")

        // Then
        XCTAssertEqual(viewModel.filteredBooks.count, 1, "Filtered books should contain only one book when search text matches 'Severance'.")
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
        XCTAssertTrue(mockViewController.isEmptyLabelVisible, "Empty label should be visible when books are not available.")
    }

    func testUpdateEmptyLabelVisibilityWhenBooksAreNotEmpty() {
        // Given
        viewModel.books = initialBooks
        viewModel.filteredBooks = initialBooks

        // When
        viewModel.updateEmptyLabelVisibility()

        // Then
        XCTAssertTrue(mockViewController.isSetEmptyLabelVisibilityCalled, "Empty label visibility should be updated when there are books.")
        XCTAssertFalse(mockViewController.isEmptyLabelVisible, "Empty label should be hidden when books are available.")
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
}
