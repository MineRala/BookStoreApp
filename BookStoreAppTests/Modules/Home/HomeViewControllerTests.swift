//
//  HomeViewControllerTests.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 7.02.2025.
//

import XCTest
@testable import BookStoreApp

// MARK: - HomeViewController Tests
final class HomeViewControllerTests: XCTestCase {
    // MARK: - Properties
    var viewController: HomeViewController!
    var mockViewModel: MockHomeViewModel!

    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(identifier: "HomeViewController") as? HomeViewController

        mockViewModel = MockHomeViewModel()
        viewController.viewModel = mockViewModel
        viewController.loadViewIfNeeded()
    }

    override func tearDown() {
        viewController = nil
        mockViewModel = nil
        super.tearDown()
    }

    // MARK: - UI Tests
    func testConfigureNavigationBar() {
        let navigationController = UINavigationController(rootViewController: viewController)
        // When
        viewController.configureNavigationBar()

        // Then
        XCTAssertEqual(viewController.navigationItem.backButtonTitle, Constants.emptyString, "Back button title should be empty.")
        XCTAssertEqual(navigationController.navigationBar.tintColor, .gray, "Navigation bar tint color should be gray.")
    }

    func testConfigureCollectionView() {
        // Given
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10

        // When
        viewController.configureCollectionView()

        // Then
        XCTAssertTrue(viewController.collectionView.collectionViewLayout is UICollectionViewFlowLayout, "CollectionView should have UICollectionViewFlowLayout.")
        XCTAssertEqual((viewController.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing, 10, "Minimum interitem spacing should be 10.")
        XCTAssertEqual((viewController.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing, 10, "Minimum line spacing should be 10.")
        XCTAssertTrue(viewController.collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionViewCell, for: IndexPath(row: 0, section: 0)) is CollectionViewCell, "CollectionView should register the correct cell.")
    }

    // MARK: - View Lifecycle Tests
    func testViewDidLoadShouldCallViewModelViewDidLoad() {
        // When
        viewController.viewDidLoad()

        // Then
        XCTAssertTrue(mockViewModel.viewDidLoadCalled, "ViewModel's viewDidLoad method should have been called.")
        XCTAssertEqual(mockViewModel.bookData.count, mockViewModel.mockBooks.count, "Books should be loaded correctly.")
    }

    // MARK: - Sorting Tests
    func testSortBooksShouldSortBasedOnSelectedSortType() {
        // Given
        mockViewModel.createAction(sortType: .newToOld)

        // When
        mockViewModel.sortBooks()

        // Then
        XCTAssertTrue(mockViewModel.sortBooksCalled, "ViewModel's sortBooks method should have been called.")
        XCTAssertTrue(mockViewModel.isUpdateEmptyLabelVisibilityCalled, "updateEmptyLabelVisibility method should be called.")
        XCTAssertEqual(mockViewModel.bookData, mockViewModel.mockBooks.sortByDateDescending(), "Books should be sorted by date in descending order.")

        // Given
        mockViewModel.createAction(sortType: .oldToNew)

        // When
        mockViewModel.sortBooks()

        // Then
        XCTAssertTrue(mockViewModel.sortBooksCalled, "ViewModel's sortBooks method should have been called.")
        XCTAssertTrue(mockViewModel.isUpdateEmptyLabelVisibilityCalled, "updateEmptyLabelVisibility method should be called.")
        XCTAssertEqual(mockViewModel.bookData, mockViewModel.mockBooks.sortByDateAscending(), "Books should be sorted by date in ascending order.")
    }

    // MARK: - Empty Label Visibility Tests
    func testSetEmptyLabelVisibilityWhenVisibleShouldHideCollectionView() {
        // When
        viewController.setEmptyLabelVisibility(isVisible: true)

        // Then
        XCTAssertFalse(viewController.emptyLabel.isHidden, "Empty label should be visible.")
        XCTAssertTrue(viewController.collectionView.isHidden, "CollectionView should be hidden.")
    }

    func testSetEmptyLabelVisibilityWhenHiddenShouldShowCollectionView() {
        // When
        viewController.setEmptyLabelVisibility(isVisible: false)

        // Then
        XCTAssertTrue(viewController.emptyLabel.isHidden, "Empty label should be hidden.")
        XCTAssertFalse(viewController.collectionView.isHidden, "CollectionView should be visible.")
    }

    // MARK: - Activity Indicator Tests
    func testConfigureActivityIndicator() {
        // When
        viewController.configureActivityIndicator()

        // Then
        XCTAssertTrue(viewController.activityIndicator.isAnimating, "Activity indicator should be active.")
        XCTAssertEqual(viewController.activityIndicator.transform, CGAffineTransform(scaleX: 2.0, y: 2.0), "Activity indicator should be scaled correctly.")
    }

    func testIsActivityIndicatorActive() {
        // When: isActive -> true
        viewController.isActivityIndicatorActive(isActive: true)

        // Then:
        XCTAssertTrue(viewController.activityIndicator.isAnimating, "Activity indicator should be animating when active.")
        XCTAssertFalse(viewController.activityIndicator.isHidden, "Activity Indicator should be visible when active.")

        // When: isActive -> false
        viewController.isActivityIndicatorActive(isActive: false)

        // Then
        XCTAssertFalse(viewController.activityIndicator.isAnimating, "Activity Indicator should not be animating when inactive.")
        XCTAssertTrue(viewController.activityIndicator.isHidden, "Activity Indicator should be hidden when inactive.")
    }

    // MARK: - CollectionView Data Source Tests
    func testCollectionViewNumberOfItemsShouldReturnCorrectItemCount() {
        // Given
        mockViewModel.viewDidLoad()

        // When
        let numberOfItems = viewController.collectionView(viewController.collectionView, numberOfItemsInSection: 0)

        // Then
        XCTAssertTrue(mockViewModel.viewDidLoadCalled, "The viewDidLoad method should have been called.")
        XCTAssertEqual(numberOfItems, 2, "Item count in the collection view should be 2.")
    }

    func testCollectionViewCellForItemAtShouldReturnConfiguredCell() {
        // Given
        mockViewModel.viewDidLoad()

        viewController.collectionView.dataSource = viewController
        viewController.collectionView.delegate = viewController

        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        viewController.collectionView.register(nib, forCellWithReuseIdentifier: "CollectionViewCell")
        viewController.collectionView.reloadData()
        RunLoop.current.run(until: Date())

        // When
        let indexPath = IndexPath(row: 0, section: 0)
        guard let cell = viewController.collectionView.dataSource?.collectionView(
            viewController.collectionView,
            cellForItemAt: indexPath
        ) as? CollectionViewCell else {
            XCTFail("Cell should be of type CollectionViewCell")
            return
        }

        // Then
        XCTAssertEqual(cell.label.text, "The You You Are", "Cell book is not configured correctly.")
    }

    // MARK: - CollectionView Delegate Tests
    func testCollectionViewDidSelectItemShouldPushDetailViewController() {
        // Given
        mockViewModel.viewDidLoad()
        let indexPath = IndexPath(row: 0, section: 0)
        let mockNavigationController = UINavigationController(rootViewController: viewController)

        viewController.view = viewController.view

        // When
        viewController.collectionView(viewController.collectionView, didSelectItemAt: indexPath)

        // Then
        XCTAssertTrue(mockNavigationController.viewControllers.contains { $0 is DetailViewController }, "DetailViewController should be pushed after selecting a collection view item.")
    }

    func testWillDisplayShouldIncrementPageForPagination() {
        // Given
        let initialPage = mockViewModel.currentPage

        // When
        mockViewModel.willDisplay(index: mockViewModel.bookData.count - 1)

        // Then
        XCTAssertTrue(mockViewModel.willDisplayCalled, "The 'willDisplay' method should have been called.")
        XCTAssertEqual(mockViewModel.currentPage, initialPage + 1, "The page number should have incremented by 1.")
    }

    // MARK: - CollectionView DelegateFlowLayout Tests
    func testCalculateItemSizeShouldReturnCorrectSize() {
        // Given
        let collectionViewWidth: CGFloat = 320.0
        let spacing: CGFloat = 10.0

        // When
        let calculatedSize = mockViewModel.calculateItemSize(for: collectionViewWidth, spacing: spacing)

        // Then
        let expectedWidth = (collectionViewWidth - (spacing * 2)) / 2
        let expectedHeight = expectedWidth * 1.5

        XCTAssertEqual(calculatedSize.width, expectedWidth, "Cell width should be calculated correctly.")
        XCTAssertEqual(calculatedSize.height, expectedHeight, "Cell height should be calculated correctly.")
    }
}
