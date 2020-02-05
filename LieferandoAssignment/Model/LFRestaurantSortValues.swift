//
//  LFRestaurantSortValues.swift
//  LieferandoAssignment
//
//  Created by rao on 03/02/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import Foundation

struct LFRestaurantSortValues: Codable {
    
    enum CodingKeys: String, CodingKey {
        case ratingAverage          = "ratingAverage"
        case deliveryCosts          = "deliveryCosts"
        case minCost                = "minCost"
        case bestMatch              = "bestMatch"
        case newest                 = "newest"
        case distance               = "distance"
        case averageProductPrice    = "averageProductPrice"
        case popularity             = "popularity"
    }
    
    let ratingAverage: Double
    let deliveryCosts: Int
    let minCost: Int
    let bestMatch: Double
    let newest: Double
    let distance: Int
    let averageProductPrice: Int
    let popularity: Double
    
    //Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ratingAverage, forKey: .ratingAverage)
        try container.encode(deliveryCosts, forKey: .deliveryCosts)
        try container.encode(minCost, forKey: .minCost)
        try container.encode(bestMatch, forKey: .bestMatch)
        try container.encode(newest, forKey: .newest)
        try container.encode(distance, forKey: .distance)
        try container.encode(averageProductPrice, forKey: .averageProductPrice)
        try container.encode(popularity, forKey: .popularity)
    }
}
