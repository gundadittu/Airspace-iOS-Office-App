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

enum MyGuestRegTVCType {
    case upcoming
    case past
    case none
}

class MyGuestRegTVCSection: PageSection {
    var title: String?
    var type: MyGuestRegTVCType = .none
    
    public init(title: String, type: MyGuestRegTVCType) {
        self.title = title
        self.type = type
    }
}

class MyGuestRegTVC: UITableViewController {
    let sections = [MyGuestRegTVCSection(title: "Upcoming", type: .upcoming), MyGuestRegTVCSection(title: "Past", type: .past)]
    var upcomingGuests = [AirGuestRegistration]()
    var pastGuests = [AirGuestRegistration]()
    var loadingIndicator: NVActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Registered Guests"
        self.loadingIndicator = getGlobalLoadingIndicator(in: self.tableView)
        self.view.addSubview(self.loadingIndicator!)
        
        loadData()
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
        guard let item = guest, let guestUID = item.uid else { return }
        
        let alertController = UIAlertController(title: "Manage Registered Guest: \(item.guestName ?? "No Guest Name Provided")", message: nil, preferredStyle: .actionSheet)
        let unregisterAction = UIAlertAction(title: "Unregister Guest", style: .destructive) { (action) in
            RegisterGuestManager.shared.cancelRegisteredGuest(registeredGuestUID: guestUID, completionHandler: { (error) in
                if let _ = error {
                    let banner = NotificationBanner(title: "Oh no!", subtitle: "There was an issue unregistering your guest.", leftView: nil, rightView: nil, style: .danger, colors: nil)
                    banner.show()
                } else {
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
        self.loadingIndicator?.startAnimating()
        RegisterGuestManager.shared.getUsersRegisteredGuests { (upcoming, past, error) in
            self.loadingIndicator?.stopAnimating()
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
