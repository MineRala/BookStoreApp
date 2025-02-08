//
//  MockSearchViewController.swift
//  BookStoreAppTests
//
//  Created by Mine Rala on 7.02.2025.
//

import Foundation
@testable import BookStoreApp

final class MockSearchViewController: SearchViewControllerInterface {
    var isConfigureUICalled = false
    var isSetEmptyLabelVisibilityCalled = false
    var isEmptyLabelVisible = false
    var isTableViewReloadCalled = false
    var isActivityIndicatorHiddenCalled = false

    func configureUI() {
        isConfigureUICalled = true
    }

    func setEmptyLabelVisibility(isVisible: Bool) {
        isSetEmptyLabelVisibilityCalled = true
        isEmptyLabelVisible = isVisible
    }

    func tableViewReload() {
        isTableViewReloadCalled = true
    }

    func activityIndicatorHidden() {
        isActivityIndicatorHiddenCalled = true
    }
}
