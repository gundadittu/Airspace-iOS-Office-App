//
//  MyGuestRegTVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 11/22/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import NVActivityIndicatorView
import DZNEmptyDataSet
import SwiftPullToRefresh

class MyGuestRegTVC: UITableViewController {
    let sections = [MyGuestRegTVCSection(title: "Upcoming", type: .upcoming), MyGuestRegTVCSection(title: "Past", type: .past)]
    var upcomingGuests = [AirGuestRegistration]()
    var pastGuests = [AirGuestRegistration]()
    var loadingIndicator: NVActivityIndicatorView?
    var didPull = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Registered Guests"
        
        let loadingIndicator = getGlobalLoadingIndicator(in: self.view)
        self.loadingIndicator = loadingIndicator
        self.view.addSubview(loadingIndicator)
        
        self.tableView.separatorStyle = .none
        self.tableView.emptyDataSetDelegate = self
        self.tableView.emptyDataSetSource = self
        
        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        self.tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        
        self.tableView.spr_setTextHeader {
            self.didPull = true
            self.loadData()
        }
        self.loadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currSection = self.sections[section]
        switch currSection.type {
        case .upcoming:
            return upcomingGuests.count
        case .past:
            return pastGuests.count
        case .none:
            return 0
        }
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let currSection = sections[section]
//        return currSection.title
//    }
//
//    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.white
//    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(50)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let section = self.sections[indexPath.section]
        switch section.type {
        case .upcoming:
            cell.configureCell(with: self.upcomingGuests[indexPath.row])
        case .past:
            cell.configureCell(with: self.pastGuests[indexPath.row])
        case .none:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = self.sections[indexPath.section]
        var guest: AirGuestRegistration? = nil
        switch section.type {
        case .upcoming:
            guest = self.upcomingGuests[indexPath.row]
        case .past:
            guest = self.pastGuests[indexPath.row]
        case .none:
            break
        }
        guard let item = guest, let guestUID = item.uid else {
            // handle error
            return
        }
        
        let alertController = UIAlertController(title: "Manage Registered Guest: \(item.guestName ?? "No Guest Name Provided")", message: nil, preferredStyle: .actionSheet)
        let unregisterAction = UIAlertAction(title: "Unregister Guest", style: .destructive) { (action) in
            self.loadingIndicator?.startAnimating()
            RegisterGuestManager.shared.cancelRegisteredGuest(registeredGuestUID: guestUID, completionHandler: { (error) in
                self.loadingIndicator?.stopAnimating()
                if let _ = error {
                    let banner = NotificationBanner(title: "Oh no!", subtitle: "There was an issue unregistering your guest.", leftView: nil, rightView: nil, style: .danger, colors: nil)
                    banner.show()
                } else {
                    let banner = NotificationBanner(title: "Yahtzee!", subtitle: "Your guest has been unregistered.", leftView: nil, rightView: nil, style: .success, colors: nil)
                    banner.show()
                    self.loadData()
                }
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(unregisterAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    func loadData() {
        if self.didPull == false {
            self.loadingIndicator?.startAnimating()
        }
        RegisterGuestManager.shared.getUsersRegisteredGuests { (upcoming, past, error) in
            self.didPull = false 
            self.loadingIndicator?.stopAnimating()
            self.tableView.spr_endRefreshing()
            if let _ = error {
                let banner = NotificationBanner(title: "Oh no!", subtitle: "There was an issue loading your guests.", leftView: nil, rightView: nil, style: .danger, colors: nil)
                banner.show()
            } else {
                if let upcoming = upcoming,
                    let past = past {
                    self.pastGuests = past
                    self.upcomingGuests = upcoming
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension MyGuestRegTVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSMutableAttributedString(string: "No Registered Guests!", attributes: globalBoldTextAttrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSMutableAttributedString(string: "All guests that you register will show up here.", attributes: globalTextAttrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "no-guests")
    }
}
