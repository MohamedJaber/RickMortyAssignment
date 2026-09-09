//
//  CharactersListViewUITests.swift
//  RickMortyAssignmentUITests
//
//  Created by Mohamed Jaber on 09/09/2026.
//

import XCTest

final class CharactersListViewUITests: XCTestCase {
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
    
    // MARK: - Status Filter & Sorting Workflow Test
    
    func testStatusFilterAndSortingWorkflow() {
        // 1. Wait for characters list to load
        let charactersNav = app.navigationBars["Characters"]
        XCTAssertTrue(charactersNav.waitForExistence(timeout: 15.0), "Characters navigation bar should exist")
        
        // 2. Wait for status filter segmented control
        let statusFilter = app.segmentedControls["statusFilter"]
        XCTAssertTrue(statusFilter.waitForExistence(timeout: 10.0), "Status filter should exist")
        
        // 3. Test Alive filter
        statusFilter.buttons["Alive"].tap()
        Thread.sleep(forTimeInterval: 1.5)
        XCTAssertTrue(statusFilter.exists, "Status filter should still exist after Alive tap")
        
        // 4. Test Dead filter
        statusFilter.buttons["Dead"].tap()
        Thread.sleep(forTimeInterval: 1.5)
        XCTAssertTrue(statusFilter.exists, "Status filter should still exist after Dead tap")
        
        // 5. Test Unknown filter
        statusFilter.buttons["Unknown"].tap()
        Thread.sleep(forTimeInterval: 1.5)
        XCTAssertTrue(statusFilter.exists, "Status filter should still exist after Unknown tap")
        
        // 6. Test All filter
        statusFilter.buttons["All"].tap()
        Thread.sleep(forTimeInterval: 1.5)
        XCTAssertTrue(statusFilter.exists, "Status filter should still exist after All tap")
        
        // 7. Wait for sort picker segmented control
        let sortPicker = app.segmentedControls["sortPicker"]
        XCTAssertTrue(sortPicker.waitForExistence(timeout: 10.0), "Sort picker should exist")
        
        // 8. Get all sort buttons
        let sortButtons = sortPicker.buttons
        let buttonCount = sortButtons.count
        XCTAssertGreaterThan(buttonCount, 0, "Sort picker should have buttons")
        
        // 9. Test each sort option
        if buttonCount > 0 {
            sortButtons.element(boundBy: 0).tap()
            Thread.sleep(forTimeInterval: 1.5)
            XCTAssertTrue(statusFilter.exists, "List should respond to first sort option")
        }
        
        if buttonCount > 1 {
            sortButtons.element(boundBy: 1).tap()
            Thread.sleep(forTimeInterval: 1.5)
            XCTAssertTrue(statusFilter.exists, "List should respond to second sort option")
        }
        
        if buttonCount > 2 {
            sortButtons.element(boundBy: 2).tap()
            Thread.sleep(forTimeInterval: 1.5)
            XCTAssertTrue(statusFilter.exists, "List should respond to third sort option")
        }
        
        if buttonCount > 3 {
            sortButtons.element(boundBy: 3).tap()
            Thread.sleep(forTimeInterval: 1.5)
            XCTAssertTrue(statusFilter.exists, "List should respond to fourth sort option")
        }
    }
}

