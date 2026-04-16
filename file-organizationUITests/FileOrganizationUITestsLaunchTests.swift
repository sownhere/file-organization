//
//  FileOrganizationUITestsLaunchTests.swift
//  file-organizationUITests
//
//  Created by SownFrenky on 3/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

import XCTest

final class FileOrganizationUITestsLaunchTests: XCTestCase {

    override static var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.tabBars.buttons["Recents"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Today"].waitForExistence(timeout: 5))

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
