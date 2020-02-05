//
//  File.swift
//  WunderMobility
//
//  Created by rao on 15/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import Foundation
import UIKit
import MapKit

let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}

enum LFRestaurantMinCostFilter: Int {
    case showAll = 0
    case tenEurosOrLess
    case fifteenEurosOrLess
}

enum LFRestaurantDeliveryCostFilter: Int {
    case showAll = 0
    case free
    case lessThanOneEuro
    case lessThanTwoPointFiveEuro
}

enum LFRestaurantSortValue: String {
    case bestMatch = "Best Match"
    case newest = "Newest"
    case ratingAverage = "Rating Average"
    case distance = "Distance"
    case popularity = "Popularity"
    case averageProductPrice = "Average Product Price"
    case deliveryCosts = "Delivery Costs"
    case minCost = "Min Cost"
    case operatingStatus = "Operating Staus"
}

extension Double {
    
    //    - Description: Rounds float to number of decimals we pass ex: if numberOfDecimals = 2, this method will return 1.233456 as 1.23
    //    - Parameters: numberOfDecimals: Int
    //    - Returns: Double
    public func roundedToDecimals(_ numberOfDecimals: Int) -> Double {
        let powerValue = Double(10^^numberOfDecimals)
        return (self*powerValue).rounded() / powerValue
    }
}

extension Array where Element == LFRestaurantModel {
    
    //    - Description: Sorts array of type LFRestaurantModel
    //    - Parameters: None
    //    - Returns: [LFRestaurantModel]
    func sorted(with sortData: LFRestaurantSortValue) -> [LFRestaurantModel] {
        return self.sorted { (x, y) -> Bool in
            switch sortData {
            case .bestMatch:
                return x.sortingValues.bestMatch > y.sortingValues.bestMatch
            case .averageProductPrice:
                return x.sortingValues.averageProductPrice < y.sortingValues.averageProductPrice
            case .deliveryCosts:
                return x.sortingValues.deliveryCosts < y.sortingValues.deliveryCosts
            case .distance:
                return x.sortingValues.distance < y.sortingValues.distance
            case .minCost:
                return x.sortingValues.minCost < y.sortingValues.minCost
            case .newest:
                return x.sortingValues.newest > y.sortingValues.newest
            case .popularity:
                return x.sortingValues.popularity > y.sortingValues.popularity
            case .ratingAverage:
                return x.sortingValues.ratingAverage > y.sortingValues.ratingAverage
            case .operatingStatus:
                return x.openingStatus < y.openingStatus
            }
        }
    }
}

extension UIViewController {
    
    //    - Description: Presents alert view controller 
    //    - Parameters: message: String, btnTitleOne: String, btnTitleTwo: String (Can be nil), completionOk: Action Block (Can be nil), cancel: Action Block (Can be nil), title: String? = nil)
    //    - Returns: Void
    func showAlertViewWithBlock(message: String,btnTitleOne: String, btnTitleTwo: String? = "", completionOk: (() -> Void)? = nil, cancel:(() -> Void)? = nil, title: String? = nil) {
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: btnTitleOne, style: .default, handler: { (alertAction) -> Void in
            if let completionBlock = completionOk {
                completionBlock()
            }
        }))
        
        if !"\(btnTitleTwo ?? "")".isEmpty {
            alertView.addAction(UIAlertAction(title: btnTitleTwo, style: .cancel, handler: { (alertAction) -> Void in
                if let cancelBlock = cancel {
                    cancelBlock()
                }
            }))
            
        }
        present(alertView, animated: true, completion: nil)
    }
}
