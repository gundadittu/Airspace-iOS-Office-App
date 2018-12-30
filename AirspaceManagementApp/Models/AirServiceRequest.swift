//
//  AirServiceRequest.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/17/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import FirebaseFirestore

class AirServiceRequest: NSObject {
    var uid: String?
    var issueType: ServiceRequestTypeItem?
    var note: String?
    var timestamp: Date?
    var status: ServiceRequestStatus?
    var office: AirOffice?
    var title: String?
    
    public init?(dict: [String: Any]) {
        if let itString = dict["issueType"] as? String,
            let issueType = ServiceRequestTypeItem(rawValue: itString) {
            self.issueType = issueType
        } else {
            print("No type found for AirServiceRequest")
            return nil
        }
        
        if let title = dict["title"] as? String {
            self.title = title
        } else {
            print("No title found for AirServiceRequest")
        }
        
        if let note = dict["note"] as? String {
            self.note = note
        } else {
            print("No note found for AirServiceRequest")
        }
        
        if let statusString = dict["status"] as? String,
            let status = ServiceRequestStatus(rawValue: statusString) {
            self.status = status
        } else {
            print("No status found for AirServiceRequest")
        }
        
        if let timestampDict = dict["timestamp"] as? [String:Any],
            let seconds = timestampDict["_seconds"] as? Int64,
            let nanoseconds = timestampDict["_nanoseconds"] as? Int32 {
            self.timestamp = Timestamp(seconds: seconds, nanoseconds: nanoseconds).dateValue()
        } else {
            print("No timestamp found for AirServiceRequest")
        }
        
        if let officeDict = dict["office"] as? [String: Any],
            let office = AirOffice(dict: officeDict) {
            self.office = office
        } else {
            print("No office found for AirServiceRequest")
            return nil
        }
        
        if let uid = dict["uid"] as? String {
            self.uid = uid
        } else {
            print("No uid found for AirServiceRequest")
            return nil
        }
    }
    
}
