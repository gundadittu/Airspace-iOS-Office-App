//
//  AirOffice.swift
//  AirspaceAdminApp
//
//  Created by Aditya Gunda on 11/10/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

class AirOffice: NSObject {
    var uid: String?
    var name: String?
    var buildingUID: String?
    var buildingName: String?
    var floor: Int?
    var roomNo: Int?
    
    public init?(dict: [String:Any]) {
        print(dict)
        if let name = dict["name"] as? String {
            self.name = name
        } else {
            print("No office name found")
        }
        
        if let floor = dict["floor"] as? Int {
            self.floor = floor
        } else {
            print("No floor found for office")
        }
        
        if let roomNo = dict["roomNo"] as? Int {
            self.roomNo = roomNo
        } else {
            print("No roomNo found for office")
        }
        
        if let uid = dict["uid"] as? String {
            self.uid = uid
        } else {
            print("No office id found")
            return nil
        }
        
        if let buildingUID = dict["buildingUID"] as? String {
            self.buildingUID = buildingUID
        } else {
            print("No buildingUID found for office")
            return nil
        }
        
        if let buildingName = dict["buildingName"] as? String {
            self.buildingName = buildingName
        } else {
            print("No buildingName found for office")
        }
    }
}

