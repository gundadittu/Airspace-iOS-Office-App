//
//  ReserveVCSection.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/28/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

class ReserveVCSection: PageSection {
    var title: String?
    var type: ReserveVCSectionType?
    
    public init(type: ReserveVCSectionType) {
        self.title = type.description
        self.type = type
    }
}

enum ReserveVCConfiguration {
    case conferenceRooms
    case hotDesks
}

enum ReserveVCSectionType {
    case quickReserveRoom
    case quickReserveDesk
    case reserveDesk
    case reserveRoom
    case allRooms
    case allDesks
//    case recentReservations
//    case freeToday
//    case onYourFloor
    
    var description: String {
        switch self {
        case .quickReserveRoom:
            return ""
        case .quickReserveDesk:
            return ""
        case .reserveDesk:
            return "Find a Hot Desk"
        case .reserveRoom:
            return "Find a Conference Room"
        case .allRooms:
            return ""
        case .allDesks:
            return ""
        }
    }
}
