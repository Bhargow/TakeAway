//
//  LFFilterViewController.swift
//  LieferandoAssignment
//
//  Created by rao on 01/02/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import UIKit

class LFFilterViewController: UITableViewController {

    @IBOutlet var sortDataPickerView: UIView!
    @IBOutlet var sortDataPicker: UIPickerView!
    @IBOutlet var sortType: UILabel!
    @IBOutlet var ratingView: StarRatingView!
    
    private let pickerList = ["Operating Staus","Best Match", "Newest", "Rating Average", "Distance", "Popularity", "Average Product Price", "Delivery Costs", "Min Cost"]
    
    var restaurantListViewModel: LFRestaurantListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortDataPickerView.frame = CGRect.init(x: 0, y: view.frame.height , width: view.frame.width, height: 200)
        view.addSubview(sortDataPickerView)
        ratingView.delegate = self
        ratingView.current = CGFloat(restaurantListViewModel.ratingFilter)
        sortType.text = restaurantListViewModel.sortCategory.rawValue
    }
    
// MARK: Action handlers
    @IBAction func closeSortPicker() {
        let closingFrame = CGRect(x: 0, y: view.frame.height , width: view.frame.width, height: 200)
        UIView.animate(withDuration: 0.5) {
            self.sortDataPickerView.frame = closingFrame
        }
        
        let sortText = pickerList[sortDataPicker.selectedRow(inComponent: 0)]
        sortType.text = sortText
        restaurantListViewModel.sortCategory = LFRestaurantSortValue(rawValue: sortText) ?? .operatingStatus
    }
    
    @IBAction func closeButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    private func addSortPikcerView() {
        let openingFrame = CGRect.init(x: 0, y: view.frame.height - 250 , width: view.frame.width, height: 200)
        UIView.animate(withDuration: 0.5) {
            self.sortDataPickerView.frame = openingFrame
        }
    }

// MARK: Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 1:
            cell.imageView?.image = UIImage(named: "icn-radioBtnOff")
            if restaurantListViewModel.minCostFilter.rawValue == indexPath.row {
                cell.imageView?.image = UIImage(named: "icn-radioBtnOn")
            }
        case 2:
            cell.imageView?.image = UIImage(named: "icn-radioBtnOff")
            if restaurantListViewModel.deliveryFeeFilter.rawValue == indexPath.row {
                cell.imageView?.image = UIImage(named: "icn-radioBtnOn")
            }
        default:
            print("Nothing to do")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            addSortPikcerView()
        case 1:
            restaurantListViewModel.minCostFilter = LFRestaurantMinCostFilter(rawValue: indexPath.row) ?? .showAll
            tableView.reloadSections([1], with: UITableView.RowAnimation.none)
        case 2:
            restaurantListViewModel.deliveryFeeFilter = LFRestaurantDeliveryCostFilter(rawValue: indexPath.row) ?? .showAll
            tableView.reloadSections([2], with: UITableView.RowAnimation.none)
        default:
            print("Nothing to do")
        }
        
    }
}

// MARK: UIPickerView Delegate Methods
extension LFFilterViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerList[row]
    }
}

// MARK: Star Rating Delegate Delegate Methods
extension LFFilterViewController: StarRatingDelegate {
    func StarRatingValueChanged(view: StarRatingView, value: CGFloat, isFinalValue: Bool) {
        restaurantListViewModel.ratingFilter = Double(value)
    }
}

