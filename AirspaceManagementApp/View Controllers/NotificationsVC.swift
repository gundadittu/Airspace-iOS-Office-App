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
import DZNEmptyDataSet

class NotificationsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var notifications = [AirNotification]()
    let reuseID = "NotificationTVCell"
    var dataController: NotificationVCDataController?
    var loadingIndicator: NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "ALERTS"
        self.navigationController?.navigationBar.topItem?.title = "Alerts"

        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.allowsSelection = false
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = CGFloat(75)
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

extension NotificationsVC: UITableViewDataSource {
    func reloadTableView(){
        let range = NSMakeRange(0, self.tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.tableView.reloadSections(sections as IndexSet, with: .automatic)
    }
    
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
            self.reloadTableView()
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

extension NotificationsVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attrs = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 20) ?? UIFont.systemFont(ofSize: 20)] as [NSAttributedString.Key : Any]
        if let isLoading = self.dataController?.isLoading,
            isLoading == true {
            let attributedString = NSMutableAttributedString(string: "", attributes: attrs)
            return attributedString
        } else {
            return NSMutableAttributedString(string: "No alerts!", attributes: attrs)
        }
    }
    
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attrs = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 15) ?? UIFont.systemFont(ofSize: 15)] as [NSAttributedString.Key : Any]
        if let isLoading = self.dataController?.isLoading,
            isLoading == true {
            let attributedString = NSMutableAttributedString(string: "", attributes: attrs)
            return attributedString
        } else {
            return NSMutableAttributedString(string: "Now, go wool the world!", attributes: attrs)
        }
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if let isLoading = self.dataController?.isLoading,
            isLoading == true {
            return UIImage()
        } else {
            return UIImage(named: "sheep")
        }
    }
}
