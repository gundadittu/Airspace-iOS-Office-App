//
//  MainVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/17/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework

class MainVC: UIViewController {
    
    var options = [MainOptions]()
    var yelpRestaurants = [CarouselCVCellItem]()
    let tvCellID = "mainTVCell"

    let cellSpacing = CGFloat(10)
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")

        YelpDataController.getLocalRestaurauntCarouselObjects() { list in
            if let list = list {
                self.yelpRestaurants = list
                self.tableView.reloadData()
            }
        }
        
        options = [MainOptions(title: "Reserve a room", subtitle:"Find a conference room or desk.", icon:"reserve-icon", color: FlatBlue(), type: MainOptionsType.reserveRoom),
                   MainOptions(title: "Submit a ticket", subtitle:"Let us know when the coffee's gone.", icon:"serv-req-icon", color: FlatRed(), type: MainOptionsType.submitTicket),
                   MainOptions(title: "Register a guest", subtitle:"We'll send your guest over when they arrive.", icon:"register-guest-icon", color: FlatMint(), type: MainOptionsType.registerGuest),
                    MainOptions(title: "View events", subtitle:"See what's going on in your building.", icon:"events-icon", color: FlatPurple(), type: MainOptionsType.viewEvents),
                    MainOptions(title: "Space info", subtitle:"Learn more about your building.", icon:"space-info-icon", color: FlatPink(), type: MainOptionsType.spaceInfo)]
    }
}

extension MainVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let option = options[indexPath.row]
        switch option.type {
        case MainOptionsType.reserveRoom:
            break
        case MainOptionsType.submitTicket:
            self.performSegue(withIdentifier: "mainToSubmitTicket", sender: nil)
            break
        case MainOptionsType.registerGuest:
            break
        case MainOptionsType.viewEvents:
            break
        case MainOptionsType.spaceInfo:
            break
        case MainOptionsType.none:
            break
        }
    }
}

extension MainVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Quick Actions"
        } else if section == 1 {
            return "Nearby Yelp Favorites"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.white
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return options.count
        } else if section == 1 {
            return 1
        }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: tvCellID) as? MainTableViewCell else {
                return UITableViewCell()
            }
            let option = options[indexPath.row]
            cell.titleLabel.text = option.title
            cell.subtitleLabel.text = option.subtitle
            cell.iconImg.image = option.icon
            cell.accessoryType = .disclosureIndicator
            return cell
        } else if indexPath.section == 1 {
            var cell = CarouselTVCell()
            if let tvCell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as? CarouselTVCell  {
                cell = tvCell
            } else {
                tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as! CarouselTVCell
            }
            cell.setCarouselItems(with: self.yelpRestaurants)
            return cell
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.section == 0) ? CGFloat(75) : CGFloat(300)
    }
}
