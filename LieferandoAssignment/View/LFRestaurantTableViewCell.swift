//
//  LFRestaurantTableViewCell.swift
//  LieferandoAssignment
//
//  Created by rao on 31/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import UIKit

class LFRestaurantTableViewCell: UITableViewCell {
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblMinCost: UILabel!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var lblDeliveryFee: UILabel!
    @IBOutlet var ratingView: StarRatingView!
    @IBOutlet var imgFavourtie: UIImageView?
    
    var restaurantCellViewModel: LFRestaurantCellViewModel! {
        didSet {
            setUpCellData()
        }
    }
    
    func setUpCellData() {
        lblName.text = restaurantCellViewModel.name
        lblMinCost.text = restaurantCellViewModel.minimumCost
        lblStatus.text = restaurantCellViewModel.status
        lblDeliveryFee.text = restaurantCellViewModel.deliveryFee
        ratingView.current = restaurantCellViewModel.ratingValue
        setOrRemoveFavouriteImage()
    }
    
    func setOrRemoveFavouriteImage() {
        imgFavourtie?.image = nil
        if restaurantCellViewModel.isFavouriteRestaurant == true {
            imgFavourtie?.image = UIImage.init(named: "icn-heart")
        }
    }
}

// MARK: RestaurantCell ViewModel Delegate Methods
extension LFRestaurantTableViewCell: LFRestaurantCellViewModelDelegate {
    func updateCellData() {
        setOrRemoveFavouriteImage()
    }
}
