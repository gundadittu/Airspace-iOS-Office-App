//
//  ConferenceRoomProfileTVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/20/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import SwiftPullToRefresh
import NotificationBannerSwift

enum ConferenceRoomProfileSectionType {
    case bio
    case createCalendarEvent
    case eventName
    case eventDescription
    case inviteOthers
    case none
}

class ConferenceRoomProfileSection : PageSection {
    var title = ""
    var buttonTitle = ""
    var selectedButtonTitle: String?
    var type: ConferenceRoomProfileSectionType = .none
    
    public init(title: String, buttonTitle: String?, type: ConferenceRoomProfileSectionType) {
        self.title = title
        self.type = type
        self.buttonTitle = buttonTitle ?? ""
    }
}

class ConferenceRoomProfileTVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var sections = [ConferenceRoomProfileSection(title: "Bio", buttonTitle: nil, type: .bio), ConferenceRoomProfileSection(title: "", buttonTitle: nil, type: .createCalendarEvent), ConferenceRoomProfileSection(title: "Add Event Name (optional)", buttonTitle: "Enter Name", type: .eventName), ConferenceRoomProfileSection(title: "Add Event Description (optional)", buttonTitle: "Enter Description", type: .eventDescription), ConferenceRoomProfileSection(title: "Invite Others (optional)", buttonTitle: "Choose Attendees", type: .inviteOthers)]
    var loadingIndicator: NVActivityIndicatorView?
    var dataController: ConferenceRoomProfileDataController?
    var conferenceRoom: AirConferenceRoom?
    var existingResDisplayStartDate = Date() // date used to display existing reservations for room
    var startDate: Date?
    var endDate: Date?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Conference Room Profile"        
          self.tableView.register(UINib(nibName: "ConferenceRoomDetailedTVC", bundle: nil), forCellReuseIdentifier: "ConferenceRoomDetailedTVC")
         self.tableView.register(UINib(nibName: "FormSubmitTVCell", bundle: nil), forCellReuseIdentifier: "FormSubmitTVCell")
        self.tableView.register(UINib(nibName: "FormTVCell", bundle: nil), forCellReuseIdentifier: "FormTVCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        
        
        self.loadingIndicator = getGLobalLoadingIndicator(in: self.tableView)
        self.tableView.addSubview(self.loadingIndicator!)
        
        self.tableView.spr_setTextHeader { [weak self] in
            self?.tableView.reloadData()
        }

        guard let conferenceRoom = self.conferenceRoom else {
            fatalError("Did not provide conferenceRoom object for ConferenceRoomProfileTVC.")
        }
        
        if self.dataController == nil {
            self.dataController = ConferenceRoomProfileDataController(delegate: self)
            self.dataController?.setConferenceRoom(with: conferenceRoom)
            if let startDate = self.startDate {
                self.dataController?.setSelectedStartDate(with: startDate)
            }
            if let endDate = self.endDate {
                self.dataController?.setSelectedEndDate(with: endDate)
            }
        }
        
        self.bottomViewBtn.setTitleColor(.white, for: .normal)
        self.bottomView.backgroundColor = globalColor
        self.bottomView.layer.shadowColor = UIColor.black.cgColor
        self.bottomView.layer.shadowOpacity = 0.5
        self.bottomView.layer.shadowOffset = CGSize.zero
        self.bottomView.layer.shadowRadius = 2
    }
    @IBAction func bottomViewBtnTapped(_ sender: Any) {
        self.dataController?.submitData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDateInputVC",
            let destination = segue.destination as? DateTimeInputVC,
            let identifier = sender as? String {
            destination.delegate = self
            destination.identifier = identifier

            if (identifier == "chooseReservationDate") {
                destination.mode = .date
                destination.initialDate = self.existingResDisplayStartDate
            } else if (identifier == "chooseStartDate") {
                destination.mode = .time
                destination.initialDate = self.dataController?.selectedStartDate
            } else if (identifier == "chooseEndDate") {
                destination.mode = .time
                destination.initialDate = self.dataController?.selectedEndDate
            }
        } else if segue.identifier == "toTextInputVC",
            let destination = segue.destination as? TextInputVC,
            let identifier = sender as? String {
            if identifier == "name" {
                destination.initialText = self.dataController?.eventName
                destination.title = "Add Event Name"
            } else if identifier == "description" {
                destination.initialText = self.dataController?.eventDescription
                destination.title = "Add Event Description"
            }
            destination.identifier = identifier
            destination.delegate = self
        } else if segue.identifier == "toChooseTVC",
            let destination = segue.destination as? ChooseTVC {
            destination.type = .employees
            destination.delegate = self
            destination.officeObj = self.conferenceRoom?.offices?.first // we know not nil from shouldPerformSegue()
            if let employees = self.dataController?.invitedUsers {
                destination.selectedEmployees = employees
            }
        }
    }

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
        case .createCalendarEvent:
            return 1
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
        let section = sections[indexPath.section]
        switch section.type {
        case .bio:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ConferenceRoomDetailedTVC", for: indexPath) as? ConferenceRoomDetailedTVC,
            let conferenceRoom = self.conferenceRoom else {
                return UITableViewCell()
            }
            cell.configureCell(with: conferenceRoom, for: existingResDisplayStartDate, newReservationStartDate: self.dataController?.selectedStartDate, newReservationEndDate: self.dataController?.selectedEndDate)
            cell.setDelegate(with: self)
            return cell
        case .none:
            return UITableViewCell()
        case .createCalendarEvent:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell") as? ConferenceRoomProfileSwitchCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            if let value = self.dataController?.shouldCreateCalendarEvent {
                cell.switchBtn.isOn = value
            } else {
               cell.switchBtn.isOn = true
            }
            self.dataController?.shouldCreateCalendarEvent = cell.switchBtn.isOn
            return cell
        case .eventName:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTVCell") as? FormTVCell else {
                return UITableViewCell()
            }
            if let name = self.dataController?.eventName {
                section.selectedButtonTitle = name
            } else {
                section.selectedButtonTitle = nil
            }
            cell.configureCell(with: section, delegate: self)
            return cell
        case .eventDescription:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTVCell") as? FormTVCell else {
                return UITableViewCell()
            }
            if let description = self.dataController?.eventDescription {
                section.selectedButtonTitle = description
            } else {
                section.selectedButtonTitle = nil
            }
            cell.configureCell(with: section, delegate: self)
            return cell
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
            cell.configureCell(with: section, delegate: self)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ConferenceRoomProfileTVC: FormTVCellDelegate {
    func didSelectCellButton(withObject object: PageSection) {
        guard let object = object as? ConferenceRoomProfileSection else { return }
        switch object.type {
        case .bio:
            return
        case .createCalendarEvent:
            return
        case .eventName:
            self.performSegue(withIdentifier: "toTextInputVC", sender: "name")
        case .eventDescription:
            self.performSegue(withIdentifier: "toTextInputVC", sender: "description")
        case .inviteOthers:
            if (self.conferenceRoom?.offices?.first != nil) {
                self.performSegue(withIdentifier: "toChooseTVC", sender: nil)
            }
        case .none:
            return
        }
    }
}
extension ConferenceRoomProfileTVC: ConferenceRoomProfileDataControllerDelegate {
    func didFinishSubmittingData(withError error: Error?) {
        if let _ = error {
            let banner = StatusBarNotificationBanner(title: "Error creating reservation.", style: .danger)
            banner.show()
            return
        } else {
            let banner = NotificationBanner(title: "Get Working!", subtitle: "Your reservation was sucessfully created.", leftView: nil, rightView: nil, style: .success, colors: nil)
            banner.show()
        }
    }
    
