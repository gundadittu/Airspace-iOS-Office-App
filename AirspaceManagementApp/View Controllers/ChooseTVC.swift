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
    case serviceRequestType = "Service Request Type"
    case duration = "Duration"
    case capacity = "Capacity"
    case roomAmenities = "Room Amenities"
    case employees = "Employees"
}

class ChooseTVC: UITableViewController {
    var type: ChooseTVCType?
    var data = [AnyObject]()
    var selectedAmenities = [RoomAmenity]()
    var selectedEmployees = [AirUser]()
    var selectedServiceTypeItem: ServiceRequestTypeItem?
    var loadingIndicator: NVActivityIndicatorView?
    var delegate: ChooseTVCDelegate?
    var officeObj: AirOffice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let type = self.type,
            let _ = self.delegate else {
                fatalError("Did not provide a type and/or delegate for ChooseTVC")
        }
        self.title = getTitle(with: type)
        
        let loadingIndicator = getGlobalLoadingIndicator(in: self.view)
        self.loadingIndicator = loadingIndicator
        self.view.addSubview(loadingIndicator)
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ChooseCell")
        self.loadData()
        
        if type == .employees && self.officeObj == nil {
            fatalError("Did not provide an officeObj for ChooseTVC to display employees.")
        }
        
        if type == .roomAmenities || type == .employees {
            self.tableView.allowsMultipleSelection = true
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didClickSave))

        } else {
            self.navigationItem.rightBarButtonItem = nil
            self.tableView.allowsMultipleSelection = false
//             self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(didClickClear))
        }
    }
    
    func getTitle(with type: ChooseTVCType) -> String {
        switch type{
        case .landlords:
            break
        case .buildings:
            break
        case .offices:
            break
        case .serviceRequestType:
            break
        case .duration:
            break
        case .capacity:
            break
        case .roomAmenities:
            return "Choose Room Amenities"
        case .employees:
            return "Choose Attendees"
        }
        return "Choose a \(type.rawValue)"
    }
    
    @objc func didClickSave() {
        if self.type == .roomAmenities {
            self.delegate?.didSelectRoomAmenities(amenities: self.selectedAmenities)
        } else if self.type == .employees {
            self.delegate?.didChooseEmployees(employees: self.selectedEmployees)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
//    @objc func didClickCLear() {
////        self.delegate?.didSelectRoomAmenities(amenities: self.selectedAmenities)
//        guard let type = self.type else { return }
//        switch type {
//        case .landlords:
//            break
//        case .buildings:
//            break
//        case .offices:
//            break
//        case .serviceRequestType:
//            break
//        case .duration:
//            break
//        case .capacity:
//            break
//        case .roomAmenities:
//            break
//        }
//        self.navigationController?.popViewController(animated: true)
//    }
    
    func loadData() {
        switch self.type {
        case .landlords?:
            break
        case .none:
            return
        case .some(.buildings):
//            self.loadingIndicator?.startAnimating()
//            UserManager.shared.getCurrentUsersOffices { (offices, error) in
//                if let _ = error {
//                    let banner = StatusBarNotificationBanner(title: "Error loading Offices.", style: .danger)
//                    banner.show()
//                    return
//                }
//
//                if let offices = offices {
//                   self.data = offices
//                    self.tableView.reloadData()
//                }
//            }
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
        case .some(.serviceRequestType):
            break
        case .some(.duration):
            break
        case .some(.capacity):
            break
        case .some(.roomAmenities):
            break
        case .some(.employees):
            guard let office = self.officeObj, let officeUID = office.uid else { return }
            self.loadingIndicator?.startAnimating()
            OfficeManager.shared.getEmployeesForOffice(officeUID: officeUID) { (offices, error) in
                self.loadingIndicator?.stopAnimating()
                if let _ = error {
                    let banner = StatusBarNotificationBanner(title: "Error loading employees.", style: .danger)
                    banner.show()
                }
                if let list = offices {
                    self.data = list
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return nil
//    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.white
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.type {
        case .landlords?:
            break
        case .none:
            break
        case .some(.buildings):
            break
        case .some(.offices):
            break
        case .some(.serviceRequestType):
            return ServiceRequestTypeItem.allCases.count
        case .some(.duration):
            return Duration.allCases.count
        case .some(.capacity):
            return 40
        case .some(.roomAmenities):
            return RoomAmenity.allCases.count
        case .some(.employees):
            break
        }
        return data.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ChooseCell")
        
        switch self.type {
        case .landlords?:
            if let list = self.data as? [AirUser] {
                cell.configureCell(with: list[indexPath.row])
            }
        case .none:
            return cell
        case .some(.buildings):
            break
        case .some(.offices):
            if let list = self.data as? [AirOffice] {
                cell.configureCell(with: list[indexPath.row])
            }
        case .some(.serviceRequestType):
            let item = ServiceRequestTypeItem.allCases[indexPath.row]
            cell.configureCell(with: item, and: (self.selectedServiceTypeItem?.rawValue == item.rawValue))
        case .some(.duration):
            let dur = Duration.allCases[indexPath.row]
            cell.configureCell(with: dur)
        case .some(.capacity):
            let capacity = indexPath.row + 1
            cell.configureCell(with: capacity)
        case .some(.roomAmenities):
            let amenity = RoomAmenity.allCases[indexPath.row]
            cell.configureCell(with: amenity, selected: self.selectedAmenities.contains(amenity))
        case .some(.employees):
            if let data = self.data as? [AirUser] {
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
                cell.tintColor = globalColor
                let currUser = data[indexPath.row]
                
                for employee in selectedEmployees {
                    if employee.uid == currUser.uid {
                        cell.configureCell(with: currUser, accessoryType: .checkmark)
                        return cell 
                    }
                }
                cell.configureCell(with: currUser, accessoryType: .none)
                return cell
            }
        }
        cell.tintColor = globalColor
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
        case .some(.serviceRequestType):
            let item = ServiceRequestTypeItem.allCases[indexPath.row]
            self.delegate?.didSelectSRType(type: item)
            self.navigationController?.popViewController(animated: true)
        case .some(.duration):
            self.navigationController?.popViewController(animated: true)
            self.delegate?.didSelectDuration(duration: Duration.allCases[indexPath.row])
        case .some(.capacity):
            self.navigationController?.popViewController(animated: true)
            self.delegate?.didSelectCapacity(number: indexPath.row+1)
        case .some(.roomAmenities):
            let currAmenity = RoomAmenity.allCases[indexPath.row]
            if self.selectedAmenities.contains(currAmenity) {
                 self.selectedAmenities = self.selectedAmenities.filter { (amenity) -> Bool in
                    return amenity != currAmenity
                }
            } else {
                self.selectedAmenities.append(currAmenity)
            }
            self.tableView.reloadData()
        case .some(.employees):
            guard let selectedUser = self.data[indexPath.row] as? AirUser else { return }
            let union = self.selectedEmployees.filter { (employee) -> Bool in
                return (employee.uid == selectedUser.uid)
            }
            
            if union.count > 0 {
                let newData = self.selectedEmployees.filter { (user) -> Bool in
                    return (user.uid != selectedUser.uid)
                }
                self.selectedEmployees = newData
            } else {
                self.selectedEmployees.append(selectedUser)
            }
            self.tableView.reloadData()
        }
    }
}

