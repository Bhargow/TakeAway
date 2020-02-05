//
//  LFRestaurantCellViewModel.swift
//  LieferandoAssignment
//
//  Created by rao on 31/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import UIKit

protocol LFRestaurantCellViewModelDelegate {
    func updateCellData() 
}

class LFRestaurantCellViewModel {

    private let userDefaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let restaurantModel: LFRestaurantModel!
    
    private let delegate: LFRestaurantCellViewModelDelegate?
    
    
    var name: String = ""
    var status: String = ""
    var deliveryFee: String = ""
    var minimumCost: String = ""
    var isFavouriteRestaurant: Bool = false
    var ratingValue: CGFloat = 0.0
    
    init(restaurantModel: LFRestaurantModel, delegate: LFRestaurantCellViewModelDelegate? = nil) {
        self.restaurantModel = restaurantModel
        self.delegate = delegate
        self.setValues()
    }
    
    func addOrRemoveFromFavourites() {
        isFavouriteRestaurant ? removeFromFavourites() : addToFavourites()
    }
}

extension LFRestaurantCellViewModel {
    
    private func setValues() {
        name = restaurantModel.name
        status = "⏰ \(restaurantModel.statusString.capitalized)"
        let delFee: Double = Double(restaurantModel.sortingValues.deliveryCosts/100).roundedToDecimals(2)
        if delFee == 0.0 {
            deliveryFee = "🛵 Free"
        } else {
            deliveryFee = "🛵 \(delFee) €"
        }
        minimumCost = "💶 Min. \(Double(restaurantModel.sortingValues.minCost/100).roundedToDecimals(2)) €"
        
        ratingValue = CGFloat(restaurantModel.sortingValues.ratingAverage)
        
        checkIfExistsInFavourites()
    }
    
    private func checkIfExistsInFavourites() {
        let jsonDecoder = JSONDecoder()
        if let encodedData  = userDefaults.array(forKey: "favouritesList") as? [Data] {
            for data in encodedData {
                if let decoded = try? jsonDecoder.decode(LFRestaurantModel.self, from: data) {
                    if restaurantModel.id == decoded.id {
                        isFavouriteRestaurant = true
                        break
                    }
                }
            }
        }
    }
    
    private func addToFavourites() {
        var favourites: [Data] = []
        if let favouriteList = userDefaults.value(forKey: "favouritesList") as? [Data] {
            favourites = favouriteList
        }
        if let encoded = try? encoder.encode(restaurantModel) {
            favourites.append(encoded)
            isFavouriteRestaurant = true
            delegate?.updateCellData()
        }
        saveFavouritesToUserDefaults(favourites: favourites)
    }
    
    private func removeFromFavourites() {
        var favourites: [Data] = []
        if let favouriteList = userDefaults.value(forKey: "favouritesList") as? [Data] {
            favourites = favouriteList
            for i in 0...favouriteList.count {
                if let decoded = try? decoder.decode(LFRestaurantModel.self, from: favouriteList[i]) {
                    if decoded.id == restaurantModel.id {
                        favourites.remove(at: i)
                        isFavouriteRestaurant = false
                        delegate?.updateCellData()
                        break
                    }
                }
            }
        }
        saveFavouritesToUserDefaults(favourites: favourites)
    }
    
    private func saveFavouritesToUserDefaults(favourites: [Data]) {
        userDefaults.set(favourites, forKey: "favouritesList")
        userDefaults.synchronize()
    }
}
