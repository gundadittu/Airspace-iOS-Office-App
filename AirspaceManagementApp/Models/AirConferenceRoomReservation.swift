//
//  AirConferenceRoomReservation.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/20/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import FirebaseFirestore

class AirConferenceRoomReservation : NSObject {
    var uid: String?
    var startingDate: Date?
    var endDate: Date?
    var note: String?
    var conferenceRoom: AirConferenceRoom?
    var conferenceRoomUID: String?
    var title: String?
    // var user: AirUser?
    
//    public init?(startingDate: Date, endDate: Date, conferenceRoom: AirConferenceRoom?) {
//        self.startingDate = startingDate
//        self.endDate = endDate
//        self.conferenceRoom = conferenceRoom
//    }
    
    public init?(dict: [String: Any]) {
        
        if let uid = dict["uid"] as? String {
            self.uid = uid
        } else {
            print("No uid found for conference room reservation")
            return nil
        }
        
        if let timestampDict = dict["startDate"] as? [String:Any],
            let seconds = timestampDict["_seconds"] as? Int64,
            let nanoseconds = timestampDict["_nanoseconds"] as? Int32 {
            self.startingDate = Timestamp(seconds: seconds, nanoseconds: nanoseconds).dateValue()
        } else {
            print("No startDate found for conference room reservation")
            return nil
        }
        
        if let timestampDict = dict["endDate"] as? [String:Any],
            let seconds = timestampDict["_seconds"] as? Int64,
            let nanoseconds = timestampDict["_nanoseconds"] as? Int32 {
            self.endDate = Timestamp(seconds: seconds, nanoseconds: nanoseconds).dateValue()
        } else {
            print("No endDate found for conference room reservation")
            return nil
        }
        
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
        }
        
        if let conferenceRoomDict = dict["conferenceRoom"] as? [String: Any],
            let conferenceRoom = AirConferenceRoom(dict: conferenceRoomDict) {
            self.conferenceRoom = conferenceRoom
        } else {
            print("No conferenceRoom found for conference room reservation")
        }
    }
    
    func getDateInterval() -> DateInterval? {
        guard let startDate = self.startingDate, let endDate = self.endDate else {
            return nil
        }
        return DateInterval(start: startDate, end: endDate)
    }
}
