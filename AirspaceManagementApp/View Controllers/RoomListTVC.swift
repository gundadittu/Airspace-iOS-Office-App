//
//  RoomListTVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/20/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit

class RoomListTVC: UITableViewController {
    
    var conferenceRooms = [AirConferenceRoom]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Conference Rooms"
//        self.tableView.backgroundColor = .lightGray
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "ConferenceRoomTVCell", bundle: nil), forCellReuseIdentifier: "ConferenceRoomTVCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return conferenceRooms.count
        return conferenceRooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ConferenceRoomTVCell", for: indexPath) as? ConferenceRoomTVCell else {
            return UITableViewCell()
        }
        cell.configureCell(with: self.conferenceRooms[indexPath.row])
        return cell 
    }
    
}
