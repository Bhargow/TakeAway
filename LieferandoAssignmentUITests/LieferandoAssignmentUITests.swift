//
//  LieferandoAssignmentUITests.swift
//  LieferandoAssignmentUITests
//
//  Created by rao on 31/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import XCTest

enum Identifiers: String {
    case restautantsTableview = "RestautantsTableview"
    case restaurantTableHeader = "RestaurantTableHeader"
    case filterButton = "FilterButton"
    case filterTableview = "FilterTableview"
    case starRatingView = "StarRatingView"
    case closeBtn = "icn close"
    case deliveryCostShowAll = "DeliveryCostShowAll"
    case minOrderShowAll = "MinOrderShowAll"
    case ratingFilterCell = "RatingFilterCell"
    case addOrRemoveFavButton = "leading0"
    case deliveryCostFree = "DeliveryCostFree"
    case minOrderLessThan15 = "MinOrderLessThan15"
}

class LieferandoAssignmentUITests: XCTestCase {

    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAllScenarios() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let filtertableviewTable = app.tables[Identifiers.filterTableview.rawValue]
        let restaurantsTableview = app.tables[Identifiers.restautantsTableview.rawValue]
            
        //Regular scroll
        restaurantsTableview.swipeUp()
        restaurantsTableview.swipeDown()

        let headerView = restaurantsTableview.otherElements[Identifiers.restaurantTableHeader.rawValue]
        var firstCell = restaurantsTableview.cells.element(boundBy: 0)
        var lastCell = restaurantsTableview.cells.element(boundBy: restaurantsTableview.cells.count - 1)
        
        //Test inititial values are set right based on the open status of the restaurants
        XCTAssertTrue(headerView.staticTexts.element(boundBy: 0).label == "Swipe right to add to favourites")
        XCTAssertTrue(firstCell.staticTexts.element(boundBy: 0).label == "Tanoshii Sushi")
        XCTAssertTrue(lastCell.staticTexts.element(boundBy: 0).label == "Zenzai Sushi")
        
        
        //Navigating to filter view controller
        let filterButton = restaurantsTableview.otherElements[Identifiers.restaurantTableHeader.rawValue  ].buttons[Identifiers.filterButton.rawValue]
        filterButton.tap()
        filtertableviewTable.cells[Identifiers.deliveryCostFree.rawValue].tap()
        filtertableviewTable.cells[Identifiers.minOrderLessThan15.rawValue ].tap()
        
        let starRatingView = filtertableviewTable.cells.element(matching: .cell, identifier: Identifiers.ratingFilterCell.rawValue).otherElements[Identifiers.starRatingView.rawValue]
        starRatingView.swipeRight()
        
        let closeFilterButton = filtertableviewTable.buttons[Identifiers.closeBtn.rawValue]
        closeFilterButton.tap()
        
        firstCell = restaurantsTableview.cells.element(boundBy: 0)
        lastCell = restaurantsTableview.cells.element(boundBy: restaurantsTableview.cells.count - 1)
        
        //Test restaurant list viewcontroller are set right based on the set filters
        XCTAssertTrue(headerView.staticTexts.element(boundBy: 0).label == "🛵 Free, 💶 Max 15 €, ⭐️ greater than or equal to 1.0")
        XCTAssertTrue(firstCell.staticTexts.element(boundBy: 0).label == "Sushi One")
        XCTAssertTrue(lastCell.staticTexts.element(boundBy: 0).label == "Mama Mia")
        
        //Add to favourites
        firstCell.swipeRight()
        firstCell.buttons[Identifiers.addOrRemoveFavButton.rawValue].tap()
        filterButton.tap()
        
        //Reset filters except for rating
        filtertableviewTable.cells[Identifiers.deliveryCostShowAll.rawValue].tap()
        filtertableviewTable.cells[Identifiers.minOrderShowAll.rawValue].tap()
        closeFilterButton.tap()
        
        firstCell = restaurantsTableview.cells.element(boundBy: 0)
        lastCell = restaurantsTableview.cells.element(boundBy: restaurantsTableview.cells.count - 1)
        
        //Test restaurant list viewcontroller are set right after reseting filters
        XCTAssertTrue(headerView.staticTexts.element(boundBy: 0).label ==  "⭐️ greater than or equal to 1.0")
        XCTAssertTrue(firstCell.staticTexts.element(boundBy: 0).label == "Tanoshii Sushi")
        XCTAssertTrue(lastCell.staticTexts.element(boundBy: 0).label == "Zenzai Sushi")
        
        //Test Favourites restaurant list viewcontroller are set right after reseting filters
        headerView.buttons["Favourites"].tap()
        firstCell = restaurantsTableview.cells.element(boundBy: 0)
        firstCell.swipeRight()
        firstCell.buttons[Identifiers.addOrRemoveFavButton.rawValue].tap()

        XCTAssertTrue(restaurantsTableview.cells.count == 0)
        headerView.buttons["Dashboard"].tap()
    }
}
