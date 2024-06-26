//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by GiyaDev on 01.02.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    func testAuth() throws {
 
        
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("")
        webView.swipeUp()
        
        let passwordTexField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTexField.waitForExistence(timeout: 5))
        
        passwordTexField.tap()
        passwordTexField.typeText("")
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        print(app.debugDescription)
    }
    
    func testFeed() {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["like button tapped"].tap()
        sleep(2)
        cellToLike.buttons["like button tapped"].tap()
        sleep(2)
        
        let cellToZoom = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cellToZoom.tap()
        
        let imageView = app.images["zoomable image"]
        XCTAssertTrue(imageView.waitForExistence(timeout: 5), "Failed to find the zoomable image")
        
        // Производим зум
        imageView.pinch(withScale: 2.0, velocity: 1.0) // Например, увеличиваем в 2 раза
        
        sleep(2)
        
        let navBackButtonWhiteButton = app.buttons["nav back button white"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["Georgiy Dorgatov"].exists)
        XCTAssertTrue(app.staticTexts["@giya077"].exists)
        
        app.buttons["logout button"].tap()
        app.alerts["Выход"].buttons["Выход"].tap()
    }
}
