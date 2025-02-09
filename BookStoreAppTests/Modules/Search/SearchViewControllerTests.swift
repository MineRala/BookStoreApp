//
//  SearchViewControllerTests.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 7.02.2025.
//

import XCTest
@testable import BookStoreApp

// MARK: - SearchViewController Tests
final class SearchViewControllerTests: XCTestCase {
    // MARK: - Properties
    var viewController: SearchViewController!
    var mockViewModel: MockSearchViewModel!

    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(identifier: "SearchViewController") as? SearchViewController
        mockViewModel = MockSearchViewModel()
        viewController.viewModel = mockViewModel
        viewController.loadViewIfNeeded()
    }

    override func tearDown() {
        viewController = nil
        mockViewModel = nil
        super.tearDown()
    }

    // MARK: - ViewDidLoad Tests
    func testViewDidLoadShouldCallViewModelViewDidLoad() {
        // When
        viewController.viewDidLoad()

        // Then
        XCTAssertTrue(mockViewModel.isViewDidLoadCalled, "viewModel.viewDidLoad() should be called when viewDidLoad is invoked.")
    }

    // MARK: - UI Tests
    func testConfigureUIShouldSetUpUI() {
        // When
        viewController.configureUI()

        // Then
        XCTAssertNotNil(viewController.searchBar.delegate, "Search bar delegate should be set.")
        XCTAssertNotNil(viewController.tableView.dataSource, "Table view data source should be set.")
        XCTAssertNotNil(viewController.tableView.delegate, "Table view delegate should be set.")
        XCTAssertTrue(viewController.activityIndicator.isAnimating, "Activity indicator should be active initially.")
        XCTAssertFalse(viewController.activityIndicator.isHidden, "Activity indicator should be visible, but it is hidden.")
        XCTAssertTrue(viewController.tableView.isHidden, "Table view should be hidden, but it is visible.")
        XCTAssertEqual(viewController.activityIndicator.transform, CGAffineTransform(scaleX: 2.0, y: 2.0), "Activity indicator's transform should be set to CGAffineTransform(scaleX: 2.0, y: 2.0).")
        XCTAssertEqual(viewController.navigationItem.backButtonTitle, Constants.emptyString, "Navigation item backButtonTitle should be set to Constants.emptyString.")
        XCTAssertEqual(viewController.searchBar.placeholder, Strings.searchPlaceholder, "Search bar placeholder text does not match the expected value.")
    }

    func testActivityIndicatorHiddenShouldHideActivityIndicator() {
        // When
        viewController.activityIndicatorHidden()

        // Then
        XCTAssertFalse(viewController.activityIndicator.isAnimating, "Activity indicator should be hidden after loading.")
        XCTAssertFalse(viewController.tableView.isHidden, "Table view should be visible after hiding the activity indicator.")
    }

    func testSetEmptyLabelVisibilityShouldShowEmptyLabel() {
        // When
        viewController.setEmptyLabelVisibility(isVisible: true)

        // Then
        XCTAssertFalse(viewController.emptyLabel.isHidden, "Empty label should be visible when isVisible is true.")
        XCTAssertTrue(viewController.tableView.isHidden, "Table view should be hidden when empty label is visible.")
    }

    func testSetEmptyLabelVisibilityShouldHideEmptyLabel() {
        // When
        viewController.setEmptyLabelVisibility(isVisible: false)

        // Then
        XCTAssertTrue(viewController.emptyLabel.isHidden, "Empty label should be hidden when isVisible is false.")
        XCTAssertFalse(viewController.tableView.isHidden, "Table view should be visible when empty label is hidden.")
    }

    // MARK: - Search Bar Tests
    func testSearchBarTextDidChangeShouldFilterBooks() {
        // When
        viewController.searchBar(viewController.searchBar, textDidChange: "the")

        // Then
        XCTAssertTrue(mockViewModel.isSearchBarTextDidChangeCalled, "viewModel.searchBarTextDidChange() should be called.")
        XCTAssertEqual(mockViewModel.numberOfRowsInSection, 1, "Filtering operation did not work as expected.")
        XCTAssertEqual(mockViewModel.getBook(index: 0).name, "The You You Are", "Filtering did not work correctly.")
    }

    func testSearchBarCancelButtonClickedShouldResetFilters() {
        viewController.searchBar(viewController.searchBar, textDidChange: "the")
        XCTAssertEqual(mockViewModel.numberOfRowsInSection, 1, "Search results are different from expected!")

        // When
        viewController.searchBarCancelButtonClicked(viewController.searchBar)

        // Then
        XCTAssertTrue(mockViewModel.isSearchBarTextDidChangeCalled, "Search bar text change should trigger the corresponding method.")
        XCTAssertEqual(mockViewModel.numberOfRowsInSection, 2, "Books were not reset properly!")
        XCTAssertEqual(viewController.searchBar.text, "", "Search bar text was not reset!")
        XCTAssertTrue(mockViewModel.isSetFilteredBooksWithBooksCalled, "setFilteredBooksWithBooks was not called.")
        XCTAssertTrue(mockViewModel.isUpdateEmptyLabelVisibilityCalled, "updateEmptyLabelVisibility was not called.")
    }

    // MARK: - TableView DataSource Tests
    func testTableViewNumberOfRowsShouldReturnCorrectRowCount() {
        // When
        let numberOfRows = viewController.tableView(viewController.tableView, numberOfRowsInSection: 0)

        // Then
        XCTAssertEqual(numberOfRows, 2, "Row count should be 2.")
    }

    func testTableViewCellForRowShouldReturnConfiguredCell() {
        // Given
        mockViewModel.setFilteredBooksWithBooks()

        _ = UINavigationController(rootViewController: viewController)
        viewController.view = viewController.view // Ensure the view is loaded

        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        viewController.tableView.register(nib, forCellReuseIdentifier: "TableViewCell")
        viewController.loadViewIfNeeded()

        // When
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = viewController.tableView(viewController.tableView, cellForRowAt: indexPath)

        // Then
        XCTAssertTrue(mockViewModel.isSetFilteredBooksWithBooksCalled, "setFilteredBooksWithBooks should be called when the table view is loaded.")
        XCTAssertTrue(cell is TableViewCell, "Cell should be of type TableViewCell.")

        if let tableViewCell = cell as? TableViewCell {
            XCTAssertEqual(tableViewCell.titleLabel.text, "The You You Are", "Cell book is not configured correctly.")
        } else {
            XCTFail("The cell is not of type TableViewCell.")
        }
    }

    // MARK: - TableView Delegate Tests
    func testTableViewDidSelectRowShouldPushDetailViewController() {
        // Given
        let indexPath = IndexPath(row: 0, section: 0)

        let mockNavigationController = UINavigationController(rootViewController: viewController)
        viewController.viewModel.setFilteredBooksWithBooks()
        viewController.view = viewController.view

        // When
        viewController.tableView(viewController.tableView, didSelectRowAt: indexPath)

        // Then
        XCTAssertTrue(mockViewModel.isSetFilteredBooksWithBooksCalled, "setFilteredBooksWithBooks should be called.")
        XCTAssertTrue(mockNavigationController.viewControllers.contains { $0 is DetailViewController }, "DetailViewController should be pushed after selecting a row.")
    }

    func testTableViewHeightForRowAtShouldReturnCorrectHeight() {
        // When
        let height = viewController.tableView(viewController.tableView, heightForRowAt: IndexPath(row: 0, section: 0))

        // Then
        XCTAssertEqual(height, 140, "Row height should be 140.")
    }
}
