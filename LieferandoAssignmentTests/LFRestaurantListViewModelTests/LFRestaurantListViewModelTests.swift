//
//  LFRestaurantListViewModelTests.swift
//  LieferandoAssignmentTests
//
//  Created by rao on 02/02/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import XCTest

class LFRestaurantListViewModelTests: XCTestCase {

    var restaurantListViewModelMock: LFRestaurantListViewModelMock!
    var restaurantListProvider: LFRestaurantListProvider!
    var bundle: Bundle!
    var cache: NSCache<NSString, NSArray>!
    
    override func setUp() {
        bundle = Bundle(for: type(of: self))
        cache = NSCache.init()
        restaurantListProvider = LFRestaurantListProvider(bundle: bundle, cache: cache)
        restaurantListViewModelMock = LFRestaurantListViewModelMock(restaurantListProvider: restaurantListProvider)
        UserDefaults.standard.removeObject(forKey: "favouritesList")
    }

    override func tearDown() {
        bundle = nil
        cache = nil
        restaurantListProvider = nil
        restaurantListViewModelMock = nil
    }

    func testRestaurantListViewModelMasterList() {
        XCTAssertTrue(restaurantListViewModelMock.fetchMasterListMock())
    }

    func testRestaurantListViewModelMasterListFail() {
        XCTAssertTrue(restaurantListViewModelMock.fetchMasterListFailMock())
    }
    
    func testRestaurantListViewModelFilterByTextPass() {
        XCTAssertTrue(restaurantListViewModelMock.filterRestaurantsByTextPass())
    }
    
    func testRestaurantListViewModelFilterWithEmptySting() {
        XCTAssertTrue(restaurantListViewModelMock.filterRestaurantsByTextEmptyString())
    }
    
    func testRestaurantListViewModelFilterByTextFail() {
        XCTAssertFalse(restaurantListViewModelMock.filterRestaurantsByTextFail())
    }
    
    func testRestaurantListViewModelFilterByValuesPass() {
        XCTAssertTrue(restaurantListViewModelMock.filterAndSortRestaurantsWithFilterValuesMockPass())
    }
    
    func testRestaurantListViewModelFilterByValuesFail() {
        XCTAssertFalse(restaurantListViewModelMock.filterAndSortRestaurantsWithFilterValuesMockFail())
    }
    
    func testFetchFavouriteRestaurantsMock() {
        XCTAssert(restaurantListViewModelMock.fetchFavouriteRestaurantsMock())
    }
    
    func testGetFilterStringMockPass() {
        XCTAssertTrue(restaurantListViewModelMock.getFilterStringMockPass())
    }
    
    func testGetFilterStringMockFail() {
        XCTAssertFalse(restaurantListViewModelMock.getFilterStringMockFail())
    }
    
    func testSortedRestaurantArrayPass() {
        XCTAssertTrue(restaurantListViewModelMock.getSortedRestaurantArrayPass())
    }
    
