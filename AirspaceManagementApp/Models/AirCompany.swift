//
//  AirCompany.swift
//  AirspaceAdminApp
//
//  Created by Aditya Gunda on 11/10/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

class AirCompany: NSObject  {
    var uid: String?
    var name: String?
    
    public init?(dict: [String: Any]) {
        if let name = dict["name"] as? String {
            self.name = name
        } else {
            print("No company name found")
        }
        
        if let uid = dict["uid"] as? String {
            self.uid = uid
        } else {
            print("No company id found")
            return nil
        }
    }
}

