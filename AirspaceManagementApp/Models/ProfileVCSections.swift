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

class ProfileSection: PageSection {
    var title: String?
    var seeMoreTitle: String?
    var type: ProfileSectionType?
    
    public init(title: String, seeMoreTitle: String, type: ProfileSectionType) {
        self.title = title
        self.type = type
        self.seeMoreTitle = seeMoreTitle
    }
}
