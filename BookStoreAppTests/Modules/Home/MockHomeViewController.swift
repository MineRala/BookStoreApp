//
//  MockHomeViewController.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 8.02.2025.
//

import Foundation
@testable import BookStoreApp

final class MockHomeViewController: HomeViewControllerInterface {

    // MARK: - Test Flags
    var configureNavigationBarCalled = false
    var configureCollectionViewCalled = false
    var configureActivityIndicatorCalled = false
    var collectionViewReloadDataCalled = false
    var collectionViewScrollCalled = false
    var isActivityIndicatorActiveCalled = false
    var setEmptyLabelVisibilityCalled = false
    var emptyLabelIsVisible = false
    
    // MARK: - Methods
    func configureNavigationBar() {
        configureNavigationBarCalled = true
    }

    func configureCollectionView() {
        configureCollectionViewCalled = true
    }

    func configureActivityIndicator() {
        configureActivityIndicatorCalled = true
    }

    func setEmptyLabelVisibility(isVisible: Bool) {
        setEmptyLabelVisibilityCalled = true
        emptyLabelIsVisible = isVisible
    }

    func collectionViewReloadData() {
        collectionViewReloadDataCalled = true
    }

    func collectionViewScroll(index: IndexPath) {
        collectionViewScrollCalled = true
    }

    func isActivityIndicatorActive(isActive: Bool) {
        isActivityIndicatorActiveCalled = true
    }
}
