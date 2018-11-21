//
//  AirBuilding.swift
//  AirspaceAdminApp
//
//  Created by Aditya Gunda on 11/9/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

class AirBuilding {
    var name: String?
    var address: String?
    var uid: String?
    
    public init?(dict: [String: Any]){
        if let name = dict["name"] as? String {
            self.name = name
        } else {
            print("No building name found")
        }
        
        if let uid = dict["uid"] as? String {
            self.uid = uid
        } else {
            print("No building id found")
            return nil
        }
        
        if let address = dict["address"] as? String {
            self.address = address
        } else {
            print("No building address found")
            return nil
        }
    }
}

