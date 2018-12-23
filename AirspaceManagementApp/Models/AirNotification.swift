//
//  AirNotification.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/23/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

enum AirNotificationType: String {
    case serviceRequestStatusChange = "serviceRequestStatusChange"
    
    var title: String {
        switch self {
        case .serviceRequestStatusChange:
            return "Update on your Service Request"
        }
    }
}

class AirNotification: NSObject {
    var uid: String?
    var type: AirNotificationType?
    var readStatus: Bool?
    var data: [String: Any]?
    
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
    }
}
