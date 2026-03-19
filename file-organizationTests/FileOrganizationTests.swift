//
//  RootTests.swift
//  file-organizationTests
//
//  Created by SownFrenky on 3/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

@preconcurrency import ComposableArchitecture
@testable import file_organization
import XCTest

@MainActor
final class RootTests: XCTestCase {
    func testDidFinishLaunchingRoutesToMainNavigationRecents() async {
        let store = TestStore(initialState: Root.State()) {
            Root()
        }

        XCTAssertNil(store.state.destination)
        await store.send(.appDelegate(.didFinishLaunching(fromNotificationType: nil))) {
            $0.destination = .mainNavigation(
                MainNavigation.State(mainTab: MainTab.State())
            )
        }
    }

    // func testDidBecomeActiveRequestsReloadWithoutChangingDestination() async {
    //     let store = TestStore(initialState: Root.State()) {
    //         Root()
    //     }

    //     XCTAssertNil(store.state.destination)

    //     await store.send(.appDelegate(.didBecomeActive))
    //     await store.receive(\.destination.presented.mainNavigation.mainTab.reloadAll)

    //     XCTAssertNil(store.state.destination)
    // }

}
