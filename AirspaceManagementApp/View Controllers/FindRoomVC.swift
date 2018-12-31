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

class FindRoomVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var sections = [ FindRoomVCSection(title: "I need a room in", buttonTitle: "Choose Office", type: .office), FindRoomVCSection(title: "starting at", buttonTitle: "Select Time", type: .startTime), FindRoomVCSection(title: "for around", buttonTitle: "Choose Duration", type: .duration), FindRoomVCSection(title: "and it needs to fit (optional)", buttonTitle: "Choose # of People", type: .capacity), FindRoomVCSection(title: "and it needs to have (optional)", buttonTitle: " Pick Amenities", type: .amenities), FindRoomVCSection(title: "Find Available Rooms", buttonTitle: "Find Available Rooms", type: .submit)]
    var loadingIndicator: NVActivityIndicatorView?
    var dataController: FindRoomVCDataController?
    var shouldAutomaticallySubmit = false
 
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Find a Conference Room"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "FormTVCell", bundle: nil), forCellReuseIdentifier: "FormTVCell")
        self.tableView.register(UINib(nibName: "FormSubmitTVCell", bundle: nil), forCellReuseIdentifier: "FormSubmitTVCell")
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false

        self.loadingIndicator = getGlobalLoadingIndicator(in: self.tableView)
        self.view.addSubview(self.loadingIndicator!)
        
        if dataController == nil {
            self.dataController = FindRoomVCDataController(delegate: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FindRoomVCtoChooseTVC",
            let destination = segue.destination as? ChooseTVC,
            let sender = sender as? ChooseTVCType {
            destination.type = sender
            destination.delegate = self
            if sender == .roomAmenities,
                let selectedAmenities = self.dataController?.selectedAmenities {
                destination.selectedAmenities = selectedAmenities
            }
        } else if segue.identifier == "FindRoomVCtoDateTimeInputVC",
            let destination = segue.destination as? DateTimeInputVC {
            destination.delegate = self
            if let initialDate = self.dataController?.selectedStartDate {
                destination.initialDate = initialDate
            }
        } else if segue.identifier == "FindRoomVCtoRoomListTVC",
            let destination = segue.destination as? RoomListTVC,
            let sender = sender as? [AirConferenceRoom] {
            destination.conferenceRooms = sender
            destination.startingDate = self.dataController?.selectedStartDate ?? Date()
            let newDataController = FindRoomVCDataController(delegate: destination)
            newDataController.configure(with: self.dataController)
            destination.dataController = newDataController
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = self.sections[indexPath.row]
        if section.type == .submit {
            return UITableView.automaticDimension
        }
        return CGFloat(110)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
                let dateString = date.localizedMedDateDescription+" at "+date.localizedDescriptionNoDate
                section.selectedButtonTitle = dateString
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
        case .none:
            break
        case .submit:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormSubmitTVCell") as? FormSubmitTVCell else {
                return UITableViewCell()
            }
            cell.configureCell(with: section, delegate: self)
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTVCell") as? FormTVCell else {
            return UITableViewCell()
        }
        cell.configureCell(with: section, delegate: self)
        return cell
    }
}

extension FindRoomVC: ChooseTVCDelegate {
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

extension FindRoomVC: FormTVCellDelegate {
    func didSelectCellButton(withObject object: PageSection) {
        guard let object = object as? FindRoomVCSection else {
            // handle error
            return
        }
        
        switch object.type {
        case .office:
            self.performSegue(withIdentifier: "FindRoomVCtoChooseTVC", sender: ChooseTVCType.offices)
        case .startTime:
            self.performSegue(withIdentifier: "FindRoomVCtoDateTimeInputVC", sender: nil)
        case .duration:
             self.performSegue(withIdentifier: "FindRoomVCtoChooseTVC", sender: ChooseTVCType.duration)
        case .capacity:
             self.performSegue(withIdentifier: "FindRoomVCtoChooseTVC", sender: ChooseTVCType.capacity)
        case .amenities:
             self.performSegue(withIdentifier: "FindRoomVCtoChooseTVC", sender: ChooseTVCType.roomAmenities)
        case .none:
            break
        case .submit:
            self.dataController?.submitData()
        }
        return
    }
}

extension FindRoomVC: FindRoomVCDataControllerDelegate {
    func didFindAvailableConferenceRooms(rooms: [AirConferenceRoom]?, error: Error?) {
        if error == nil,
            let rooms = rooms {
            self.performSegue(withIdentifier: "FindRoomVCtoRoomListTVC", sender: rooms)
        } else {
            let banner = NotificationBanner(title: "Darn it!", subtitle: "There was an issue loading available rooms. Please try again later.", leftView: nil, rightView: nil, style: .danger, colors: nil)
            banner.show()
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

extension FindRoomVC: DateTimeInputVCDelegate {
    func didSaveInput(with date: Date, and identifier: String?) {
        self.dataController?.setSelectedStartDate(with: date)
    }
}
