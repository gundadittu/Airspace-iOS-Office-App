//
//  MyServReqTVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/17/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import NotificationBannerSwift
import DZNEmptyDataSet

class MyServReqTVC: UITableViewController {
    let sections = [MyServReqTVCSection(title: "Received", type: .open), MyServReqTVCSection(title: "In Progress", type: .pending), MyServReqTVCSection(title: "Finished", type: .closed)]
    var openSR = [AirServiceRequest]()
    var pendingSR = [AirServiceRequest]()
    var closedSR = [AirServiceRequest]()
    var loadingIndicator: NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Service Requests"
        self.tableView.separatorStyle = .none
        
        let loadingIndicator = getGlobalLoadingIndicator(in: self.view)
        self.loadingIndicator = loadingIndicator
        self.view.addSubview(loadingIndicator)
        
        self.loadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        let currSection = self.sections[section]
        switch currSection.type {
        case .open:
            return openSR.count
        case .pending:
            return pendingSR.count
        case .closed:
            return closedSR.count
        case .none:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let currSection = sections[section]
        return currSection.title
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.white
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(30)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let section = self.sections[indexPath.section]
        switch section.type {
        case .open:
            cell.configureCell(with: self.openSR[indexPath.row])
        case .pending:
            cell.configureCell(with: self.pendingSR[indexPath.row])
        case .closed:
            cell.configureCell(with: self.closedSR[indexPath.row])
        case .none:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = self.sections[indexPath.section]
        var sr: AirServiceRequest? = nil
        switch section.type {
        case .open:
            sr = self.openSR[indexPath.row]
        case .pending:
            sr = self.pendingSR[indexPath.row]
        case .closed:
            sr = self.closedSR[indexPath.row]
        case .none:
            break
        }
        guard let item = sr, let srUID = item.uid else { return }
        
        let alertController = UIAlertController(title: "Manage Service Request:", message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Cancel Service Request", style: .destructive) { (action) in
            self.loadingIndicator?.startAnimating()
            ServiceRequestManager.shared.cancelServiceRequest(serviceRequestID: srUID, completionHandler: { (error) in
                self.loadingIndicator?.stopAnimating()
                if let _ = error {
                    let banner = NotificationBanner(title: "Oh no!", subtitle: "There was an issue canceling your service request.", leftView: nil, rightView: nil, style: .danger, colors: nil)
                    banner.show()
                } else {
                    let banner = NotificationBanner(title: "Good News!", subtitle: "Your service request was successfully canceled.", leftView: nil, rightView: nil, style: .success, colors: nil)
                    banner.show()
                    self.loadData()
                }
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(action)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    func loadData() {
        self.loadingIndicator?.startAnimating()
        ServiceRequestManager.shared.getAllServiceRequests { (open, pending, closed, error) in
            self.loadingIndicator?.stopAnimating()
            //Handle error
            if let open = open {
                self.openSR = open
            }
            if let pending = pending {
                self.pendingSR = pending
            }
            if let closed = closed {
                self.closedSR = closed
            }
            self.tableView.reloadData()
        }
    }
}

extension MyServReqTVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSMutableAttributedString(string: "No Service Requests!", attributes: globalBoldTextAttrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSMutableAttributedString(string: "All your submitted service requests will show up here.", attributes: globalTextAttrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "no-requests")
    }
}
