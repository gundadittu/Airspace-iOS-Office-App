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
import WhatsNewKit

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
    var didPull = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Home"

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        self.tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        
        let loadingIndicator = getGlobalLoadingIndicator(in: self.view)
        self.loadingIndicator = loadingIndicator
        self.view.addSubview(loadingIndicator)
        
        if (dataController == nil) {
            self.dataController = MainVCDataController(delegate: self)
        }
        
        self.tableView.spr_setTextHeader {
            self.didPull = true
            self.dataController?.loadData()
        }
        
        self.showOnboarding()
    }
    
    func showOnboarding() {
        let defaults = UserDefaults.standard
        if defaults.value(forKey: "showGeneralOnboarding") == nil {
            defaults.setValue(true, forKey: "showGeneralOnboarding")
        } else {
            return
        }
        
        var configuration = WhatsNewViewController.Configuration()
        configuration.backgroundColor = .white
        configuration.titleView.titleColor = globalColor
        configuration.titleView.titleFont = UIFont(name: "AvenirNext-Medium", size: 40)!
        configuration.itemsView.titleFont = UIFont(name: "AvenirNext-Medium", size: 18)!
        configuration.itemsView.subtitleFont = UIFont(name: "AvenirNext-Regular", size: 15)!
        configuration.itemsView.autoTintImage = false
        configuration.completionButton.backgroundColor = globalColor
        configuration.completionButton.titleFont = UIFont(name: "AvenirNext-Medium", size: 18)!

        let whatsNew = WhatsNew(
            title: "Getting Started",
            items: [
                WhatsNew.Item(
                    title: "Reserve Rooms or Desks",
                    subtitle: "See when conference rooms and hot desks are available and reserve them from your phone.",
                    image: UIImage(named: "reserve-icon")
                ),
                WhatsNew.Item(
                    title: "View Events",
                    subtitle: "See what events/workshops are happening in your office. If you let us, we'll even notify you.",
                    image: UIImage(named: "events-icon")
                ),
                WhatsNew.Item(
                    title: "Submit Service Requests",
                    subtitle: "Something broken? Let your office manager know and stay updated on your request's progress.",
                    image: UIImage(named: "serv-req-icon")
                ),
                WhatsNew.Item(
                    title: "Register Guests",
                    subtitle: "You can register your guest in advance so they'll know where to come.",
                    image: UIImage(named: "register-guest-icon")
                ),
                WhatsNew.Item(
                    title: "See Space Info",
                    subtitle: "Learn more about your office space.",
                    image: UIImage(named: "space-info-icon")
                )
            ]
        )
        
        let whatsNewViewController = WhatsNewViewController(
            whatsNew: whatsNew,
            configuration: configuration
        )
        
        self.present(whatsNewViewController, animated: true)
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
            self.performSegue(withIdentifier: "toFindDeskVC", sender: nil)
        }
    }
}

extension MainVC: UITableViewDataSource {
    
    func reloadTableView(with set: IndexSet? = nil) {
        if let set = set {
            self.tableView.reloadSections(set, with: .automatic)
        } else {
            self.tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(50)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader") as? TableSectionHeader else {
            return UIView()
        }
        let currSection = sections[section]
        let sectionTitle = currSection.title
        cell.titleLabel.text = sectionTitle
        cell.section = currSection
        cell.chevronBtn.isHidden = true
        return cell
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
        } else if segue.identifier == "toDeskReservationVC",
            let destination = segue.destination as? DeskReservationVC,
            let deskRes = sender as? AirDeskReservation {
            destination.hotDeskReservation = deskRes
        }
    }
}

extension MainVC: MainVCDataControllerDelegate {
    func didUpdateSections(with sections: [MainVCSection]) {
        self.sections = sections
        self.reloadTableView()
    }
    
    func didUpdateReservationsToday(with error: Error?) {
        
        self.didPull = false
        if let bool = self.dataController?.isLoading {
            if bool == false {
                self.tableView.spr_endRefreshing()
            }
        } else {
            self.tableView.spr_endRefreshing()
        }
        
        if error == nil {
            let data = self.dataController?.reservationsToday ?? []
            self.reservationsToday = data
        }
        let sectionToReload = 0
        let indexSet: IndexSet = [sectionToReload]
        self.tableView.reloadSections(indexSet, with: .automatic)
    }
    
    func startLoadingIndicator() {
        if self.didPull == true {
            return 
        }
        self.loadingIndicator?.startAnimating()
    }
    
    func stopLoadingIndicator() {
        self.loadingIndicator?.stopAnimating()
    }
}

extension MainVC: CarouselTVCellDelegate {
    func descriptionForEmptyState(for identifier: String?) -> String {
        if identifier == "todayReservations" {
            return "Try to beehave!"
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
            return UIImage(named: "hive")!
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
        } else if let reservation = item.data as? AirDeskReservation {
            self.performSegue(withIdentifier: "toDeskReservationVC", sender: reservation)
        }
    }
}
