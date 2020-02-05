//
//  LFRestaurantListViewController.swift
//  LieferandoAssignment
//
//  Created by rao on 31/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import UIKit

class LFRestaurantListViewController: UIViewController {

    @IBOutlet var restaurantsTableView: UITableView!
    @IBOutlet var restaurantsTableViewHeader: UIView!
    @IBOutlet var restaurantsFilterText: UILabel!
    @IBOutlet var restaurantsFilterTextField: UITextField!
    @IBOutlet var favouriteRestaurantsSegmentControl: UISegmentedControl!
    
    var restaurantListViewModel: LFRestaurantListViewModel!
    
    private var restaurants: [LFRestaurantModel] = [] {
        didSet {
            self.restaurantsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantListViewModel = LFRestaurantListViewModel(delegate: self)
        restaurantListViewModel.fetchMasterList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.title = "Restaurants"
        restaurantsTableView.reloadData()
    }
    
// MARK: Action handlers
    @IBAction func enteredTextInSearchBar(txtField: UITextField) {
        restaurantListViewModel.filterRestaurants(for: txtField.text ?? "")
    }
    
    @IBAction func segmentControlAction(segmentControl: UISegmentedControl) {
        restaurantsFilterTextField.text = ""
        restaurantsFilterTextField.resignFirstResponder()
        if segmentControl.selectedSegmentIndex == 0 {
            restaurantListViewModel.filteringForFavourites = false
        } else {
            restaurantListViewModel.filteringForFavourites = true
        }
    }
    
    @IBAction func filterButtonPressed() {
        if let filterViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LFFilterViewController") as? LFFilterViewController {
            filterViewController.restaurantListViewModel = restaurantListViewModel
            present(filterViewController, animated: true, completion: nil)
        }
    }
}

// MARK: Tableview Delegate Methods
extension LFRestaurantListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return restaurantsTableViewHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if let cell = tableView.cellForRow(at: indexPath) as? LFRestaurantTableViewCell {
            let addToOrRemoveFromFavourites = UIContextualAction(style: .normal, title:  "", handler: {[weak self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                cell.restaurantCellViewModel.addOrRemoveFromFavourites()
                if self?.favouriteRestaurantsSegmentControl.selectedSegmentIndex == 1 {
                    self?.restaurantListViewModel.fetchFavouriteRestaurants()
                }
                success(true)
            })
            if cell.restaurantCellViewModel.isFavouriteRestaurant == true {
                addToOrRemoveFromFavourites.image = UIImage(named: "icn-minus")
            } else {
                addToOrRemoveFromFavourites.image = UIImage(named: "icn-heart")
            }
            return UISwipeActionsConfiguration(actions: [addToOrRemoveFromFavourites])
        }
        return UISwipeActionsConfiguration(actions: [])
    }
}

// MARK: Tableview Datasource Methods {
extension LFRestaurantListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = restaurants[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LFRestaurantTableViewCell") as? LFRestaurantTableViewCell {
            cell.restaurantCellViewModel = LFRestaurantCellViewModel(restaurantModel: cellData, delegate: cell)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
}

// MARK: RestaurantList ViewModel Delegate Methods
extension LFRestaurantListViewController: LFRestaurantListViewModelDelegate {
    
    func shouldRefreshTableViews(with restaurants: [LFRestaurantModel]) {
        self.restaurants = restaurants
        let filterString = restaurantListViewModel.getFilterString()
        restaurantsFilterText.text = filterString.count > 0 ? filterString : "Swipe right to add to favourites"
    }
    
    func shouldShowError(error: String) {
        showAlertViewWithBlock(message: error, btnTitleOne: "Ok")
    }
}
