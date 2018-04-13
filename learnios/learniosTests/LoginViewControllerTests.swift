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
        let actualReturn = systemUnderTest.handleLogin(test: false)
        XCTAssertEqual(expectedReturn, actualReturn)
        
    }
    func testSUT_TestLogin_VaidInput(){
    systemUnderTest.emailTextField.text = "jya2013jy@gmail.com"
    systemUnderTest.passwordTextField.text = "123456"
    let expectedReturn = "success"
    let actualReturn = systemUnderTest.handleLogin(test: false)
    XCTAssertEqual(expectedReturn, actualReturn)
    
    }

    func testSUT_TestRegister_InvalidEmail(){
        systemUnderTest.emailTextField.text = ""
        systemUnderTest.passwordTextField.text = ""
        let expectedReturn = ""
        let actualReturn = systemUnderTest.handleRegister(test: false)
        XCTAssertEqual(expectedReturn, actualReturn)
    }
    func testSUT_TestRegister_ValidEmail(){
        systemUnderTest.emailTextField.text = "zhuyingying2@gmail.com"
        systemUnderTest.passwordTextField.text = "123456"
        let expectedReturn = ""
        let actualReturn = systemUnderTest.handleRegister(test: false)
        XCTAssertEqual(expectedReturn, actualReturn)
    }
    func testSUT_TestRegister_Validpassord(){
        systemUnderTest.emailTextField.text = "zhuyingying2@gmail.com"
        systemUnderTest.passwordTextField.text = "1234"
        let expectedReturn = "Fail"
        let actualReturn = systemUnderTest.handleRegister(test: false)
        XCTAssertEqual(expectedReturn, actualReturn)
}



}
