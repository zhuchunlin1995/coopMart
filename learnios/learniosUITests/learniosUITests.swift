//
//  learniosUITests.swift
//  learniosUITests
//
//  Created by 万琳莉 on 01/03/2018.
//  Copyright © 2018 Linli. All rights reserved.
//

import XCTest
class learniosUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLogin() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let app = XCUIApplication()
        let emailTextField = app.textFields["Email Address: jd2920@columbia.edu"]
        if( emailTextField.exists == false){
            app.tabBars.buttons["My Profile"].tap()
            app.buttons["Log Out"].tap()
        }
        emailTextField.tap()
        
        let dbTool = DbTool.sharInstance
        let ap = dbTool.getOneValidAccount()
        emailTextField.typeText(ap.account)
        
        let passwordField = app.secureTextFields["Password"]
        passwordField.tap()
        passwordField.typeText(ap.password)
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .button)["Login"].tap()
        
    }
    
    func testRegister() {
        let app = XCUIApplication()
        
        let registerButton = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .button)["Register"]
        
        if(registerButton.exists == false){
            let profile = app.tabBars.buttons["My Profile"]
            if(profile.exists){
                profile.tap()
                app.buttons["Log Out"].tap()
            }
        }
        let ap = AccountPassword.generateOne()
        
        app/*@START_MENU_TOKEN@*/.buttons["Register"]/*[[".segmentedControls.buttons[\"Register\"]",".buttons[\"Register\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let nametextField = app.textFields["Name: John Dough"]
        nametextField.tap()
        nametextField.typeText("Tim Cook")
        
        let emailTextField = app.textFields["Email Address: jd2920@columbia.edu"]
        emailTextField.tap()
        emailTextField.typeText(ap.account)
        
        let passwordField = app.secureTextFields["Password"]
        passwordField.tap()
        passwordField.typeText(ap.password)
        registerButton.tap()
        
    }
    func testMarketListing() {
        
        let app = XCUIApplication()
        let emailTextField = app.textFields["Email Address: jd2920@columbia.edu"]
        if( emailTextField.exists){
            let dbTool = DbTool.sharInstance
            let ap = dbTool.getOneValidAccount()
        
            emailTextField.tap()
            emailTextField.typeText(ap.account)
            let passwordField = app.secureTextFields["Password"]
            passwordField.tap()
            passwordField.typeText(ap.password)
            app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .button)["Login"].tap()
        }
        
        app.tabBars.buttons["Market Listings"].tap()
        app.navigationBars["Market Listings"].buttons["CartButton"].tap()
    }
    func testMyListing() {
        
        
        let app = XCUIApplication()
        let emailTextField = app.textFields["Email Address: jd2920@columbia.edu"]
        if( emailTextField.exists){
            
            let dbTool = DbTool.sharInstance
            let ap = dbTool.getOneValidAccount()
            
            emailTextField.tap()
            emailTextField.typeText(ap.account)
            let passwordField = app.secureTextFields["Password"]
            passwordField.tap()
            passwordField.typeText(ap.password)
            app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .button)["Login"].tap()
        }
        
        app.tabBars.buttons["My Listings"].tap()
        //app.collectionViews.cells.otherElements.containing(.image, identifier:"01").element.tap()
        //app.navigationBars["My Listing"].buttons["My Listings"].tap()
        app.navigationBars["My Listings"].buttons["New"].tap()
        app.sheets.buttons["Use Existing"].tap()
    }
}


