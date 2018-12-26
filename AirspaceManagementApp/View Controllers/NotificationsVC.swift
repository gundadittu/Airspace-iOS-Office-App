//
//  ServiceRequestsVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/22/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import SwiftPullToRefresh

class NotificationsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var notifications = [AirNotification]()
    let reuseID = "NotificationTVCell"
    var dataController: NotificationVCDataController?
    var loadingIndicator: NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ALERTS"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = CGFloat(100)
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.register(UINib(nibName: reuseID, bundle: nil), forCellReuseIdentifier: reuseID)
        self.loadingIndicator = getGlobalLoadingIndicator(in: self.tableView)
        self.tableView.addSubview(self.loadingIndicator!)
        
        if self.dataController == nil {
            self.dataController = NotificationVCDataController(delegate: self)
        }
        
        self.tableView.spr_setTextHeader { [weak self] in
            if let _ = self?.dataController {
                self?.dataController?.loadNotifications()
            } else {
                 self?.tableView.spr_endRefreshing()
            }
        }
    }
}

extension NotificationsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let notification = self.notifications[indexPath.row]
//        guard let notificationType = notification.type else { return }
//        switch notificationType {
//        case .serviceRequestStatusChange:
//            return
//        }
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as? NotificationTVCell else {
            return UITableViewCell()
        }
        // need to write configureCell function
        cell.configure(with: notifications[indexPath.row])
        return cell
    }
}

extension NotificationsVC: NotificationVCDataControllerDelegate {
    func didLoadNotifications(_ notifications: [AirNotification]?, with error: Error?) {
        self.tableView.spr_endRefreshing()
        if let notifications = notifications {
            self.notifications = notifications
            self.tableView.reloadData()
        } else if let _ = error {
            // handle error
            return
        }
    }
    
    func startLoadingIndicator() {
        self.loadingIndicator?.startAnimating()
    }
    
    func stopLoadingIndicator() {
        self.loadingIndicator?.stopAnimating()
    }
}
