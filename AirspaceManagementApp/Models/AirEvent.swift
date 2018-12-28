//
//  AirEvent.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/27/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import FirebaseFirestore

class AirEvent: NSObject {
    var uid: String?
    var title: String?
    var startDate: Date?
    var endDate: Date?
    var descriptionText: String?
    var address: String?
    var offices: [AirOffice]?
    
    public init?(dict: [String: Any]) {
        if let uid = dict["uid"] as? String {
            self.uid = uid
        } else {
            print("No uid found for event.")
            return nil
        }
        
        if let timestampDict = dict["startDate"] as? [String:Any],
            let seconds = timestampDict["_seconds"] as? Int64,
            let nanoseconds = timestampDict["_nanoseconds"] as? Int32 {
            self.startDate = Timestamp(seconds: seconds, nanoseconds: nanoseconds).dateValue()
        } else {
            print("No startDate found for event")
            return nil
        }
        
        if let timestampDict = dict["endDate"] as? [String:Any],
            let seconds = timestampDict["_seconds"] as? Int64,
            let nanoseconds = timestampDict["_nanoseconds"] as? Int32 {
            self.endDate = Timestamp(seconds: seconds, nanoseconds: nanoseconds).dateValue()
        } else {
            print("No endDate found for event")
            return nil
        }
        
        if let title = dict["title"] as? String {
            self.title = title
        } else {
            print("No title found for event")
        }
        
        if let descriptionText = dict["description"] as? String {
            self.descriptionText = descriptionText
        } else {
            print("No description found for event")
        }
        
        if let address = dict["address"] as? String {
            self.address = address
        } else {
            print("No address found for event")
        }
        
        if let officesDict = dict["offices"] as? [[String: Any]] {
            var airOffices = [AirOffice]()
            for office in officesDict {
                if let officeObject = AirOffice(dict: office){
                    airOffices.append(officeObject)
                }
            }
            self.offices = airOffices
        } else {
            print("No offices found for event")
        }
    }
}
