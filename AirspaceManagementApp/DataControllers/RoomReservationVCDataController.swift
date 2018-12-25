//
//  RoomReservationVCDataController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/25/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

protocol RoomReservationVCDataControllerDelegate {
    func didFinishSubmittingData(withError error: Error?)
    func startLoadingIndicator()
    func stopLoadingIndicator()
    func reloadTableView()
}

class RoomReservationVCDataController {
    var conferenceRoom: AirConferenceRoom?
    var selectedStartDate: Date?
    var selectedEndDate: Date?
    var eventName: String?
    var eventDescription: String?
    var invitedUsers = [AirUser]()
    var delegate: RoomReservationVCDataControllerDelegate?
    var originalReservation: AirConferenceRoomReservation?
    
    public init(delegate: RoomReservationVCDataControllerDelegate) {
        self.delegate = delegate
    }
    
    public func setConferenceRoom(with room: AirConferenceRoom) {
        self.conferenceRoom = room
        self.delegate?.reloadTableView()
    }
    
    public func setSelectedStartDate(with date: Date?) {
        self.selectedStartDate = date
        //        self.delegate?.reloadTableView()
    }
    
    public func setSelectedEndDate(with date: Date?) {
        self.selectedEndDate = date
        //        self.delegate?.reloadTableView()
    }
    
    public func setEventName(with name: String) {
        self.eventName = name
        self.delegate?.reloadTableView()
    }
    
    public func setEventDescription(with description: String) {
        self.eventDescription = description
        self.delegate?.reloadTableView()
    }
    
    public func setInvitedUsers(with users: [AirUser]) {
        self.invitedUsers = users
        self.delegate?.reloadTableView()
    }
    
    public func resetToOriginal() {
        guard let room = self.conferenceRoom else { return }
    }
    
    public func submitData() {
        return
    }
}
