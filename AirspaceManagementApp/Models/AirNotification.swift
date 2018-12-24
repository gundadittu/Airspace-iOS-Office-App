//
//  AirNotification.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/23/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum AirNotificationType: String {
    case serviceRequestUpdate = "serviceRequestUpdate"
    case arrivedGuestUpdate = "arrivedGuestUpdate"
    
    var title: String {
        switch self {
        case .serviceRequestUpdate:
            return "Service request update"
        case .arrivedGuestUpdate:
            return "Your guest has arrived"
        }
    }
}

class AirNotification: NSObject {
    var uid: String?
    var type: AirNotificationType?
    var readStatus: Bool?
    var data: [String: Any]?
    var timestamp: Date?
    var title: String?
    var body: String?
    
    public init?(dict: [String: Any]) {
        
        if let uid = dict["uid"] as? String {
            self.uid = uid
        } else {
            print("No uid found for AirNotification")
            return nil
        }
        
        if let typeRawValue = dict["type"] as? String,
            let type = AirNotificationType(rawValue: typeRawValue) {
            self.type = type
        } else {
            print("No type found for AirNotification")
            return nil
        }
        
        if let title = dict["title"] as? String {
            self.title = title
        } else {
            print("No title found for AirNotification")
            return nil
        }
        
        if let body = dict["body"] as? String {
            self.body = body
        } else {
            print("No body found for AirNotification")
            return nil
        }
        
        if let readStatus = dict["readStatus"] as? Bool {
            self.readStatus = readStatus
        } else {
            print("No readStatus found for AirNotification")
        }
        
        if let data = dict["data"] as? [String:Any] {
            self.data = data
        } else {
            print("No data found for AirNotification")
        }
        
        if let timestampDict = dict["timestamp"] as? [String:Any],
            let seconds = timestampDict["_seconds"] as? Int64,
            let nanoseconds = timestampDict["_nanoseconds"] as? Int32 {
            self.timestamp = Timestamp(seconds: seconds, nanoseconds: nanoseconds).dateValue()
        } else {
            print("No timestamp found for AirNotification")
        }
    }
}
