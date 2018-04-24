//
//  LoginViewControllerTests.swift
//  learniosTests
//
//  Created by zyy on 3/29/18.
//
import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import XCTest
@testable import learnios
class LoginControllerTests: XCTestCase {
    var systemUnderTest: LoginController!
    
    override func setUp() {
        
        super.setUp()
        
        //get the ViewController we want to test from the storyboard (note the identifier is the id explicitly set in the identity inspector)
        systemUnderTest = LoginController()
        //load view hierarchy
        _ = systemUnderTest.view
    }
    
    override func tearDown() {
        
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSUT_CanBeInstantiated() {
        XCTAssertNotNil(systemUnderTest)
        XCTAssertNotNil(systemUnderTest.emailTextField)
        XCTAssertNotNil(systemUnderTest.passwordTextField)
        XCTAssertNotNil(systemUnderTest.loginRegisterButton)
        XCTAssertNotNil(systemUnderTest.nameTextField)
    }
    func testSUT_TestLogin_WhenInputIsEmpty(){
        systemUnderTest.emailTextField.text = ""
        systemUnderTest.passwordTextField.text = ""
        let expectedReturn = "fail"
        
        let ex = expectation(description: "")
        let timeout = 15 as TimeInterval
        _ = systemUnderTest.handleLogin(test: false) { (ret) in
            ex.fulfill()
            let  actualReturn = ret
            XCTAssertEqual(expectedReturn, actualReturn)
        }
        waitForExpectations(timeout: timeout, handler: nil)
        
    }
    func testSUT_TestLogin_VaidInput(){
        
        let dbTool = DbTool.sharInstance
        let ap = dbTool.getOneValidAccount()
        print("account:\(ap.account),password:\(ap.password)")
        systemUnderTest.emailTextField.text = ap.account;
        systemUnderTest.passwordTextField.text = ap.password;
        let expectedReturn = "success";
        
        let ex = expectation(description: "")
        let timeout = 15 as TimeInterval
        
        _ = systemUnderTest.handleLogin(test: false) { (ret) in
            let  actualReturn = ret
            ex.fulfill()
            XCTAssertEqual(expectedReturn, actualReturn)
        }
        waitForExpectations(timeout: timeout, handler: nil)
        
    }
    
    func testSUT_TestRegister_InvalidEmail(){
        systemUnderTest.emailTextField.text = ""
        systemUnderTest.passwordTextField.text = ""
        let expectedReturn = "failure"
        
        let ex = expectation(description: "")
        let timeout = 15 as TimeInterval
        
        _ = systemUnderTest.handleRegister(test: false) { (ret) in
            let  actualReturn = ret
            ex.fulfill()
            XCTAssertEqual(expectedReturn, actualReturn)
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }
    func testSUT_TestRegister_ValidEmail(){
        // you need change a gmail if it test fail,because this gmail was registed
        
        let ap = AccountPassword.generateOne()
        systemUnderTest.emailTextField.text = ap.account
        systemUnderTest.passwordTextField.text = ap.password
        
        let expectedReturn = "success"
        
        let ex = expectation(description: "")
        let timeout = 15 as TimeInterval
        
        _ = systemUnderTest.handleRegister(test: false) { (ret) in
            let  actualReturn = ret
            ex.fulfill()
            XCTAssertEqual(expectedReturn, actualReturn)
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }
    func testSUT_TestRegister_InValidPassordword(){
        
        let ap = AccountPassword.generateOne()
        systemUnderTest.emailTextField.text = ap.account
        systemUnderTest.passwordTextField.text = "111"
        let expectedReturn = "failure"
        
        let ex = expectation(description: "")
        let timeout = 15 as TimeInterval
        
        _ = systemUnderTest.handleRegister(test: false) { (ret) in
            let  actualReturn = ret
            ex.fulfill()
            XCTAssertEqual(expectedReturn, actualReturn)
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testSUT_TestRegister_DuplicationOfRegistration(){
        
        let dbTool = DbTool.sharInstance
        let ap = dbTool.getOneValidAccount()
        systemUnderTest.emailTextField.text = ap.account
        systemUnderTest.passwordTextField.text = ap.password
        let expectedReturn = "failure"
        
        let ex = expectation(description: "")
        let timeout = 15 as TimeInterval
        
        _ = systemUnderTest.handleRegister(test: false) { (ret) in
            let  actualReturn = ret
            ex.fulfill()
            XCTAssertEqual(expectedReturn, actualReturn)
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    
    
}

