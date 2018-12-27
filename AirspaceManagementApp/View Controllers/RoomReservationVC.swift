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
import CFAlertViewController

enum RoomReservationVCSectionType {
    case bio
    case eventName
    case eventDescription
    case inviteOthers
    case cancelReservation
    case saveChanges
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
    var sections = [RoomReservationVCSection(title: "Bio", buttonTitle: nil, type: .bio), RoomReservationVCSection(title: "Change Event Name", buttonTitle: "Enter Name", type: .eventName), RoomReservationVCSection(title: "Change Event Description (optional)", buttonTitle: "Enter Description", type: .eventDescription), RoomReservationVCSection(title: "Modify Attendees", buttonTitle: "Choose Attendees", type: .inviteOthers), RoomReservationVCSection(title: "Cancel Reservation", buttonTitle: "", type: .cancelReservation), RoomReservationVCSection(title: "Save Changes", buttonTitle: "", type: .saveChanges)]
    
    var loadingIndicator: NVActivityIndicatorView?
    var dataController: RoomReservationVCDataController?
    var conferenceRoomReservation: AirConferenceRoomReservation?
    var existingResDisplayStartDate = Date() // date used to display existing reservations for room
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "FormTVCell", bundle: nil), forCellReuseIdentifier: "FormTVCell")
        self.tableView.register(UINib(nibName: "ConferenceRoomDetailedTVC", bundle: nil), forCellReuseIdentifier: "ConferenceRoomDetailedTVC")
        self.tableView.register(UINib(nibName: "FormSubmitTVCell", bundle: nil), forCellReuseIdentifier: "FormSubmitTVCell")

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        
        self.loadingIndicator = getGlobalLoadingIndicator(in: self.tableView)
        self.tableView.addSubview(self.loadingIndicator!)
        
        self.title = "My Reservation"
        
        self.tableView.spr_setTextHeader { [weak self] in
            self?.tableView.reloadData()
        }
        
        guard let reservation = self.conferenceRoomReservation else {
            fatalError("Did not provide conferenceRoomReservation object for ConferenceRoomProfileTVC.")
        }
        if self.dataController == nil {
            self.dataController = RoomReservationVCDataController(delegate: self)
        }
        self.dataController?.setConferenceRoomReservation(with: reservation)
        self.existingResDisplayStartDate = reservation.startingDate?.getBeginningOfDay ?? Date()
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
        case .cancelReservation:
            return 1
        case .saveChanges:
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
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ConferenceRoomDetailedTVC", for: indexPath) as? ConferenceRoomDetailedTVC else {
                    return UITableViewCell()
            }
            
            if let conferenceRoom = self.dataController?.conferenceRoom,
                let start = self.dataController?.selectedStartDate,
                let end = self.dataController?.selectedEndDate {
//                cell.whenDateBtn.isEnabled = false
                cell.conferenceRoomReservation = self.conferenceRoomReservation
                cell.configureCell(with: conferenceRoom, for: start, newReservationStartDate: start, newReservationEndDate: end)
            }
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
        case .cancelReservation:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormSubmitTVCell") as? FormSubmitTVCell else {
                return UITableViewCell()
            }
            cell.configureCell(with: section, delegate: self)
            return cell
        case .saveChanges:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormSubmitTVCell") as? FormSubmitTVCell else {
                return UITableViewCell()
            }
            cell.configureCell(with: section, delegate: self)
            return cell 
        }
        topCell?.configureCell(with: section, delegate: self)
        return topCell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDateInputVC",
            let destination = segue.destination as? DateTimeInputVC,
            let identifier = sender as? String {
            destination.delegate = self
            destination.identifier = identifier
            
            if (identifier == "chooseReservationDate") {
                destination.mode = .date
                destination.minimumDate = Date()
                destination.initialDate = self.existingResDisplayStartDate
            } else if (identifier == "chooseStartDate") {
                destination.mode = .time
                
                if let initialDate = self.dataController?.selectedStartDate {
                    destination.initialDate = initialDate
                } else {
                    destination.initialDate = self.existingResDisplayStartDate
                }
            } else if (identifier == "chooseEndDate") {
                destination.mode = .time
                
                if let startDate = self.dataController?.selectedStartDate {
                    destination.minimumDate = startDate
                }
                
                if let initialDate = self.dataController?.selectedEndDate {
                    destination.initialDate = initialDate
                } else {
                    destination.initialDate = self.existingResDisplayStartDate
                }
                
            }
        } else if segue.identifier == "toTextInputVC",
            let destination = segue.destination as? TextInputVC,
            let identifier = sender as? String {
            if identifier == "name" {
                destination.initialText = self.dataController?.eventName
                destination.title = "Modify Event Name"
            } else if identifier == "description" {
                destination.initialText = self.dataController?.eventDescription
                destination.title = "Modify Event Description"
            }
            destination.identifier = identifier
            destination.delegate = self
        } else if segue.identifier == "toChooseTVC",
            let destination = segue.destination as? ChooseTVC {
            destination.type = .employees
            destination.delegate = self
            destination.officeObj = self.dataController?.conferenceRoom?.offices?.first // we know not nil since segue will not be executed otherwise
            if let employees = self.dataController?.invitedUsers {
                destination.selectedEmployees = employees
            }
        }
    }
}

