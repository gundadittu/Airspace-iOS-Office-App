//
//  AirConferenceRoomReservation.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/20/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
class AirConferenceRoomReservation : NSObject {
    var startingDate: Date?
    var endDate: Date?
    var conferenceRoom: AirConferenceRoom?
    
    public init?(startingDate: Date, endDate: Date, conferenceRoom: AirConferenceRoom?) {
        self.startingDate = startingDate
        self.endDate = endDate
        self.conferenceRoom = conferenceRoom
    }
}
