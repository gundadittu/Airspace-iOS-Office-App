//
//  MyReservationsListTVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/25/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit

class MyReservationsListTVC: UITableViewController {
    
    var upcoming = [AirReservation]()
    var past = [AirReservation]()
    var titleString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let title = self.titleString {
            self.title = title
        } else {
            self.title = "My Reservations"
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Upcoming"
        } else if section == 1 {
            return "Past"
        } else {
            return nil
        }
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
                return
            }
        } else if indexPath.section == 1 {
            // past
            if let reservation = self.past[indexPath.row] as? AirConferenceRoomReservation {
                self.performSegue(withIdentifier: "toRoomReservationVC", sender: reservation)
            } else if let reservation = self.past[indexPath.row] as? AirDeskReservation {
                return
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRoomReservationVC",
            let destination = segue.destination as? RoomReservationVC,
            let reservation = sender as? AirConferenceRoomReservation {
            destination.conferenceRoomReservation = reservation
        }
    }
}
