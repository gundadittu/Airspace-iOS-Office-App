//
//  RoomListTVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/20/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SwiftPullToRefresh

class RoomListTVC: UITableViewController {
    
    var conferenceRooms = [AirConferenceRoom]()
    var startingDate = Date()
    var dataController: FindRoomVCDataController?
    var loadingIndicator: NVActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Conference Rooms"
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "ConferenceRoomTVCell", bundle: nil), forCellReuseIdentifier: "ConferenceRoomTVCell")
        self.tableView.backgroundColor = UIColor.flatWhite
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(didClickFilter))
        
        self.loadingIndicator = getGlobalLoadingIndicator(in: self.tableView)
        self.view.addSubview(self.loadingIndicator!)
        
        self.tableView.spr_setTextHeader { [weak self] in
            self?.dataController?.submitData()
        }
    }
    
    @objc func didClickFilter() {
        self.navigationController?.popViewController(animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conferenceRooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ConferenceRoomTVCell", for: indexPath) as? ConferenceRoomTVCell else {
            return UITableViewCell()
        }
        cell.configureCell(with: self.conferenceRooms[indexPath.row], startingAt: self.dataController?.selectedStartDate ?? Date(), delegate: self)
        return cell 
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "RoomListTVCtoConferenceRoomProfileTVC", sender: self.conferenceRooms[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RoomListTVCtoConferenceRoomProfileTVC",
            let destination = segue.destination as? ConferenceRoomProfileTVC,
            let room = sender as? AirConferenceRoom {
            destination.conferenceRoom = room
            
            // auto-populate fields if applicable
            if let dataController = self.dataController,
                let startDate = dataController.selectedStartDate,
                let duration = dataController.selectedDuration?.rawValue,
                let endDate = dataController.getEndDate() {
                destination.startDate = startDate
                destination.endDate = endDate
            }
        }
    }
    
}

extension RoomListTVC: ConferenceRoomTVCellDelegate {
    func didSelectCollectionView(for room: AirConferenceRoom) {
        self.performSegue(withIdentifier: "RoomListTVCtoConferenceRoomProfileTVC", sender: room)
    }
}

extension RoomListTVC: FindRoomVCDataControllerDelegate {
    func didFindAvailableConferenceRooms(rooms: [AirConferenceRoom]?, error: Error?) {
        // handle error
        if let rooms = rooms {
            self.conferenceRooms = rooms
        }
    }
    
    func startLoadingIndicator() {
        self.loadingIndicator?.startAnimating()
    }
    
    func stopLoadingIndicator() {
        self.loadingIndicator?.stopAnimating()
        self.tableView.spr_endRefreshing()
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
}
