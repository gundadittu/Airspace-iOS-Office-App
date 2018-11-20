//
//  RegisterGuestVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 11/19/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import Eureka

enum RegisterGuestVCSectionType {
    case office
    case name
    case dateTime
    case email
    case submit
    case none
}

class RegisterGuestVCSection: PageSection {
    var title = ""
    var buttonTitle = ""
    var type: RegisterGuestVCSectionType = .none

    public init(title: String, buttonTitle: String, type: RegisterGuestVCSectionType) {
        self.title = title
        self.buttonTitle = buttonTitle
        self.type = type
    }
}

class RegisterGuestVC: UITableViewController {
    var sections = [RegisterGuestVCSection]()
    var dataController: RegisterGuestTVCDataController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Register a Guest"
        
        self.tableView.register(UINib(nibName: "FormTVCell", bundle: nil), forCellReuseIdentifier: "FormTVCell")
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        
        self.sections = [RegisterGuestVCSection(title: "I have a guest visiting", buttonTitle: "Choose Office", type: .office),RegisterGuestVCSection(title: "Their name is", buttonTitle: "Enter Guest Name", type: .name),RegisterGuestVCSection(title: "Their email is (optional)", buttonTitle: "Enter Guest Email", type: .email), RegisterGuestVCSection(title: "They are visiting", buttonTitle: "Choose Date/Time", type: .dateTime), RegisterGuestVCSection(title: "Submit", buttonTitle: "Register Guest", type: .submit)]
        
        self.dataController = RegisterGuestTVCDataController(delegate: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return sections.count
        }
        
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = self.sections[indexPath.row]
        switch section.type {
        case .office:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTVCell") as? FormTVCell else {
                return UITableViewCell()
            }
            cell.configureCell(with: section, delegate: self)
            return cell
        case .submit:
            break
        case .none:
            break
        case .name:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTVCell") as? FormTVCell else {
                return UITableViewCell()
            }
            cell.configureCell(with: section, delegate: self)
            return cell
        case .dateTime:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTVCell") as? FormTVCell else {
                return UITableViewCell()
            }
            cell.configureCell(with: section, delegate: self)
            return cell
        case .email:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTVCell") as? FormTVCell else {
                return UITableViewCell()
            }
            cell.configureCell(with: section, delegate: self)
            return cell
        }
        return UITableViewCell()
    }
}

extension RegisterGuestVC: FormTVCellDelegate {
    func didSelectCellButton(withObject: PageSection) {
        return
    }
}

extension RegisterGuestVC: RegisterGuestTVCDataControllerDelegate {
    func didUpdateSections(sections: [RegisterGuestVCSection]) {
        self.sections = sections
        self.tableView.reloadData()
    }
}
