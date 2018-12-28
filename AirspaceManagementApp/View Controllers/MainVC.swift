//
//  MainVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/17/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import SwiftPullToRefresh

enum MainVCSectionType {
    case quickActions
    case reservationsToday
//    case nearbyEats
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
    case reserveDesk
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
    
    var sections = [MainVCSection(title: "Today's Reservations", type: .reservationsToday), MainVCSection(title: "Quick Actions", type: .quickActions)]
    var quickActionsList = [QuickAction(title: "Find a conference room", subtitle:"Find a meeting space.", icon:"reserve-icon", color: nil, type: .reserveRoom),
                            QuickAction(title: "Find a hot desk", subtitle:"Find a space to get working.", icon:"table-icon", color: nil, type: .reserveDesk),
                             QuickAction(title: "View events", subtitle:"See what's going on in your offices.", icon:"events-icon", color: nil, type: .viewEvents),
                            QuickAction(title: "Submit a service request", subtitle:"Let us know if something needs servicing.", icon:"serv-req-icon", color: nil, type: .submitTicket),
                            QuickAction(title: "Register a guest", subtitle:"We'll let you know when your guest arrives.", icon:"register-guest-icon", color: nil, type: .registerGuest),
                            QuickAction(title: "Space info", subtitle:"Learn more about your building.", icon:"space-info-icon", color: nil, type: .spaceInfo)]
//    var yelpRestaurants = [CarouselCVCellItem]()
    var loadingIndicator: NVActivityIndicatorView?
    var reservationsToday = [AirReservation]()
    var dataController: MainVCDataController?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Home"

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
        
        self.loadingIndicator = getGlobalLoadingIndicator(in: self.tableView)
        
        if (dataController == nil) {
            self.dataController = MainVCDataController(delegate: self)
        }
        
        self.tableView.spr_setTextHeader {
            self.dataController?.loadData()
        }
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
        case .none:
            return
        case .reservationsToday:
            break
        }
    }
    
    func didSelectQuickAction(ofType type: QuickActionType) {
        switch type {
        case .reserveRoom:
            self.performSegue(withIdentifier: "toFindRoomVC", sender: nil)
        case .submitTicket:
            self.performSegue(withIdentifier: "mainToSubmitTicket", sender: nil)
        case .registerGuest:
            self.performSegue(withIdentifier: "MainVCtoRegisterGuestVC", sender: nil)
        case .viewEvents:
            self.performSegue(withIdentifier: "toEventsTVC", sender: nil)
        case .spaceInfo:
            self.performSegue(withIdentifier: "toSpaceInfoTVC", sender: nil)
        case .none:
            break
        case .reserveDesk:
            break
        }
    }
}

extension MainVC: UITableViewDataSource {
    
    func reloadTableView(from start: Int? = nil, to end: Int? = nil){
        let range = NSMakeRange(start ?? 0, end ?? self.tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.tableView.reloadSections(sections as IndexSet, with: .automatic)
    }
    
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
        case .reservationsToday:
            return 1
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
//        case .nearbyEats:
//            var cell = CarouselTVCell()
//            if let tvCell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as? CarouselTVCell  {
//                cell = tvCell
//            } else {
//                tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
//                cell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as! CarouselTVCell
//            }
            //         case .reservationsToday:
            
//            cell.setCarouselItems(with: self.yelpRestaurants)
//            return cell
        case .none:
            break
        case .reservationsToday:
            var cell = CarouselTVCell()
            if let tvCell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as? CarouselTVCell  {
                cell = tvCell
            }
            
            var carouselItems = [CarouselCVCellItem]()
            for reservation in self.reservationsToday {
                let item = CarouselCVCellItem(with: reservation)
                carouselItems.append(item)
            }
            cell.identifier = "todayReservations"
            cell.delegate = self
            cell.setCarouselItems(with: carouselItems)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]
        switch section.type {
        case .quickActions:
            return CGFloat(80)
        case .reservationsToday:
            return CGFloat(200)
        case .none:
            return CGFloat(0)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRoomReservationVC",
        let destination = segue.destination as? RoomReservationVC,
            let roomRes = sender as? AirConferenceRoomReservation {
            destination.conferenceRoomReservation = roomRes
        }
    }
}

extension MainVC: MainVCDataControllerDelegate {
    func didUpdateSections(with sections: [MainVCSection]) {
        self.sections = sections
        self.reloadTableView()
    }
    
    func didUpdateReservationsToday(with error: Error?) {
        
        if let bool = self.dataController?.isLoading,
            bool == false {
            self.tableView.spr_endRefreshing()
        }
        
        if let error = error {
            // handle error
            return
        } else {
            let data = self.dataController?.reservationsToday ?? []
            self.reservationsToday = data
            self.reloadTableView(from: 0, to: 1)
        }
    }
    
    func startLoadingIndicator() {
        self.loadingIndicator?.startAnimating()
    }
    
    func stopLoadingIndicator() {
        self.loadingIndicator?.stopAnimating()
    }
}

extension MainVC: CarouselTVCellDelegate {
    func descriptionForEmptyState(for identifier: String?) -> String {
        if identifier == "todayReservations" {
            return "Dive into work!"
        }
        return ""
    }
    
    func titleForEmptyState(for identifier: String?) -> String {
        if identifier == "todayReservations" {
            return "No Reservations Today."
        }
        return ""
    }
    
    func imageForEmptyState(for identifier: String?) -> UIImage {
        if identifier == "todayReservations" {
            return UIImage(named: "snorkel")!
        }
        return UIImage()
    }
    
    func isLoadingData(for identifier: String?) -> Bool {
        if identifier == "todayReservations" {
            return self.dataController?.loadingTodayReservations ?? false
        }
        return false
    }
    
    
    func didSelectCarouselCVCellItem(item: CarouselCVCellItem) {
        if let _ = item.data as? AirGuestRegistration {
            self.performSegue(withIdentifier: "ProfileVCtoMyGuestRegTVC", sender: nil)
        } else if let _ = item.data as? AirServiceRequest {
            self.performSegue(withIdentifier: "ProfileVCtoMyServReqTVC", sender: nil)
        } else if let reservation = item.data as? AirConferenceRoomReservation {
            self.performSegue(withIdentifier: "toRoomReservationVC", sender: reservation)
        }
    }
}
