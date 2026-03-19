//
//  FileOrganizationUITests.swift
//  file-organizationUITests
//
//  Created by SownFrenky on 3/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

import XCTest

final class FileOrganizationUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testLaunchShowsRecents() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.tabBars.buttons["Recents"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Today"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["File1.pdf"].waitForExistence(timeout: 5))
    }

    func testSwitchTabsShowsExpectedContent() throws {
        let app = XCUIApplication()
        app.launch()

        tapTab(app, "My Files")
        XCTAssertTrue(app.staticTexts["My Files"].waitForExistence(timeout: 5))

        tapTab(app, "Action")
        XCTAssertTrue(app.staticTexts["Action"].waitForExistence(timeout: 5))

        tapTab(app, "Setting")
        XCTAssertTrue(app.staticTexts["Setting"].waitForExistence(timeout: 5))
    }

    private func tapTab(_ app: XCUIApplication, _ title: String) {
        if app.tabBars.buttons[title].firstMatch.exists {
            app.tabBars.buttons[title].firstMatch.tap()
            return
        }

        if app.buttons[title].firstMatch.exists {
            app.buttons[title].firstMatch.tap()
            return
        }

        XCTFail("Tab '\(title)' not found")
    }

    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
