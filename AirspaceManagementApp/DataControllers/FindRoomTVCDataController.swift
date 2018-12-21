//
//  FindRoomTVCDataController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/18/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import NotificationBannerSwift

protocol FindRoomTVCDataControllerDelegate {
    func didFindAvailableConferenceRooms(rooms: [AirConferenceRoom]?, error: Error?)
    func startLoadingIndicator()
    func stopLoadingIndicator()
    func reloadTableView()
}

class FindRoomTVCDataController {
    var selectedOffice: AirOffice?
    var selectedDuration: Duration?
    var selectedStartDate: Date? = Date()
    var selectedCapacity: Int?
    var selectedAmenities: [RoomAmenity]?
    
    var delegate: FindRoomTVCDataControllerDelegate?
    
    public init(delegate: FindRoomTVCDataControllerDelegate) {
        self.delegate = delegate
        
        // Auto-populate office field
        UserManager.shared.getCurrentUsersOffices { (offices, error) in
            if let _ = error {
                let banner = StatusBarNotificationBanner(title: "Error loading Offices.", style: .danger)
                banner.show()
                return
            }
            
            if let offices = offices,
                let firstOffice = offices.first,
                self.selectedOffice == nil {
                self.setSelectedOffice(with: firstOffice)
                self.delegate?.reloadTableView()
            }
        }
    }
    
    public func setSelectedOffice(with office: AirOffice) {
        self.selectedOffice = office
        self.delegate?.reloadTableView()
    }
    
    public func setSelectedDuration(with duration: Duration) {
        self.selectedDuration = duration
        self.delegate?.reloadTableView()
    }
    
    public func setSelectedStartDate(with date: Date) {
        self.selectedStartDate = date
        self.delegate?.reloadTableView()
    }
    
    public func setSelectedCapacity(with capacity: Int) {
        self.selectedCapacity = capacity
        self.delegate?.reloadTableView()
    }
    
    public func setSelectedAmenities(with amenities: [RoomAmenity]) {
        self.selectedAmenities = amenities
        self.delegate?.reloadTableView()
    }
    
    func submitData() {
        guard let office = self.selectedOffice,
            let officeUID = office.uid else { return }
        self.delegate?.startLoadingIndicator()
        FindRoomManager.shared.findAvailableConferenceRooms(officeUID: officeUID, startDate: self.selectedStartDate, duration: self.selectedDuration, amenities: self.selectedAmenities, capacity: self.selectedCapacity) { (rooms, error) in
            self.delegate?.stopLoadingIndicator()
            if let error = error {
                self.delegate?.didFindAvailableConferenceRooms(rooms: nil, error: error)
            } else if let rooms = rooms {
                self.delegate?.didFindAvailableConferenceRooms(rooms: rooms, error: nil)
            }
        }
    }
}
