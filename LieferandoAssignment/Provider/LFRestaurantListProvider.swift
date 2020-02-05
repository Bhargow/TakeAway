//
//  LFRestaurantListProvider.swift
//  LieferandoAssignment
//
//  Created by rao on 31/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import Foundation

enum LFRestaurantListProviderError: Error {
    case invalidFileName
    case invalidFileData
    case noDataAvailable
    case invalidDataFormat
    case invalidDecodeableData
}

class LFRestaurantListProvider {
    let bundle: Bundle
    let cache:NSCache<NSString, NSArray>

    init(bundle: Bundle = Bundle.main, cache: NSCache<NSString, NSArray> = NSCache.init()) {
        self.bundle = bundle
        self.cache = cache
    }

    //    - Description: Reads the data from .json file and returns restaurant list
    //    - Parameters: fileName: String
    //    - Returns: Void
    func getRestaurantList(from fileName: String, ofFileType fileType: String = ".json") throws -> [LFRestaurantModel] {
        
        if let restaurantList = cache.object(forKey: "restaurantList") as? [LFRestaurantModel] {
            return restaurantList
        }
        
        var restaurantList: [LFRestaurantModel] = []
        guard let url = bundle.url(forResource: fileName, withExtension: fileType) else {
            throw LFRestaurantListProviderError.invalidFileName
        }
        
        let data = try? Data(contentsOf: url)
        if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any] {
            if let restaurants = json["restaurants"] as? [[String: Any]], restaurants.count > 0 {
                for restaurantDict in restaurants {
                    do {
                        let restaurantData = try JSONSerialization.data(withJSONObject: restaurantDict, options: .prettyPrinted)
                        let restaurantModel = try JSONDecoder().decode(LFRestaurantModel.self, from: restaurantData)
                        restaurantList.append(restaurantModel)
                    } catch {
                        throw LFRestaurantListProviderError.invalidDecodeableData
                    }
                }
                cache.setObject(NSArray(array: restaurantList), forKey: "restaurantList")
                return restaurantList
            } else {
                throw LFRestaurantListProviderError.noDataAvailable
            }
        } else {
            throw LFRestaurantListProviderError.invalidDataFormat
        }
    }
}
