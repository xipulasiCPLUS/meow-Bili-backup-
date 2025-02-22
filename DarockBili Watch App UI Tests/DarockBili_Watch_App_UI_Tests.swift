//
//  DarockBili_Watch_App_UI_Tests.swift
//  DarockBili Watch App UI Tests
//
//  Created by WindowsMEMZ on 2023/7/27.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the MeowBili open source project
//
// Copyright (c) 2023 Darock Studio and the MeowBili project authors
// Licensed under GNU General Public License v3
//
// See https://darock.top/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

import XCTest

final class DarockBili_Watch_App_UI_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAppMain() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        sleep(2)
        takeScreenshot(of: app, named: "Launch")
        // In main tabview first page (suggestions)
        app.buttons["SuggestVideo"].firstMatch.tap()
        sleep(1)
        takeScreenshot(of: app, named: "RMVideo")
        app.swipeUp()
        sleep(1)
        takeScreenshot(of: app, named: "RMVideoP2")
        app.swipeUp()
        sleep(1)
        takeScreenshot(of: app, named: "RMVideoP2-Down")
        app.swipeLeft()
        sleep(5)
        takeScreenshot(of: app, named: "RMVideoComments")
        app.navigationBars.buttons.element(boundBy: 0).tap()
        sleep(1)
        // Backed to suggestions view
        app.navigationBars.buttons["SearchButton"].firstMatch.tap()
        sleep(1)
        if app.buttons["SearchDebugButton"].exists {
            app.buttons["SearchDebugButton"].tap()
            sleep(5)
            takeScreenshot(of: app, named: "DebugSearch")
            print(app.debugDescription)
            app.buttons["关闭"].firstMatch.tap()
            sleep(1)
        }
        app.buttons["关闭"].firstMatch.tap()
        sleep(1)
        // Backed to suggestions view
        if app.buttons["Debug"].exists {
            app.buttons["Debug"].firstMatch.tap()
            sleep(1)
            takeScreenshot(of: app, named: "MainDebugged")
        }
        app.otherElements["MainTabView"].swipeLeft()
        sleep(1)
        takeScreenshot(of: app, named: "PersonalCenter")
        app.buttons["AppSettingsButton"].firstMatch.tap()
        sleep(1)
        takeScreenshot(of: app, named: "SettingsMain")
        app.buttons["以太网"].firstMatch.tap()
        sleep(1)
        takeScreenshot(of: app, named: "EthernetSetting")
        app.buttons["网络检查"].firstMatch.tap()
        sleep(2)
        takeScreenshot(of: app, named: "NetworkFix1")
        sleep(5)
        takeScreenshot(of: app, named: "NetworkFix2")
        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

var screenshotCount = 1

extension XCTestCase {
    /// Take a screenshot of a given app and add it to the test attachements.
    /// - Parameters:
    ///   - app: The app to take a screenshot of.
    ///   - name: The name of the screenshot.
    func takeScreenshot(of app: XCUIApplication, named name: String) {
        let screenshot = app.windows.firstMatch.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        #if os(iOS)
        let name = "Screenshot-\(screenshotCount)-\(name)-\(UIDevice.current.name).png"
        #else
        let name = "Screenshot-\(screenshotCount)-\(name)-watchOS.png"
        #endif
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
        screenshotCount += 1
    }
}