    func testSortedRestaurantArrayFail() {
        XCTAssertFalse(restaurantListViewModelMock.getSortedRestaurantArrayFail())
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

class LFRestaurantListViewModelMock: LFRestaurantListViewModel {
    
    var mockJsonDict:[String : Any] = [
    "id": "2", "name": "Tandoori Express", "status": "closed",
    "sortingValues": ["bestMatch": 1.0, "newest": 266.0, "ratingAverage": 4.5, "distance": 2308, "popularity": 123.0, "averageProductPrice": 1146, "deliveryCosts": 150,"minCost": 1300]]
    
    func fetchMasterListMock() -> Bool {
        self.fetchMasterList()
        return self.masterRestaurantList.count > 0
    }
    
    func fetchMasterListFailMock() -> Bool {
        self.restaurantListProvider = LFRestaurantListProvider(bundle: Bundle())
        self.fetchMasterList()
        return self.masterRestaurantList.count == 0
    }
    
    func filterRestaurantsByTextPass() -> Bool {
        self.fetchMasterList()
        self.filterRestaurants(for: "sushi")
        var testResult: Bool = false
        for restaurant in self.restaurantList {
            testResult = restaurant.name.lowercased().contains("sushi")
        }
        return testResult
    }
    
    func filterRestaurantsByTextEmptyString() -> Bool {
        self.fetchMasterList()
        self.filterRestaurants(for: "")
        return restaurantList.count == masterRestaurantList.count
    }
    
    func filterRestaurantsByTextFail() -> Bool {
        self.fetchMasterList()
        self.filterRestaurants(for: "sushi")
        var testResult: Bool = false
        for restaurant in self.restaurantList {
            testResult = restaurant.name.lowercased().contains("indian")
        }
        return testResult
    }
    
    func filterAndSortRestaurantsWithFilterValuesMockPass() -> Bool {
        self.fetchMasterList()
        
        self.deliveryFeeFilter = .lessThanOneEuro
        self.minCostFilter = .tenEurosOrLess
        self.ratingFilter = 2.0

        self.filterRestaurants()
        var testResult: Bool = false
        for restaurant in self.restaurantList {
            testResult = restaurant.sortingValues.deliveryCosts < 100 && restaurant.sortingValues.minCost <= 1000 && restaurant.sortingValues.ratingAverage > 2.0
        }
        return testResult
    }
    
    func fetchFavouriteRestaurantsMock() -> Bool {
        var testResult: Bool = false
        self.filteringForFavourites = true
        testResult = self.restaurantList.count == 0
        
        UserDefaults.standard.set([getDataModelToBeAdded()], forKey: "favouritesList")
        self.fetchFavouriteRestaurants()
        testResult = self.restaurantList.count == 1
        
        UserDefaults.standard.set([], forKey: "favouritesList")
        self.fetchFavouriteRestaurants()
        testResult = self.restaurantList.count == 0
        
        UserDefaults.standard.set([Data()], forKey: "favouritesList")
        self.fetchFavouriteRestaurants()
        testResult = self.restaurantList.count == 0
        
        return testResult
    }
    
    func getDataModelToBeAdded() -> Data? {
        if let restaurantData = try? JSONSerialization.data(withJSONObject: mockJsonDict, options: .prettyPrinted) {
            if let restaurantModel = try? JSONDecoder().decode(LFRestaurantModel.self, from: restaurantData) {
                if let encoded = try? JSONEncoder().encode(restaurantModel) {
                    return encoded
                }
            }
        }
        return Data()
    }
    
    func filterAndSortRestaurantsWithFilterValuesMockFail() -> Bool {
        self.fetchMasterList()
        
        self.deliveryFeeFilter = .lessThanOneEuro
        self.minCostFilter = .tenEurosOrLess
        self.ratingFilter = 2.0
        
        self.filterRestaurants()
        var testResult: Bool = false
        for restaurant in self.restaurantList {
            testResult = restaurant.sortingValues.deliveryCosts < 200 && restaurant.sortingValues.minCost < 1000 && restaurant.sortingValues.ratingAverage > 1.0
        }
        return testResult
    }
    
    func getFilterStringMockPass() -> Bool {
        var testResult: Bool = false

        self.deliveryFeeFilter = .free
        self.minCostFilter = .tenEurosOrLess
        self.ratingFilter = 1.0
        testResult = self.getFilterString() == "🛵 Free, 💶 Max 10 €, ⭐️ greater than or equal to 1.0"
        
        self.deliveryFeeFilter = .free
        self.minCostFilter = .fifteenEurosOrLess
        self.ratingFilter = 1.0
        testResult = self.getFilterString() == "🛵 Free, 💶 Max 15 €, ⭐️ greater than or equal to 1.0"
        
        self.deliveryFeeFilter = .free
        self.minCostFilter = .showAll
        self.ratingFilter = 1.0
        testResult = self.getFilterString() == "🛵 Free, ⭐️ greater than or equal to 1.0"
        
        self.deliveryFeeFilter = .showAll
        self.minCostFilter = .showAll
        self.ratingFilter = 1.0
        testResult = self.getFilterString() == "⭐️ greater than or equal to 1.0"
        
        self.deliveryFeeFilter = .lessThanOneEuro
        self.minCostFilter = .showAll
        self.ratingFilter = 1.0
        testResult = self.getFilterString() == "🛵 Less than 1 €, ⭐️ greater than or equal to 1.0"
        
        self.deliveryFeeFilter = .lessThanTwoPointFiveEuro
        self.minCostFilter = .showAll
        self.ratingFilter = 1.0
        testResult = self.getFilterString() == "🛵 Less than 2.5 €, ⭐️ greater than or equal to 1.0"
        
        self.deliveryFeeFilter = .showAll
        self.minCostFilter = .tenEurosOrLess
        self.ratingFilter = 1.0
        testResult = self.getFilterString() == "💶 Max 10 €, ⭐️ greater than or equal to 1.0"
        
        self.deliveryFeeFilter = .showAll
        self.minCostFilter = .fifteenEurosOrLess
        self.ratingFilter = 1.0
        testResult = self.getFilterString() == "💶 Max 15 €, ⭐️ greater than or equal to 1.0"
    
        return testResult
    }
    
    func getFilterStringMockFail() -> Bool {
        self.deliveryFeeFilter = .lessThanOneEuro
        self.minCostFilter = .tenEurosOrLess
        self.ratingFilter = 3.0
        return(self.getFilterString() == "🛵 Less than 1 €, ⭐️ greater than or equal to 2.0")
    }
    
    func getSortedRestaurantArrayPass() -> Bool {
        self.fetchMasterList()
        self.sortCategory = .deliveryCosts
        self.filterRestaurants()
        let restaurantMax = restaurantList.max { $0.sortingValues.deliveryCosts < $1.sortingValues.deliveryCosts }
        let restaurantMin = restaurantList.max { $0.sortingValues.deliveryCosts > $1.sortingValues.deliveryCosts }
        return (restaurantMin?.sortingValues.deliveryCosts == restaurantList.first?.sortingValues.deliveryCosts && restaurantMax?.sortingValues.deliveryCosts == restaurantList.last?.sortingValues.deliveryCosts)
    }
    
    func getSortedRestaurantArrayFail() -> Bool {
        self.fetchMasterList()
        self.sortCategory = .ratingAverage
        self.filterRestaurants()
        let restaurantMax = restaurantList.max { $0.sortingValues.deliveryCosts < $1.sortingValues.deliveryCosts }
        let restaurantMin = restaurantList.max { $0.sortingValues.deliveryCosts > $1.sortingValues.deliveryCosts }
        return (restaurantMin?.sortingValues.deliveryCosts == restaurantList.first?.sortingValues.deliveryCosts && restaurantMax?.sortingValues.deliveryCosts == restaurantList.last?.sortingValues.deliveryCosts)
    }
}

