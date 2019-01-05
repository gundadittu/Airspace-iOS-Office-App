//
//  EventsTVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/27/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SwiftPullToRefresh
import NotificationBannerSwift
import DZNEmptyDataSet

class EventsTVC: UITableViewController {
    var events = [AirEvent]()
    var dataController: EventsTVCDataController?
    var loadingIndicator: NVActivityIndicatorView?
    var didPull = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Events"
        self.tableView.register(UINib(nibName: "EventsTVCell", bundle: nil), forCellReuseIdentifier: "EventsTVCell")
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        self.tableView.spr_setTextHeader {
            self.didPull = true
            self.dataController?.loadData()
        }
        
        let loadingIndicator = getGlobalLoadingIndicator(in: self.view)
        self.loadingIndicator = loadingIndicator
        self.view.addSubview(loadingIndicator)
        
        if self.dataController == nil {
            self.dataController = EventsTVCDataController(delegate: self)
        }
    }
    
    func reloadTableView(from start: Int? = nil, to end: Int? = nil){
       self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(220)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventsTVCell", for: indexPath) as? EventsTVCell else {
            return UITableViewCell()
        }
        let event = events[indexPath.row]
        cell.configure(with: event, delegate: self)
        return cell
    }
}

extension EventsTVC: EventsTVCDataControllerDelegate {
    func startLoadingIndicator() {
        if self.didPull == true {
            return
        }
        self.loadingIndicator?.startAnimating()
    }
    
    func stopLoadingIndicator() {
        self.loadingIndicator?.stopAnimating()
    }
    
    func didUpdateData(with error: Error?) {
        self.didPull = false 
        self.tableView.spr_endRefreshing()
        if let _ = error {
            let banner = NotificationBanner(title: "Oh no!", subtitle: "There was an issue loading the events in your offices.", leftView: nil, rightView: nil, style: .danger, colors: nil)
            banner.show()
        } else if let events = self.dataController?.events {
            self.events = events
            self.reloadTableView()
        }
        NotificationManager.shared.requestPermission()
    }
}

extension EventsTVC: EventsTVCellDelegate {
    func didTapCell(with event: AirEvent) {
        self.performSegue(withIdentifier: "toEventProfileTVC", sender: event)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEventProfileTVC",
            let destination = segue.destination as? EventProfileTVC,
            let event = sender as? AirEvent {
            destination.event = event
        }
    }
}

extension EventsTVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if self.dataController?.isLoading ?? false {
            return NSMutableAttributedString(string: "Loading...", attributes: globalBoldTextAttrs)
        }
        return NSMutableAttributedString(string: "No upcoming events.", attributes: globalBoldTextAttrs)
    }
    
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if self.dataController?.isLoading ?? false {
            return NSMutableAttributedString(string: "", attributes: globalTextAttrs)
        }
        return NSMutableAttributedString(string: "Come back tomorrow.", attributes: globalTextAttrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if self.dataController?.isLoading ?? false {
            return UIImage()
        }
        return UIImage(named: "closed-icon")
    }
}
