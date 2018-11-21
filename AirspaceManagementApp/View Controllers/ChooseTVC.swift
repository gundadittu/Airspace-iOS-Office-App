//
//  ChooseTVC.swift
//  AirspaceAdminApp
//
//  Created by Aditya Gunda on 11/10/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import NotificationBannerSwift

enum ChooseTVCType: String {
    case landlords = "Landlord"
    case buildings = "Building"
    case offices = "Office"
}

protocol ChooseTVCDelegate {
    func didSelectUser(landlord: AirUser)
    func didSelectBuilding(building: AirBuilding)
    func didSelectOffice(office: AirOffice)
}

extension ChooseTVCDelegate {
    func didSelectUser(landlord: AirUser) {
        // Makes method optional to implement
    }
    func didSelectBuilding(building: AirBuilding) {
        // Makes method optional to implement
    }
    func didSelectOffice(office: AirOffice) {
        // Makes method optional to implement
    }
}

class ChooseTVC: UITableViewController {
    var type: ChooseTVCType?
    var data = [AnyObject]()
    var loadingIndicator: NVActivityIndicatorView?
    var delegate: ChooseTVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let type = self.type,
            let _ = self.delegate else {
                fatalError("Did not provide a type and/or delegate for ChooseTVC")
        }
        self.title = "Choose a \(type.rawValue)"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: (self.tableView.frame.width/2)-25, y: (self.tableView.frame.height/2), width: 50, height: 50), type: .ballClipRotate, color: globalColor, padding: nil)
        self.view.addSubview(self.loadingIndicator!)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ChooseCell")
        self.loadData()
    }
    
    func loadData() {
        switch self.type {
        case .landlords?:
//            self.loadingIndicator?.startAnimating()
//            UserManager.shared.getAllLandlords() { (list, error) in
//                self.loadingIndicator?.stopAnimating()
//                if let _ = error {
//                    var banner: StatusBarNotificationBanner?
//                    banner = StatusBarNotificationBanner(title: "Error loading landlords.", style: .danger)
//                    banner?.show()
//                }
//                if let list = list {
//                    self.data = list
//                    self.tableView.reloadData()
//                }
//            }
            break
        case .none:
            return
        case .some(.buildings):
            self.loadingIndicator?.startAnimating()
//            BuildingManager.shared.getAllBuildings() { (list, error) in
//                self.loadingIndicator?.stopAnimating()
//                if let _ = error {
//                    var banner: StatusBarNotificationBanner?
//                    banner = StatusBarNotificationBanner(title: "Error loading buildings.", style: .danger)
//                    banner?.show()
//                }
//                if let list = list {
//                    self.data = list
//                    self.tableView.reloadData()
//                }
//            }
            UserManager.shared.getCurrentUsersOffices { (offices, error) in
                if let error = error {
                    let banner = StatusBarNotificationBanner(title: "Error loading Offices.", style: .danger)
                    banner.show()
                    return
                }
                
                if let offices = offices {
                   self.data = offices
                    self.tableView.reloadData()
                }
            }
            break
        case .some(.offices):
            self.loadingIndicator?.startAnimating()
            UserManager.shared.getCurrentUsersOffices { (offices, error) in
                self.loadingIndicator?.stopAnimating()
                if let _ = error {
                    let banner = StatusBarNotificationBanner(title: "Error loading offices.", style: .danger)
                    banner.show()
                }
                if let list = offices {
                    self.data = list
                    self.tableView.reloadData()
                }
            }
            break
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ChooseCell")
        //        if let dqcell = tableView.dequeueReusableCell(withIdentifier: "ChooseCell", for: indexPath) as? UITableViewCell {
        //            cell = dqcell
        //        }
        
        switch self.type {
        case .landlords?:
            if let list = self.data as? [AirUser] {
                cell.configureCell(with: list[indexPath.row])
            }
        case .none:
            return cell
        case .some(.buildings):
//            if let list = self.data as? [AirBuilding] {
//                cell.configureCell(with: list[indexPath.row])
//            }
            break
        case .some(.offices):
            if let list = self.data as? [AirOffice] {
                cell.configureCell(with: list[indexPath.row])
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.type {
        case .landlords?:
            if let list = self.data as? [AirUser] {
                self.navigationController?.popViewController(animated: true)
                self.delegate?.didSelectUser(landlord: list[indexPath.row])
            }
        case .none:
            break
        case .some(.buildings):
            if let list = self.data as? [AirBuilding] {
                self.navigationController?.popViewController(animated: true)
                self.delegate?.didSelectBuilding(building: list[indexPath.row])
            }
        case .some(.offices):
            if let list = self.data as? [AirOffice] {
                self.navigationController?.popViewController(animated: true)
                self.delegate?.didSelectOffice(office: list[indexPath.row])
            }
        }
    }
}

