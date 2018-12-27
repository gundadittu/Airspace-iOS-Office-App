//
//  RoomReservationVCDataController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/25/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

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
    
    public func setConferenceRoomReservation(with reservation: AirConferenceRoomReservation) {
        self.conferenceRoom = reservation.conferenceRoom
        self.selectedStartDate = reservation.startingDate
        self.selectedEndDate = reservation.endDate
        self.eventName = reservation.title
        self.eventDescription = reservation.note
        self.originalReservation = reservation
        self.invitedUsers = reservation.invitedUsers
        self.delegate?.reloadTableView()
    }
    public func setConferenceRoom(with room: AirConferenceRoom) {
        self.conferenceRoom = room
        self.delegate?.reloadTableView()
    }
    
    public func setSelectedStartDate(with date: Date?) {
        self.selectedStartDate = date
    }
    
    public func setSelectedEndDate(with date: Date?) {
        self.selectedEndDate = date
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
        guard let room = self.originalReservation else { return }
        self.setConferenceRoomReservation(with: room)
    }
    
    public func updateToOriginalTimes() {
        self.selectedStartDate = self.originalReservation?.startingDate
        self.selectedEndDate = self.originalReservation?.endDate
    }
    
    public func submitData() {
        guard let reservationUID = self.originalReservation?.uid,
            let originalStart = self.originalReservation?.startingDate,
            let originalEnd = self.originalReservation?.endDate else {
                self.delegate?.didFinishSubmittingData(withError: NSError())
                return
        }
        
        let startTime = self.selectedStartDate ?? originalStart
        let endTime = self.selectedEndDate ?? originalEnd
        
        let reservationTitle = self.eventName
        let note = self.eventDescription
        let attendees =  self.invitedUsers
        self.delegate?.startLoadingIndicator()
        ReservationManager.shared.updateConferenceRoomReservation(reservationUID: reservationUID, startTime: startTime, endTime: endTime, reservationTitle: reservationTitle, note: note, attendees: attendees) { (error) in
            self.delegate?.stopLoadingIndicator()
            self.delegate?.didFinishSubmittingData(withError: error)
        }
    }
}
