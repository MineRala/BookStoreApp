//
//  AppEnvironment.swift
//  BookStoreApp
//
//  Created by Mine Rala on 7.02.2025.
//

import Foundation

final class AppEnvironment {
    static var isTesting: Bool {
        return ProcessInfo.processInfo.processName == "xctest"
    }
}
