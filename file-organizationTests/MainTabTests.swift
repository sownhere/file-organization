//
//  MainTabTests.swift
//  file-organizationTests
//
//  Created by SownFrenky on 3/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

@preconcurrency import ComposableArchitecture
@testable import file_organization
import XCTest

@MainActor
final class MainTabTests: XCTestCase {
    func testSelectingAnotherTabUpdatesSelectedTab() async {
        let store = TestStore(initialState: MainTab.State()) {
            MainTab()
        }

        XCTAssertEqual(store.state.selectedTab, .recents)

        await store.send(.selectedTabChanged(.myFiles)) {
            $0.selectedTab = .myFiles
        }
    }

    func testSelectingCurrentTabDoesNothing() async {
        let store = TestStore(initialState: MainTab.State()) {
            MainTab()
        }

        XCTAssertEqual(store.state.selectedTab, .recents)
        await store.send(.selectedTabChanged(.recents))
    }
}
