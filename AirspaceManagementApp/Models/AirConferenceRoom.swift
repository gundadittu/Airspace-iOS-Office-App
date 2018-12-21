//
//  AirConferenceRoom.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/20/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

class AirConferenceRoom: NSObject {
    var name: String?
    var uid: String?
    var offices: [AirOffice]?
    var amenities: [RoomAmenity]?
    var capacity: Int?
    var active: Bool?
    var reserveable: Bool?
    
    public init?(dict: [String: Any]) {
        if let name = dict["name"] as? String {
            self.name = name
        } else {
            print("No conference room name found")
        }
        
        if let uid = dict["uid"] as? String {
            self.uid = uid
        } else {
            print("No conference room id found")
            return nil
        }
        
        if let offices = dict["offices"] as? [[String: Any]] {
            var airOffices = [AirOffice]()
            for x in offices {
                if let ao = AirOffice(dict: x) {
                    airOffices.append(ao)
                }
            }
            self.offices = airOffices
        } else {
            print("No conference room offices found")
        }
        
        if let amenities = dict["amenities"] as? [String] {
            var roomAmenities = [RoomAmenity]()
            for x in amenities {
                if let ra = RoomAmenity(rawValue: x) {
                    roomAmenities.append(ra)
                }
            }
            self.amenities = roomAmenities
        } else {
            print("No conference room amenities found")
        }
        
        if let capacity = dict["capacity"] as? Int {
            self.capacity = capacity
        } else {
            print("No conference room capacity found")
        }
        
        if let active = dict["active"] as? Bool {
            self.active = active
        } else {
            print("No active status found for conference room")
        }
        
        if let reserveable = dict["reserveable"] as? Bool {
            self.reserveable = reserveable
        } else {
            print("No reserveable status found for conference room")
        }
    }

}
