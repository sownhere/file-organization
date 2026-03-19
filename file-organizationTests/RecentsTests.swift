//
//  RecentsTests.swift
//  file-organizationTests
//
//  Created by SownFrenky on 3/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

@preconcurrency import ComposableArchitecture
@testable import file_organization
import XCTest

@MainActor
final class RecentsTests: XCTestCase {
    func testToggleViewModeFlipsGridAndList() async {
        var state = Recents.State()
        state.viewMode = .grid

        let store = TestStore(initialState: state) {
            Recents()
        }

        await store.send(.toggleViewMode) {
            $0.viewMode = .list
        }

        await store.send(.toggleViewMode) {
            $0.viewMode = .grid
        }
    }

    func testToggleSelectionModeClearsSelectedFilesWhenTurningOff() async {
        let fileID = UUID()

        var state = Recents.State()
        state.isSelectionMode = false
        state.selectedFileIDs = Set([fileID])

        let store = TestStore(initialState: state) {
            Recents()
        }

        await store.send(.toggleSelectionMode) {
            $0.isSelectionMode = true
            $0.selectedFileIDs = Set([fileID])
        }

        await store.send(.toggleSelectionMode) {
            $0.isSelectionMode = false
            $0.selectedFileIDs = []
        }
    }

    func testToggleFileSelectionAddsAndRemovesFileID() async {
        let fileID = UUID()

        let store = TestStore(initialState: Recents.State()) {
            Recents()
        }

        await store.send(.toggleFileSelection(fileID)) {
            $0.selectedFileIDs = Set([fileID])
        }

        await store.send(.toggleFileSelection(fileID)) {
            $0.selectedFileIDs = []
        }
    }
}
