//
//  LFRestaurantCellViewModelTests.swift
//  LieferandoAssignmentTests
//
//  Created by rao on 03/02/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import XCTest

class LFRestaurantCellViewModelTests: XCTestCase {

    var restaurantCellViewModelMock: LFRestaurantCellViewModelMock!
    var jsonDecoder: JSONDecoder = JSONDecoder()
    
    var mockJsonDict:[String : Any] = [
    "id": "2", "name": "Tandoori Express", "status": "closed",
    "sortingValues": ["bestMatch": 1.0, "newest": 266.0, "ratingAverage": 4.5, "distance": 2308, "popularity": 123.0, "averageProductPrice": 1146, "deliveryCosts": 150,"minCost": 1300]]
    
    var mockSecondMockDataJsonDict:[String : Any] = [
    "id": "3", "name": "Tandoori Express", "status": "closed",
    "sortingValues": ["bestMatch": 1.0, "newest": 266.0, "ratingAverage": 4.5, "distance": 2308, "popularity": 123.0, "averageProductPrice": 1146, "deliveryCosts": 150,"minCost": 1300]]
    
    override func setUp() {
        let jsonData = try? JSONSerialization.data(withJSONObject: mockJsonDict, options: .prettyPrinted)
        let restaurantModel = try? jsonDecoder.decode(LFRestaurantModel.self, from: jsonData!)
        restaurantCellViewModelMock = LFRestaurantCellViewModelMock(restaurantModel: restaurantModel!)
        UserDefaults.standard.removeObject(forKey: "favouritesList")
    }

    func testEverythingWithCorrectData() {
        XCTAssertTrue(restaurantCellViewModelMock.setValuesMock())
        XCTAssertFalse(restaurantCellViewModelMock.checkIfExistsInFavouritesMock())
        XCTAssertTrue(restaurantCellViewModelMock.addOrRemoveFromFavouritesMock())
        XCTAssertTrue(restaurantCellViewModelMock.checkIfExistsInFavouritesMock())
        XCTAssertFalse(restaurantCellViewModelMock.addOrRemoveFromFavouritesMock())
        
        let jsonData = try? JSONSerialization.data(withJSONObject: mockSecondMockDataJsonDict, options: .prettyPrinted)
        let restaurantModel = try? jsonDecoder.decode(LFRestaurantModel.self, from: jsonData!)
        restaurantCellViewModelMock = LFRestaurantCellViewModelMock(restaurantModel: restaurantModel!)
        XCTAssertFalse(restaurantCellViewModelMock.checkIfExistsInFavouritesMock())
        XCTAssertTrue(restaurantCellViewModelMock.addOrRemoveFromFavouritesMock())
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

class LFRestaurantCellViewModelMock: LFRestaurantCellViewModel {
    
    func setValuesMock() -> Bool {
        var testResult: Bool = false
        testResult = self.name == "Tandoori Express"
        testResult = self.ratingValue == 4.5
        testResult = self.deliveryFee == "🛵 1.5 €"
        testResult = self.minimumCost == "💶 Min. 1.3 €"
        testResult = self.status == "⏰ Closed"
        return testResult
    }
    
    func checkIfExistsInFavouritesMock() -> Bool {
        return self.isFavouriteRestaurant == true
    }
    
    func addOrRemoveFromFavouritesMock() -> Bool {
        self.addOrRemoveFromFavourites()
        return self.isFavouriteRestaurant == true
    }
}
