//
//  RoomReservationVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/25/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import SwiftPullToRefresh
import NotificationBannerSwift


enum RoomReservationVCSectionType {
    case bio
    case eventName
    case eventDescription
    case inviteOthers
    case none
}

class RoomReservationVCSection: PageSection {
    var type: RoomReservationVCSectionType = .none
    var buttonTitle = ""
    var selectedButtonTitle: String?
    var title: String?
    
    public init(title: String, buttonTitle: String?, type: RoomReservationVCSectionType) {
        self.title = title
        self.type = type
        self.buttonTitle = buttonTitle ?? ""
    }
}

class RoomReservationVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var sections = [RoomReservationVCSection(title: "Bio", buttonTitle: nil, type: .bio), RoomReservationVCSection(title: "Change Event Name", buttonTitle: "Enter Name", type: .eventName), RoomReservationVCSection(title: "Change Event Description (optional)", buttonTitle: "Enter Description", type: .eventDescription), RoomReservationVCSection(title: "Modify Attendees", buttonTitle: "Choose Attendees", type: .inviteOthers)]
    
    var loadingIndicator: NVActivityIndicatorView?
    var dataController: RoomReservationVCDataController?
    var conferenceRoom: AirConferenceRoom?
//    var existingResDisplayStartDate = Date() // date used to display existing reservations for room
//    var startDate: Date?
//    var endDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "FormTVCell", bundle: nil), forCellReuseIdentifier: "FormTVCell")
        self.tableView.register(UINib(nibName: "ConferenceRoomDetailedTVC", bundle: nil), forCellReuseIdentifier: "ConferenceRoomDetailedTVC")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        
        self.loadingIndicator = getGlobalLoadingIndicator(in: self.tableView)
        self.tableView.addSubview(self.loadingIndicator!)
        
        self.tableView.spr_setTextHeader { [weak self] in
            self?.tableView.reloadData()
        }
        
        guard let conferenceRoom = self.conferenceRoom else {
            fatalError("Did not provide conferenceRoom object for ConferenceRoomProfileTVC.")
        }
        // Do any additional setup after loading the view.
        if self.dataController == nil {
            self.dataController = RoomReservationVCDataController(delegate: self)
        }
        self.dataController?.setConferenceRoom(with: conferenceRoom)
//        if let startDate = self.startDate {
//            self.dataController?.setSelectedStartDate(with: startDate)
//        }
//        if let endDate = self.endDate {
//            self.dataController?.setSelectedEndDate(with: endDate)
//        }

    }
    
    
}

extension RoomReservationVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section.type {
        case .bio:
            return 1
        case .none:
            return 0
        case .eventName:
            return 1
        case .eventDescription:
            return 1
        case .inviteOthers:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var topCell: FormTVCell?
        let section = sections[indexPath.section]
        switch section.type {
        case .bio:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ConferenceRoomDetailedTVC", for: indexPath) as? ConferenceRoomDetailedTVC,
                let conferenceRoom = self.conferenceRoom else {
                    return UITableViewCell()
            }
//            cell.configureCell(with: conferenceRoom, for: existingResDisplayStartDate, newReservationStartDate: self.dataController?.selectedStartDate, newReservationEndDate: self.dataController?.selectedEndDate)
            cell.setDelegate(with: self)
            return cell
        case .none:
            return UITableViewCell()
        case .eventName:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTVCell") as? FormTVCell else {
                return UITableViewCell()
            }
            if let name = self.dataController?.eventName {
                section.selectedButtonTitle = name
            } else {
                section.selectedButtonTitle = nil
            }
            topCell = cell
        case .eventDescription:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTVCell") as? FormTVCell else {
                return UITableViewCell()
            }
            if let description = self.dataController?.eventDescription {
                section.selectedButtonTitle = description
            } else {
                section.selectedButtonTitle = nil
            }
            topCell = cell
        case .inviteOthers:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTVCell") as? FormTVCell else {
                return UITableViewCell()
            }
            if let attendees = self.dataController?.invitedUsers,
                attendees.count > 0 {
                let userNames = attendees.map { (user) -> String in
                    return user.displayName ?? ""
                }
                section.selectedButtonTitle = userNames.joined(separator: ", ")
            } else {
                section.selectedButtonTitle = nil
            }
            topCell = cell
        }
        topCell?.configureCell(with: section, delegate: self)
        return topCell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RoomReservationVC: RoomReservationVCDataControllerDelegate {
    func didFinishSubmittingData(withError error: Error?) {
        return
    }
    
    func startLoadingIndicator() {
        self.loadingIndicator?.startAnimating()
    }
    
    func stopLoadingIndicator() {
        self.loadingIndicator?.stopAnimating()
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
}

extension RoomReservationVC: ConferenceRoomDetailedTVCDelegate {
    func didTapWhenDateButton() {
        return
    }
    
    func didTapStartDateButton() {
        return
    }
    
    func didTapEndDateButton() {
        return
    }
    
    func didChooseNewDates(start: Date, end: Date) {
        return
    }
    
    func didFindConflict() {
        return
    }
}

extension RoomReservationVC: DateTimeInputVCDelegate, TextInputVCDelegate, ChooseTVCDelegate {
    func didSaveInput(with date: Date, and identifier: String?) {
        return
    }
    
    func didSaveInput(with text: String, and identifier: String?) {
        return
    }
    
    func didChooseEmployees(employees: [AirUser]) {
        return
    }
}

extension RoomReservationVC: FormTVCellDelegate {
    func didSelectCellButton(withObject object: PageSection) {
        return 
    }
}