extension RoomReservationVC: RoomReservationVCDataControllerDelegate {
    func didFinishSubmittingData(withError error: Error?) {
        if let _ = error {
            let banner = NotificationBanner(title: "Woops!", subtitle: "We are unable to modify your reservation currently. Try again later.", leftView: nil, rightView: nil, style: .warning, colors: nil)
            banner.show()
        } else {
            let alertController = CFAlertViewController(title: "Get Working!🤟🏼 ", message: "Your reservations has been updated.", textAlignment: .left, preferredStyle: .alert, didDismissAlertHandler: nil)
            
            let action = CFAlertAction(title: "Sounds Good", style: .Default, alignment: .right, backgroundColor: globalColor, textColor: nil) { (action) in
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: ReserveVC.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
            alertController.addAction(action)
            self.present(alertController, animated: true)
        }
    }
    
    func startLoadingIndicator() {
        self.showActivityIndicator()
        self.loadingIndicator?.startAnimating()
    }
    
    func stopLoadingIndicator() {
        self.hideActivityIndicator()
        self.loadingIndicator?.stopAnimating()
        self.tableView.spr_endRefreshing()
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
}

extension RoomReservationVC: ConferenceRoomDetailedTVCDelegate {
    func didTapWhenDateButton() {
//        self.performSegue(withIdentifier: "toDateInputVC", sender: "chooseReservationDate")
        return 
    }
    
    func didTapStartDateButton() {
        self.performSegue(withIdentifier: "toDateInputVC", sender: "chooseStartDate")
    }
    
    func didTapEndDateButton() {
        self.performSegue(withIdentifier: "toDateInputVC", sender: "chooseEndDate")
    }
    
    func didChooseNewDates(start: Date, end: Date) {
        self.dataController?.setSelectedStartDate(with: start)
        self.dataController?.setSelectedEndDate(with: end)
    }
    
    func didFindConflict() {
        let alertController = CFAlertViewController(title: "Oh no!", message: "This conference room is not available during the selected time frame.", textAlignment: .center, preferredStyle: .alert, didDismissAlertHandler: nil)
        let action = CFAlertAction(title: "Ok 😕", style: .Default, alignment: .center, backgroundColor: globalColor, textColor: .black, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
}

extension RoomReservationVC: DateTimeInputVCDelegate, TextInputVCDelegate, ChooseTVCDelegate {
        
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
                
                self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .none)
            } else if identifier == "chooseStartDate" {
//                self.startDate = nil
                self.dataController?.setSelectedStartDate(with: date)
                self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .none)
            } else if identifier == "chooseEndDate" {
//                self.endDate = nil
                self.dataController?.setSelectedEndDate(with: date)
                self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .none)
            }
        }
        
        func changeInDate(interval: TimeInterval, and identifier: String?) {
            //auto increase end date after increasing start date
            if identifier == "chooseStartDate" {
                if let currEndDate = self.dataController?.selectedEndDate {
                    let newEndDate = currEndDate.addingTimeInterval(interval)
                    self.dataController?.setSelectedEndDate(with: newEndDate)
                }
            }
        }
}

extension RoomReservationVC: FormTVCellDelegate {
    func didSelectCellButton(withObject object: PageSection) {
        guard let object = object as? RoomReservationVCSection else { return }
        switch object.type {
        case .bio:
            return
        case .eventName:
            self.performSegue(withIdentifier: "toTextInputVC", sender: "name")
        case .eventDescription:
            self.performSegue(withIdentifier: "toTextInputVC", sender: "description")
        case .inviteOthers:
            if (self.dataController?.conferenceRoom?.offices?.first != nil) {
                self.performSegue(withIdentifier: "toChooseTVC", sender: nil)
            } else {
                let banner = NotificationBanner(title: "Woops!", subtitle: "We are unable to modify your reservation's attendees currently. Try again later.", leftView: nil, rightView: nil, style: .warning, colors: nil)
                banner.show()
            }
        case .none:
            return
        case .cancelReservation:
            self.handleCancellation()
        case .saveChanges:
            self.dataController?.submitData()
        }
    }
    
    func handleCancellation() {
        let alertController = CFAlertViewController(title: "Watch out!😱", message: "Are you sure you want to cancel your reservation? This action is permanent.", textAlignment: .center, preferredStyle: .alert, didDismissAlertHandler: nil)
        let action = CFAlertAction(title: "Cancel Reservation", style: .Destructive, alignment: .center, backgroundColor: .flatRed, textColor: nil) { (action) in
            self.cancelReservation()
        }
        let secondAction = CFAlertAction(title: "No, don't cancel it.", style: .Default, alignment: .center, backgroundColor: globalColor, textColor: nil, handler: nil)
        alertController.addAction(action)
        alertController.addAction(secondAction)
        self.present(alertController, animated: true)
    }
    
    func cancelReservation() {
        let errorAlertController = CFAlertViewController(title: "Oh no!", message: "We couldn't cancel your reservation. Please try again later.", textAlignment: .center, preferredStyle: .alert, didDismissAlertHandler: nil)
        let action = CFAlertAction(title: "Ok 😕", style: .Default, alignment: .center, backgroundColor: globalColor, textColor: .black, handler: nil)
        errorAlertController.addAction(action)
        
        guard let uid = self.dataController?.originalReservation?.uid else {
            self.present(errorAlertController, animated: true)
            return
        }
        self.loadingIndicator?.startAnimating()
        ReservationManager.shared.cancelRoomReservation(reservationUID: uid) { (error) in
            self.loadingIndicator?.stopAnimating()
            if let _ = error {
                self.present(errorAlertController, animated: true)
            } else {
                let alertController = CFAlertViewController(title: "Good News!", message: "Your reservations was canceled.", textAlignment: .center, preferredStyle: .alert, didDismissAlertHandler: nil)
                let action = CFAlertAction(title: "Sounds good", style: .Default, alignment: .center, backgroundColor: globalColor, textColor: .black) { (action) in
                    self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(action)
                self.present(alertController, animated: true)
            }
        }
    }
}
