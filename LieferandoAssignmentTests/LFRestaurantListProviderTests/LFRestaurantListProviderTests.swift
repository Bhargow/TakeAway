//
//  LFRestaurantListProviderTests.swift
//  LieferandoAssignmentTests
//
//  Created by rao on 31/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

@testable import LieferandoAssignment
import XCTest

class LFRestaurantListProviderTests: XCTestCase {

    var restaurantListProvider: LFRestaurantListProviderMock!
    var bundle: Bundle!
    var cache: NSCache<NSString, NSArray>!
    
    override func setUp() {
        bundle = Bundle(for: type(of: self))
        cache = NSCache.init()
        restaurantListProvider = LFRestaurantListProviderMock.init(bundle: bundle)
    }

    override func tearDown() {
        bundle = nil
        restaurantListProvider = nil
    }

    func testGetRestaurantList() {
        XCTAssertTrue(restaurantListProvider.getRestaurantList().count > 0)
    }
    
    func testGetRestaurantListFromCache() {
        XCTAssertTrue(restaurantListProvider.getRestaurantListFromCache().count > 0)
    }

    func testGetRestaurantListForWrongFileName() {
        XCTAssertEqual(restaurantListProvider.getRestaurantListNoFileFoundError(), LFRestaurantListProviderError.invalidFileName)
    }
    
    func testGetRestaurantListEmpty() {
        XCTAssertEqual(restaurantListProvider.getRestaurantListNoDataError(), LFRestaurantListProviderError.noDataAvailable)
    }
    
    func testGetRestaurantListForWrongDataFormat() {
        XCTAssertEqual(restaurantListProvider.getRestaurantListDataFormatError(), LFRestaurantListProviderError.invalidDataFormat)
    }
    
    func testGetRestaurantListForDecodeableError() {
        XCTAssertEqual(restaurantListProvider.getRestaurantListDecodableDataError(), LFRestaurantListProviderError.invalidDecodeableData)
    }
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

class LFRestaurantListProviderMock: LFRestaurantListProvider {
    
    func getRestaurantList() -> [LFRestaurantModel] {
        return try! getRestaurantList(from: "LieferandoRestaurantList")
    }
    
    func getRestaurantListDataFormatError() -> LFRestaurantListProviderError? {
        do {
            _ = try getRestaurantList(from: "LieferandoRestaurantListWrongDataMock")
            return nil
        } catch let error {
            return error as? LFRestaurantListProviderError
        }
    }
    
    func getRestaurantListNoFileFoundError() -> LFRestaurantListProviderError? {
        do {
            _ = try getRestaurantList(from: "NofileName")
            return nil
        } catch let error {
            return error as? LFRestaurantListProviderError
        }
    }
    
    func getRestaurantListNoDataError() -> LFRestaurantListProviderError? {
        do {
            _ = try getRestaurantList(from: "LieferandoRestaurantListEmptyMock")
            return nil
        } catch let error {
            return error as? LFRestaurantListProviderError
        }
    }
    
    func getRestaurantListDecodableDataError() -> LFRestaurantListProviderError? {
        do {
            _ = try getRestaurantList(from: "LieferandoRestaurantListWrongDecodeableDataMock")
            return nil
        } catch let error {
            return error as? LFRestaurantListProviderError
        }
    }
    
    func getRestaurantListFromCache() -> [LFRestaurantModel] {
        _ = try? getRestaurantList(from: "LieferandoRestaurantList")
        return try! getRestaurantList(from: "LieferandoRestaurantList")
    }
}
