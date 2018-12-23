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

enum ConferenceRoomProfileSectionType {
    case bio
    case createCalendarEvent
    case eventName
    case eventDescription
    case inviteOthers
    case submit
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

class ConferenceRoomProfileTVC: UITableViewController {
    
    var sections = [ConferenceRoomProfileSection(title: "Bio", buttonTitle: nil, type: .bio), ConferenceRoomProfileSection(title: "", buttonTitle: nil, type: .createCalendarEvent), ConferenceRoomProfileSection(title: "Add Event Name (optional)", buttonTitle: "Enter Name", type: .eventName), ConferenceRoomProfileSection(title: "Add Event Description (optional)", buttonTitle: "Enter Description", type: .eventDescription),
        ConferenceRoomProfileSection(title: "Add Attendees (optional)", buttonTitle: "Choose Attendees", type: .inviteOthers),
        ConferenceRoomProfileSection(title: "Reserve Room", buttonTitle: nil, type: .submit)]
    var loadingIndicator: NVActivityIndicatorView?
    var dataController: ConferenceRoomProfileDataController?
    var conferenceRoom: AirConferenceRoom?
    var startingDate = Date() // date used to display existing reservations for room

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Conference Room Profile"        
          self.tableView.register(UINib(nibName: "ConferenceRoomDetailedTVC", bundle: nil), forCellReuseIdentifier: "ConferenceRoomDetailedTVC")
         self.tableView.register(UINib(nibName: "FormSubmitTVCell", bundle: nil), forCellReuseIdentifier: "FormSubmitTVCell")
        self.tableView.register(UINib(nibName: "FormTVCell", bundle: nil), forCellReuseIdentifier: "FormTVCell")

        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        
        self.loadingIndicator = getGLobalLoadingIndicator(in: self.tableView)
        self.tableView.addSubview(self.loadingIndicator!)
        
        self.tableView.spr_setTextHeader { [weak self] in
            self?.tableView.reloadData()
        }

        if self.dataController == nil {
            self.dataController = ConferenceRoomProfileDataController(delegate: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDateInputVC",
            let destination = segue.destination as? DateTimeInputVC {
            destination.delegate = self
            destination.mode = .date
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
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section.type {
        case .bio:
            return 1
        case .none:
            return 0
        case .submit:
            return 1
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
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//        let section = self.sections[indexPath.section]
//        switch section.type {
//        case .bio:
//            break
//        case .createCalendarEvent:
//            break
//        case .eventName:
//            break
//        case .eventDescription:
//            break
//        case .inviteOthers:
//            break
//        case .submit:
//            break
//        case .none:
//            break
//        }
        return false
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        switch section.type {
        case .bio:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ConferenceRoomDetailedTVC", for: indexPath) as? ConferenceRoomDetailedTVC,
            let conferenceRoom = self.conferenceRoom else {
                return UITableViewCell()
            }
            cell.configureCell(with: conferenceRoom, for: startingDate)
            cell.setDelegate(with: self)
            return cell
        case .none:
            return UITableViewCell()
        case .submit:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormSubmitTVCell") as? FormSubmitTVCell else {
                return UITableViewCell()
            }
            cell.configureCell(with: section, delegate: self)
            return cell
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
            return
        case .submit:
            self.dataController?.submitData()
        case .none:
            return
        }
//        ReservationManager.shared.createConferenceRomReservation(eventName: "test name", description: "test description", startTime: Date(), endTime: Date().addingTimeInterval(TimeInterval(3600)), conferenceRoomName: self.conferenceRoom?.name, officeAddress: self.conferenceRoom?.offices?.first?.building?.address, attendees: [["email":"adityagunda@uchicago.edu"]]) { (error) in
//            if let error = error {
//                // handle error
//                return
//            } else {
//                // handle success
//                return
//            }
//        }
    }
}

extension ConferenceRoomProfileTVC: ConferenceRoomDetailedTVCDelegate, ConferenceRoomProfileDataControllerDelegate {
    func didTapWhenDateButton() {
        // clicked when date button -> show date picker
        self.performSegue(withIdentifier: "toDateInputVC", sender: nil)
    }
    
    func startLoadingIndicator() {
        self.loadingIndicator?.startAnimating()
    }
    
    func stopLoadingIndicator() {
        self.loadingIndicator?.stopAnimating()
        self.tableView.spr_endRefreshing()
    }
    
    func didFinishSubmittingData(withError: Error?) {
        return
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
}

extension ConferenceRoomProfileTVC: DateTimeInputVCDelegate, TextInputVCDelegate, ConferenceRoomProfileSwitchCellDelegate {
    func didSaveInput(with text: String, and identifier: String?) {
        guard let identifier = identifier else { return }
        if identifier == "name" {
            self.dataController?.setEventName(with: text)
        } else if identifier == "description" {
            self.dataController?.setEventDescription(with: text)
        }
    }
    
    func didSaveInput(with date: Date) {
        self.startingDate = date
        self.tableView.reloadData()
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
