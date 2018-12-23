//
//  ConferenceRoomProfileDataController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/22/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation


protocol ConferenceRoomProfileDataControllerDelegate {
    func didFinishSubmittingData(withError: Error?)
    func startLoadingIndicator()
    func stopLoadingIndicator()
    func reloadTableView()
}

class ConferenceRoomProfileDataController {
    var conferenceRoom: AirConferenceRoom?
    var selectedStartDate: Date?
    var selectedEndDate: Date?
    var eventName: String?
    var eventDescription: String?
    var shouldCreateCalendarEvent: Bool?
    var invitedUsers = [AirUser]()
    var delegate: ConferenceRoomProfileDataControllerDelegate?
    
    public init(delegate: ConferenceRoomProfileDataControllerDelegate) {
        self.delegate = delegate
    }
    
    public func setConferenceRoom(with room: AirConferenceRoom) {
        self.conferenceRoom = room
        self.delegate?.reloadTableView()
    }
    
    public func setSelectedStartDate(with date: Date) {
        self.selectedStartDate = date
        self.delegate?.reloadTableView()
    }
    
    public func setSelectedEndDate(with date: Date) {
        self.selectedEndDate = date
        self.delegate?.reloadTableView()
    }
    
    public func setEventName(with name: String) {
        self.eventName = name
        self.delegate?.reloadTableView()
    }
    
    public func setEventDescription(with description: String) {
        self.eventDescription = description
        self.delegate?.reloadTableView()
    }
    
    public func setShouldCreateCalendarEvent(with value: Bool) {
        self.shouldCreateCalendarEvent = value
        self.delegate?.reloadTableView()
    }
    
    public func setInvitedUsers(with users: [AirUser]) {
        self.invitedUsers = users
        self.delegate?.reloadTableView()
    }
    
    public func submitData() {
        return
    }
}
