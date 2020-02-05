//
//  LFRestaurantListViewModel.swift
//  LieferandoAssignment
//
//  Created by rao on 31/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import Foundation

protocol LFRestaurantListViewModelDelegate {
    func shouldRefreshTableViews(with restaurants: [LFRestaurantModel])
    func shouldShowError(error: String)
}

class LFRestaurantListViewModel {
    private var delegate: LFRestaurantListViewModelDelegate?
    private let userDefaults = UserDefaults.standard
    private let jsonDecoder = JSONDecoder()
    
    var restaurantListProvider: LFRestaurantListProvider!
    var filteringForFavourites: Bool = false {
        didSet {
            switchFavorutiesToNormalViceversa()
        }
    }
    var masterRestaurantList: [LFRestaurantModel] = [] {
        didSet { restaurantList = masterRestaurantList }
    }
    
    var restaurantList: [LFRestaurantModel] = [] {
        didSet { delegate?.shouldRefreshTableViews(with: restaurantList) }
    }
    
    var ratingFilter: Double {
        didSet { filterRestaurants() }
    }
    
    var minCostFilter: LFRestaurantMinCostFilter {
        didSet { filterRestaurants() }
    }
    
    var deliveryFeeFilter: LFRestaurantDeliveryCostFilter {
        didSet { filterRestaurants() }
    }
    
    var sortCategory: LFRestaurantSortValue {
        didSet { filterRestaurants() }
    }
    
    init(restaurantListProvider: LFRestaurantListProvider = LFRestaurantListProvider(),
        delegate: LFRestaurantListViewModelDelegate? = nil,
        sortCategory: LFRestaurantSortValue = .operatingStatus,
        deliveryFeeFilter: LFRestaurantDeliveryCostFilter = .showAll,
        minCostFilter: LFRestaurantMinCostFilter = .showAll,
        ratingFilter: Double = 0.0 ) {
        self.delegate = delegate
        self.restaurantListProvider = restaurantListProvider
        self.sortCategory = sortCategory
        self.deliveryFeeFilter = deliveryFeeFilter
        self.minCostFilter = minCostFilter
        self.ratingFilter = ratingFilter
    }
    
    func fetchMasterList() {
        do {
            masterRestaurantList = try restaurantListProvider.getRestaurantList(from: "LieferandoRestaurantList").sorted(by: { (x, y) -> Bool in
                return x.openingStatus < y.openingStatus
            })
        } catch let error {
            var errorString = ""
            switch error {
            case LFRestaurantListProviderError.invalidFileName:
                errorString = "The Data file is not available"
            case LFRestaurantListProviderError.invalidFileData:
                errorString = "The Data in the provided file is not valid"
            case LFRestaurantListProviderError.noDataAvailable:
                errorString = "The Data in the provided file is not available"
            case LFRestaurantListProviderError.invalidDataFormat:
                errorString = "The Data format is in-correct"
            case LFRestaurantListProviderError.invalidDecodeableData:
                errorString = "Internal Decode error"
            default:
                errorString = "System Error : \(error.localizedDescription)"
            }
            delegate?.shouldShowError(error: errorString)
        }
    }
    
    func fetchFavouriteRestaurants() {
        var favList:[LFRestaurantModel] = []
        if let encodedData  = userDefaults.array(forKey: "favouritesList") as? [Data] {
            for data in encodedData {
                if let decoded = try? jsonDecoder.decode(LFRestaurantModel.self, from: data) {
                    favList.append(decoded)
                }
            }
        }
        restaurantList = favList
        filterRestaurants()
    }
    
    func switchFavorutiesToNormalViceversa() {
        if filteringForFavourites == true {
            fetchFavouriteRestaurants()
        } else {
            filterRestaurants()
        }
    }
    
    func filterRestaurants(for text: String = "") {
        var shouldAddInFilteredArray: Bool = true

        var arrayToBefiltered = filteringForFavourites == true ? restaurantList : masterRestaurantList
        
        arrayToBefiltered = arrayToBefiltered.filter { (restaurantModel) -> Bool in
            let deliveryCostFilter: Bool = shouldAddThisRestaurantByDeliveryCostFilter(restaurantModel: restaurantModel)
            let minCostFilter: Bool      =
                shouldAddThisRestaurantByMinCostFilter(restaurantModel: restaurantModel)
            let ratingFilter:Bool        =
                shouldAddThisRestaurantByRatingFilter(restaurantModel: restaurantModel)
            shouldAddInFilteredArray =
                deliveryCostFilter && minCostFilter && ratingFilter
            if text.count > 0 {
                return restaurantModel.name.lowercased().contains(text) && shouldAddInFilteredArray
            }
            return shouldAddInFilteredArray
        }.sorted(with: sortCategory)
        
        restaurantList = arrayToBefiltered
    
    }
    
    func getFilterString() -> String {
        var filterString = ""
        switch deliveryFeeFilter {
            case .lessThanOneEuro:
                filterString.append(contentsOf: "🛵 Less than 1 €")
            case .lessThanTwoPointFiveEuro:
                filterString.append(contentsOf: "🛵 Less than 2.5 €")
            case .free:
                filterString.append(contentsOf: "🛵 Free")
            default:
                print("Do nothing")
        }
    
        switch minCostFilter {
            case .tenEurosOrLess:
                filterString.append(contentsOf: filterString.count > 0 ? ", 💶 Max 10 €" : "💶 Max 10 €")
            case .fifteenEurosOrLess:
                filterString.append(contentsOf: filterString.count > 0 ? ", 💶 Max 15 €" : "💶 Max 15 €")
            default:
                print("Do nothing")
        }
        
        if ratingFilter > 0 {
            filterString.append(contentsOf: filterString.count > 0 ? ", ⭐️ greater than or equal to \(ratingFilter)" : "⭐️ greater than or equal to \(ratingFilter)")
        }
        return filterString
    }
}

extension LFRestaurantListViewModel {
    
    private func shouldAddThisRestaurantByDeliveryCostFilter(restaurantModel : LFRestaurantModel) -> Bool {
        var deliveryCost: Int = 0
        switch deliveryFeeFilter {
            case .showAll:
                return true
            case .free:
                return restaurantModel.sortingValues.deliveryCosts == deliveryCost
            case .lessThanOneEuro:
                deliveryCost = 100
            case .lessThanTwoPointFiveEuro:
                deliveryCost = 250
        }
        return restaurantModel.sortingValues.deliveryCosts < deliveryCost
    }
    
    private func shouldAddThisRestaurantByMinCostFilter(restaurantModel : LFRestaurantModel) -> Bool {
        var minCost: Int = 0
        switch minCostFilter {
            case .showAll:
                return true
            case .tenEurosOrLess:
                minCost = 1000
            case .fifteenEurosOrLess:
                minCost = 1500
        }
        return restaurantModel.sortingValues.minCost <= minCost
    }
    
    private func shouldAddThisRestaurantByRatingFilter(restaurantModel : LFRestaurantModel) -> Bool {
        return restaurantModel.sortingValues.ratingAverage >= ratingFilter
    }
}

