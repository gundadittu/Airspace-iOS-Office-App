//
//  AirReservation.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/25/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import FirebaseFirestore

class AirReservation: NSObject {
    var uid: String?
    var startingDate: Date?
    var endDate: Date?
    var host: AirUser?
    var cancelled: Bool?
    
    public init?(dict: [String: Any]) {
        if let uid = dict["uid"] as? String {
            self.uid = uid
        } else {
            print("No uid found for reservation")
            return nil
        }
        
        if let timestampDict = dict["startDate"] as? [String:Any],
            let seconds = timestampDict["_seconds"] as? Int64,
            let nanoseconds = timestampDict["_nanoseconds"] as? Int32 {
            self.startingDate = Timestamp(seconds: seconds, nanoseconds: nanoseconds).dateValue()
        } else {
            print("No startDate found for reservation")
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
        
        if let hostDict = dict["host"] as? [String: Any],
            let hostUser = AirUser(dictionary: hostDict) {
            self.host = hostUser
        } else {
            print("No host found for desk reservation")
        }
        
        if let cancelled = dict["cancelled"] as? Bool {
            self.cancelled = cancelled
        } else if let cancelled = dict["canceled"] as? Bool {
            // due to typo in database
            self.cancelled = cancelled
        } else {
            print("No cancelled status found for reservation")
        }
    }
    
    func getDateInterval() -> DateInterval? {
        guard let startDate = self.startingDate, let endDate = self.endDate else {
            return nil
        }
        return DateInterval(start: startDate, end: endDate)
    }
}
