//
//  MyReservationsListTVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/25/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SwiftPullToRefresh
import NotificationBannerSwift

enum MyReservationsListTVCType {
    case conferenceRooms
    case hotDesks
    case none
}

class MyReservationsListTVC: UITableViewController {
    
    var upcoming = [AirReservation]()
    var past = [AirReservation]()
    var titleString: String?
    var type: MyReservationsListTVCType = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.separatorStyle = .none
        if let title = self.titleString {
            self.title = title
        } else {
            self.title = "My Reservations"
        }
        
        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        self.tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        
        self.tableView.spr_setTextHeader {
            self.loadData()
        }
    }
    
    func loadData() {
        switch self.type {
        case .conferenceRooms:
            loadConferenceRoomReservations()
        case .hotDesks:
            loadHotDeskReservations()
        case .none:
            self.tableView.spr_endRefreshing()
        }
    }
    
    func loadConferenceRoomReservations() {
        ReservationManager.shared.getAllConferenceRoomReservationsForUser { (upcoming, past, error) in
            if let _ = error {
                let banner = StatusBarNotificationBanner(title: "There was an issue loading your conference room reservations.", style: .danger)
                banner.show()
                return
            }
            
            if let upcoming = upcoming {
                self.upcoming = upcoming
            }
            if let past = past {
                self.past = past
            }
            self.tableView.spr_endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func loadHotDeskReservations() {
        DeskReservationManager.shared.getAllHotDeskReservationsForUser { (upcoming, past, error) in
            if let _ = error {
                let banner = StatusBarNotificationBanner(title: "There was an issue loading your hot desk reservations.", style: .danger)
                banner.show()
                return
            }
            if let upcoming = upcoming {
                self.upcoming = upcoming
            }
            if let past = past {
                self.past = past
            }
            self.tableView.spr_endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(50)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader") as? TableSectionHeader else {
            return UIView()
        }
        if section == 0 {
            cell.titleLabel.text = "Upcoming"
        } else if section == 1 {
             cell.titleLabel.text = "Past"
        }
        cell.chevronBtn.isHidden = true
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.upcoming.count
        } else if section == 1 {
            return self.past.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        if indexPath.section == 0 {
            cell.configureCell(with: self.upcoming[indexPath.row])
        } else if indexPath.section == 1 {
            cell.configureCell(with: self.past[indexPath.row])
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            // upcoming
            if let reservation = self.upcoming[indexPath.row] as? AirConferenceRoomReservation {
                self.performSegue(withIdentifier: "toRoomReservationVC", sender: reservation)
            } else if let reservation = self.upcoming[indexPath.row] as? AirDeskReservation {
                 self.performSegue(withIdentifier: "toDeskReservationVC", sender: reservation)
            }
        } else if indexPath.section == 1 {
            // past
            if let reservation = self.past[indexPath.row] as? AirConferenceRoomReservation {
                self.performSegue(withIdentifier: "toRoomReservationVC", sender: reservation)
            } else if let reservation = self.past[indexPath.row] as? AirDeskReservation {
                  self.performSegue(withIdentifier: "toDeskReservationVC", sender: reservation)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRoomReservationVC",
            let destination = segue.destination as? RoomReservationVC,
            let reservation = sender as? AirConferenceRoomReservation {
            destination.conferenceRoomReservation = reservation
        } else if segue.identifier == "toDeskReservationVC",
            let destination = segue.destination as? DeskReservationVC,
            let reservation = sender as? AirDeskReservation {
            destination.hotDeskReservation = reservation
        }
    }
}

extension MyReservationsListTVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSMutableAttributedString(string: "No reservations!", attributes: globalBoldTextAttrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSMutableAttributedString(string: "Any reservations you make will show up here.", attributes: globalTextAttrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "no-reservations")
    }
}
