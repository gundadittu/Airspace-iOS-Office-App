//
//  ReserveRoomVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/18/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit
import NotificationBannerSwift
import NVActivityIndicatorView
import CFAlertViewController

class FindRoomTVCSection: PageSection {
    var title = ""
    var buttonTitle = ""
    var selectedButtonTitle: String?
    var type: FindRoomTVCSectionType = .none
    
    public init(title: String, buttonTitle: String, type: FindRoomTVCSectionType) {
        self.title = title
        self.buttonTitle = buttonTitle
        self.type = type
    }
}

enum FindRoomTVCSectionType {
    case office
    case startTime
    case duration
    case capacity
    case amenities
    case submit
//    case repeatEvent
//    case note
//    case title
    case none
}

class FindRoomTVC: UITableViewController {

    var sections = [ FindRoomTVCSection(title: "I need a room in", buttonTitle: "Choose Office", type: .office), FindRoomTVCSection(title: "starting at", buttonTitle: "Select Time", type: .startTime), FindRoomTVCSection(title: "for around", buttonTitle: "Choose Duration", type: .duration), FindRoomTVCSection(title: "and it needs to fit (optional)", buttonTitle: "Choose # of People", type: .capacity), FindRoomTVCSection(title: "and it needs to have (optional)", buttonTitle: " Pick Amenities", type: .amenities), FindRoomTVCSection(title: "Find", buttonTitle: "Show Available Rooms", type: .submit)]
    var loadingIndicator: NVActivityIndicatorView?
    var dataController: FindRoomTVCDataController?
    var shouldAutomaticallySubmit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Find a Conference Room"
        
        self.tableView.register(UINib(nibName: "FormTVCell", bundle: nil), forCellReuseIdentifier: "FormTVCell")
        self.tableView.register(UINib(nibName: "FormSubmitTVCell", bundle: nil), forCellReuseIdentifier: "FormSubmitTVCell")
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false

        self.loadingIndicator = getGLobalLoadingIndicator(in: self.tableView)
        self.view.addSubview(self.loadingIndicator!)
        
        if dataController == nil {
            self.dataController = FindRoomTVCDataController(delegate: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FindRoomTVCtoChooseTVC",
            let destination = segue.destination as? ChooseTVC,
            let sender = sender as? ChooseTVCType {
            destination.type = sender
            destination.delegate = self
            if sender == .roomAmenities,
                let selectedAmenities = self.dataController?.selectedAmenities {
                destination.selectedAmenities = selectedAmenities
            }
        } else if segue.identifier == "FindRoomTVCtoDateTimeInputVC",
            let destination = segue.destination as? DateTimeInputVC {
            destination.delegate = self
            if let initialDate = self.dataController?.selectedStartDate {
                destination.initialDate = initialDate
            }
        } else if segue.identifier == "FindRoomTVCtoRoomListTVC",
            let destination = segue.destination as? RoomListTVC,
            let sender = sender as? [AirConferenceRoom] {
            destination.conferenceRooms = sender
            destination.startingDate = self.dataController?.selectedStartDate ?? Date()
            let newDataController = FindRoomTVCDataController(delegate: destination)
            newDataController.configure(with: self.dataController)
            destination.dataController = newDataController
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
        return CGFloat(110)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = self.sections[indexPath.row]
        switch section.type {
        case .office:
            if let office = self.dataController?.selectedOffice {
                section.selectedButtonTitle = office.name
            } else {
                section.selectedButtonTitle = nil
            }
        case .startTime:
            if let date = self.dataController?.selectedStartDate {
                section.selectedButtonTitle = date.localizedDescription
            } else {
                section.selectedButtonTitle = nil
            }
        case .duration:
            if let dur = self.dataController?.selectedDuration {
                section.selectedButtonTitle = dur.description
            } else {
                section.selectedButtonTitle = nil
            }
        case .capacity:
            if let capacity = self.dataController?.selectedCapacity {
                section.selectedButtonTitle = (capacity == 1) ? "1 person" : "\(capacity) people"
            } else {
                section.selectedButtonTitle = nil
            }
        case .amenities:
            if let amenities = self.dataController?.selectedAmenities {
                let amenityTitles =  amenities.map { (amenity) -> String in
                    return amenity.description
                }
                section.selectedButtonTitle = amenityTitles.joined(separator: ", ")
            } else {
                section.selectedButtonTitle = nil
            }
        case .submit:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormSubmitTVCell") as? FormSubmitTVCell else {
                return UITableViewCell()
            }
            cell.configureCell(with: section, delegate: self)
            return cell
        case .none:
            break
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTVCell") as? FormTVCell else {
            return UITableViewCell()
        }
        cell.configureCell(with: section, delegate: self)
        return cell
    }
}

extension FindRoomTVC: ChooseTVCDelegate {
    func didSelectOffice(office: AirOffice) {
       self.dataController?.setSelectedOffice(with: office)
    }
    
    func didSelectDuration(duration: Duration) {
        self.dataController?.setSelectedDuration(with: duration)
    }
    
    func didSelectCapacity(number: Int) {
        self.dataController?.setSelectedCapacity(with: number)
    }
    
    func didSelectRoomAmenities(amenities: [RoomAmenity]) {
        self.dataController?.setSelectedAmenities(with: amenities)
    }
}

extension FindRoomTVC: FormTVCellDelegate {
    func didSelectCellButton(withObject object: PageSection) {
        guard let object = object as? FindRoomTVCSection else {
            // handle error
            return
        }
        
        switch object.type {
        case .office:
            self.performSegue(withIdentifier: "FindRoomTVCtoChooseTVC", sender: ChooseTVCType.offices)
        case .startTime:
            self.performSegue(withIdentifier: "FindRoomTVCtoDateTimeInputVC", sender: nil)
        case .duration:
             self.performSegue(withIdentifier: "FindRoomTVCtoChooseTVC", sender: ChooseTVCType.duration)
        case .capacity:
             self.performSegue(withIdentifier: "FindRoomTVCtoChooseTVC", sender: ChooseTVCType.capacity)
        case .amenities:
             self.performSegue(withIdentifier: "FindRoomTVCtoChooseTVC", sender: ChooseTVCType.roomAmenities)
        case .submit:
            guard (self.loadingIndicator?.isAnimating == false ||  self.loadingIndicator == nil) else { return }
            self.dataController?.submitData()
        case .none:
            break
        }
        return
    }
}

extension FindRoomTVC: FindRoomTVCDataControllerDelegate {
    func didFindAvailableConferenceRooms(rooms: [AirConferenceRoom]?, error: Error?) {
        if error == nil,
            let rooms = rooms {
            self.performSegue(withIdentifier: "FindRoomTVCtoRoomListTVC", sender: rooms)
        }
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

extension FindRoomTVC: DateTimeInputVCDelegate {
    func didSaveInput(with date: Date) {
        self.dataController?.setSelectedStartDate(with: date)
    }
}
