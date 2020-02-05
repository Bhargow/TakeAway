//
//  HXMovieModel.swift
//  HexadAssignment
//
//  Created by rao on 16/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import Foundation

struct LFRestaurantModel: Codable {
    
    // MARK: - Codable
    // Coding Keys
    enum CodingKeys: String, CodingKey {
        case id                     = "id"
        case name                   = "name"
        case openingStatus          = "status"
        case sortingValues          = "sortingValues"
    }
    
    // MARK: - Properties
    let id: String
    let name: String
    let openingStatus: Int
    let statusString: String
    var sortingValues: LFRestaurantSortValues
    
    // Decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        let restaurantStatus: String = try container.decode(String.self, forKey: .openingStatus)
        statusString = restaurantStatus.capitalized
        
        switch restaurantStatus {
        case "open":
            openingStatus = 0
        case "order ahead":
            openingStatus = 1
        case "closed":
            openingStatus = 2
        default :
            openingStatus = 3
        }
        sortingValues = try container.decode(LFRestaurantSortValues.self, forKey: .sortingValues)
    }
    
    // Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
        try container.encode(statusString, forKey: .openingStatus)
        try container.encode(sortingValues, forKey: .sortingValues)
    }
}
