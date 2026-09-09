//
//  CharacterDetailViewUITests.swift
//  RickMortyAssignmentUITests
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import XCTest

final class CharacterDetailViewUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        app.terminate()
        super.tearDown()
    }
    
    // MARK: - Character Detail Favorite Workflow Test
    
    func testCharacterFavoriteAndNavigationWorkflow() {
        // 1. Wait for characters list to load
        let charactersNav = app.navigationBars["Characters"]
        XCTAssertTrue(charactersNav.waitForExistence(timeout: 15.0), "Characters navigation bar should exist")
        
        // 2. Find first character row - SwiftUI List rows have accessibility labels
        let allOtherElements = app.otherElements
        var tappedFirst = false
        for i in 0..<min(allOtherElements.count, 50) {
            let element = allOtherElements.element(boundBy: i)
            if element.isHittable && element.label.count > 0 && element.label.contains(",") {
                element.tap()
                tappedFirst = true
                Thread.sleep(forTimeInterval: 2.0)
                break
            }
        }
        XCTAssertTrue(tappedFirst, "Should tap first character")
        
        // 3. Verify detail view loaded - favorite button should exist
        let favoriteButton = app.buttons["favoriteButton"]
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 10.0), "Favorite button should exist")
        
        // 4. Tap favorite button
        favoriteButton.tap()
        Thread.sleep(forTimeInterval: 1.0)
        
        // 5. Go back
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backButton.exists, "Back button should exist")
        backButton.tap()
        Thread.sleep(forTimeInterval: 2.0)
        
        // 6. Verify back at list
        XCTAssertTrue(charactersNav.exists, "Should be back at characters list")
        
        // 7. Tap first character again
        let allElementsAgain = app.otherElements
        var tappedFirstAgain = false
        for i in 0..<min(allElementsAgain.count, 50) {
            let element = allElementsAgain.element(boundBy: i)
            if element.isHittable && element.label.count > 0 && element.label.contains(",") {
                element.tap()
                tappedFirstAgain = true
                Thread.sleep(forTimeInterval: 2.0)
                break
            }
        }
        XCTAssertTrue(tappedFirstAgain, "Should tap first character again")
        
        // 8. Verify detail view appears
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 10.0), "Favorite button should appear again")
    }
}

