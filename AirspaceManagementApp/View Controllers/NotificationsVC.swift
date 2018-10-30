//
//  ServiceRequestsVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/22/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit
class NotificationsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var notifications = [UserNotification]()
    let reuseID = "NotificationTVCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Alerts"
        self.notifications = [UserNotification(title: "Building Announcement", body: "This Friday the Braavos conference room will be closed for repairs.", type: .buildingAnnouncement),
                              UserNotification(title: "Service Request Update", body: "Your request was completed", type: .servReqStatusChange)]
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = CGFloat(100)
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        
        tableView.register(UINib(nibName: "NotificationTVCell", bundle: nil), forCellReuseIdentifier: reuseID)
    }
}

extension NotificationsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NotificationsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = NotificationTVCell()
        if let tvCell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as? NotificationTVCell  {
            cell = tvCell
        } else {
            tableView.register(UINib(nibName: "NotificationTVCell", bundle: nil), forCellReuseIdentifier: reuseID)
            cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! NotificationTVCell
        }
        cell.configureCell(notification: notifications[indexPath.row])
       return cell
    }
}
