//
//  ProfileSections.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/23/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

enum ProfileSectionType {
    case bioInfo
    case myRoomReservations
    case myDeskReservations
    case myServiceRequests
    case myRegisteredGuests
}

class ProfileSection: NSObject {
    var type: ProfileSectionType?
    
    public init(type: ProfileSectionType) {
        self.type = type 
    }
}
