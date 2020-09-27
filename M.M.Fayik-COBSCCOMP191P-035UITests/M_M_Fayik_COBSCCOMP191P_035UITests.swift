//
//  M_M_Fayik_COBSCCOMP191P_035UITests.swift
//  M.M.Fayik-COBSCCOMP191P-035UITests
//
//  Created by Fayik Muzammil on 8/22/20.
//  Copyright © 2020 Fayik Muzammil. All rights reserved.
//

import XCTest

class M_M_Fayik_COBSCCOMP191P_035UITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testValidLoginSuccess() {
        
        let email = "A@gmail.com"
        let password = "iphone123"
        
        let app = XCUIApplication()
        app.launch()
        
        app.tabBars.buttons["UPDATE"].tap()
        
        let txtEmail = app.textFields["Email"]
        XCTAssertTrue(txtEmail.exists)
        txtEmail.tap()
        txtEmail.typeText(email)
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordSecureTextField.exists)
        passwordSecureTextField.tap()
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(password)
        
        let loginButton = app.buttons["L O G I N"]
        loginButton.tap()
        
        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
