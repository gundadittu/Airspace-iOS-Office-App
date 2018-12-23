//
//  MainVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/17/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit

enum MainVCSectionType {
    case quickActions
    case nearbyEats
    case none
}

class MainVCSection: PageSection {
    var title = ""
    var type: MainVCSectionType = .none
    
    public init(title: String, type: MainVCSectionType) {
        self.title = title
        self.type = type
    }
}

enum QuickActionType {
    case reserveRoom
    case submitTicket
    case registerGuest
    case viewEvents
    case spaceInfo
    case none
}

class QuickAction: NSObject {
    var title: String!
    var icon: UIImage?
    var subtitle: String?
    var color: UIColor?
    var type: QuickActionType
    
    public init(title: String, subtitle: String, icon: String, color: UIColor?, type: QuickActionType?) {
        self.title = title
        self.subtitle = subtitle
        self.icon = UIImage(named: icon)
        self.color = color ?? .black
        self.type = type ?? QuickActionType.none
    }
}

class MainVC: UIViewController {
    
    var sections = [MainVCSection(title: "Quick Actions", type: .quickActions)]
//    , MainVCSection(title: "Nearby Eats", type: .nearbyEats)]
    var quickActionsList = [QuickAction(title: "Reserve a room or desk", subtitle:"Find a space to get working.", icon:"reserve-icon", color: nil, type: .reserveRoom),
                            QuickAction(title: "Submit a service request", subtitle:"Let us know if something needs servicing.", icon:"serv-req-icon", color: nil, type: .submitTicket),
                            QuickAction(title: "Register a guest", subtitle:"We'll let you know when your guest arrives.", icon:"register-guest-icon", color: nil, type: .registerGuest),
                            QuickAction(title: "View events", subtitle:"See what's going on in your building.", icon:"events-icon", color: nil, type: .viewEvents),
                            QuickAction(title: "Space info", subtitle:"Learn more about your building.", icon:"space-info-icon", color: nil, type: .spaceInfo)]
    var yelpRestaurants = [CarouselCVCellItem]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
    }
    
//    func loadNearbyEatsData() {
//        YelpDataController.getLocalRestaurauntCarouselObjects() { list in
//            if let list = list {
//                self.yelpRestaurants = list
//                self.tableView.reloadData()
//            }
//        }
//    }
}

extension MainVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let section = sections[indexPath.section]
        switch section.type {
        case .quickActions:
            let quickAction = quickActionsList[indexPath.row]
            self.didSelectQuickAction(ofType: quickAction.type)
        case .nearbyEats:
            return
        case .none:
            return
        }
    }
    
    func didSelectQuickAction(ofType type: QuickActionType) {
        switch type {
        case .reserveRoom:
            self.performSegue(withIdentifier: "toReserveVC", sender: nil)
        case .submitTicket:
            self.performSegue(withIdentifier: "mainToSubmitTicket", sender: nil)
        case .registerGuest:
            self.performSegue(withIdentifier: "MainVCtoRegisterGuestVC", sender: nil)
        case .viewEvents:
            break
        case .spaceInfo:
            break
        case .none:
            break
        }
    }
}

extension MainVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionObj = self.sections[section]
        return sectionObj.title
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(45)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionObj = self.sections[section]
        switch sectionObj.type {
        case .quickActions:
            return self.quickActionsList.count
        case .nearbyEats:
            return 0
        case .none:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = self.sections[indexPath.section]
        switch section.type {
        case .quickActions:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "mainTVCell") as? MainTableViewCell else {
                return UITableViewCell()
            }
            let action = quickActionsList[indexPath.row]
            cell.titleLabel.text = action.title
            cell.subtitleLabel.text = action.subtitle
            cell.iconImg.image = action.icon
            cell.accessoryType = .disclosureIndicator
            return cell
        case .nearbyEats:
            var cell = CarouselTVCell()
            if let tvCell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as? CarouselTVCell  {
                cell = tvCell
            } else {
                tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as! CarouselTVCell
            }
            cell.setCarouselItems(with: self.yelpRestaurants)
            return cell
        case .none:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.section == 0) ? CGFloat(80) : CGFloat(300)
    }
}