    func reloadTableView() {
        let indexSet = IndexSet(integersIn: 1..<self.sections.count)
        self.tableView.reloadSections(indexSet, with: .none)
    }
    
}

extension ConferenceRoomProfileTVC: ConferenceRoomDetailedTVCDelegate {
    
    func didFindConflict() {
        //handle conflict by displaying alert to tell user
    }
    
    func didChooseNewDates(start: Date, end: Date) {
        self.dataController?.setSelectedStartDate(with: start)
        self.dataController?.setSelectedEndDate(with: end)
    }
    
    func didTapWhenDateButton() {
        // clicked when date button -> show date picker
        self.performSegue(withIdentifier: "toDateInputVC", sender: "chooseReservationDate")
    }
    
    func didTapStartDateButton() {
        self.performSegue(withIdentifier: "toDateInputVC", sender: "chooseStartDate")
    }
    
    func didTapEndDateButton() {
        self.performSegue(withIdentifier: "toDateInputVC", sender: "chooseEndDate")
    }
    
    func startLoadingIndicator() {
        self.loadingIndicator?.startAnimating()
    }
    
    func stopLoadingIndicator() {
        self.loadingIndicator?.stopAnimating()
        self.tableView.spr_endRefreshing()
    }
}

extension ConferenceRoomProfileTVC: DateTimeInputVCDelegate, TextInputVCDelegate, ConferenceRoomProfileSwitchCellDelegate, ChooseTVCDelegate {
    
    func didSaveInput(with text: String, and identifier: String?) {
        guard let identifier = identifier else { return }
        if identifier == "name" {
            self.dataController?.setEventName(with: text)
        } else if identifier == "description" {
            self.dataController?.setEventDescription(with: text)
        }
    }
    
    func didChooseEmployees(employees: [AirUser]) {
       self.dataController?.setInvitedUsers(with: employees)
    }
    
    func didSaveInput(with date: Date, and identifier: String?) {
        if identifier == "chooseReservationDate" {
            self.existingResDisplayStartDate = date
            
            self.dataController?.setSelectedStartDate(with: nil)
            self.dataController?.setSelectedEndDate(with: nil)

            //need to clear old selection
            self.startDate = nil
            self.endDate = nil
            
            self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .none)
        } else if identifier == "chooseStartDate" {
            self.startDate = nil
            self.dataController?.setSelectedStartDate(with: date)
            self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .none)
        } else if identifier == "chooseEndDate" {
            self.endDate = nil
            self.dataController?.setSelectedEndDate(with: date)
            self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .none)
        }

    }
    
    func switchDidChangeValue(to value: Bool) {
        self.dataController?.setShouldCreateCalendarEvent(with: value)
    }
}

protocol ConferenceRoomProfileSwitchCellDelegate {
    func switchDidChangeValue(to value: Bool)
}

class ConferenceRoomProfileSwitchCell: UITableViewCell {
    @IBOutlet weak var switchBtn: UISwitch!
    var delegate: ConferenceRoomProfileSwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.switchBtn.onTintColor = globalColor
        self.switchBtn.isOn = true
    }
    
    @IBAction func didToggleSwitch(_ sender: Any) {
        guard let sender = sender as? UISwitch else { return }
        self.delegate?.switchDidChangeValue(to: sender.isOn)
    }
    public func shouldCreateCalendarInvite() -> Bool {
        return self.switchBtn.isOn
    }
}
