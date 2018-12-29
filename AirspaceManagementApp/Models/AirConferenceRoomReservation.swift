//
//  AirConferenceRoomReservation.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/20/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

class AirConferenceRoomReservation : AirReservation {
    var note: String?
    var conferenceRoom: AirConferenceRoom?
    var conferenceRoomUID: String?
    var title: String?
    var invitedUsers = [AirUser]()
    
    override public init?(dict: [String: Any]) {
        super.init(dict: dict)
        
        if let note = dict["note"] as? String {
            self.note = note
        } else {
            print("No note found for conference room reservation")
        }
        
        if let title = dict["title"] as? String {
            self.title = title
        } else {
            print("No title found for conference room reservation")
        }
        
        if let roomUID = dict["roomUID"] as? String {
            self.conferenceRoomUID = roomUID
        } else {
            print("No conferenceRoomUID found for conference room reservation")
            return nil
        }
        
        if let conferenceRoomDict = dict["conferenceRoom"] as? [String: Any],
            let conferenceRoom = AirConferenceRoom(dict: conferenceRoomDict) {
            self.conferenceRoom = conferenceRoom
        } else {
            print("No conferenceRoom found for conference room reservation")
        }
        
        if let attendees = dict["attendees"] as? [[String: Any]] {
            var attendeeArray = [AirUser]()
            for userDict in attendees {
                if let airUser = AirUser(dictionary: userDict) {
                    attendeeArray.append(airUser)
                }
            }
            self.invitedUsers = attendeeArray
        } else {
            print("No attendees found for conference room reservation")
        }
    }
}
