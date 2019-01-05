//
//  PageSection.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 11/19/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

class PageSection {
    
}

enum MainVCSectionType {
    case quickActions
    case reservationsToday
    //    case nearbyEats
    case none
}

class MainVCSection: PageSection {
    var title = ""
    var type: MainVCSectionType = .none
    
    public init(title: String, type: MainVCSectionType) {
        self.title = title
        self.type = type
    }
}

enum MyGuestRegTVCType {
    case upcoming
    case past
    case none
}

class MyGuestRegTVCSection: PageSection {
    var title: String?
    var type: MyGuestRegTVCType = .none
    
    public init(title: String, type: MyGuestRegTVCType) {
        self.title = title
        self.type = type
    }
}

enum MyServReqTVCType {
    case open
    case pending
    case closed
    case none
}

class MyServReqTVCSection: PageSection {
    var title: String?
    var type: MyServReqTVCType = .none
    
    public init(title: String, type: MyServReqTVCType) {
        self.title = title
        self.type = type
    }
}

class FindRoomVCSection: PageSection {
    var title = ""
    var buttonTitle = ""
    var selectedButtonTitle: String?
    var type: FindRoomVCSectionType = .none
    
    public init(title: String, buttonTitle: String, type: FindRoomVCSectionType) {
        self.title = title
        self.buttonTitle = buttonTitle
        self.type = type
    }
}

enum FindRoomVCSectionType {
    case office
    case startTime
    case duration
    case capacity
    case amenities
    case submit
    case none
}

enum ConferenceRoomProfileSectionType {
    case bio
    case createCalendarEvent
    case eventName
    case eventDescription
    case inviteOthers
    case submit
    case none
}

class ConferenceRoomProfileSection : PageSection {
    var title = ""
    var buttonTitle = ""
    var selectedButtonTitle: String?
    var type: ConferenceRoomProfileSectionType = .none
    
    public init(title: String, buttonTitle: String?, type: ConferenceRoomProfileSectionType) {
        self.title = title
        self.type = type
        self.buttonTitle = buttonTitle ?? ""
    }
}

enum SettingsTVCSectionType {
    case notifications
    case contact
    case terms
    case privacyPolicy
    case acknowledgments
    case logOut
    case version
}

class SettingsTVCSection: PageSection {
    var title: String?
    var type: SettingsTVCSectionType?
    
    public init(title: String, type: SettingsTVCSectionType) {
        self.title = title
        self.type = type
    }
}

enum RoomReservationVCSectionType {
    case bio
    case eventName
    case eventDescription
    case inviteOthers
    case cancelReservation
    case saveChanges
    case none
}

class RoomReservationVCSection: PageSection {
    var type: RoomReservationVCSectionType = .none
    var buttonTitle = ""
    var selectedButtonTitle: String?
    var title: String?
    
    public init(title: String, buttonTitle: String?, type: RoomReservationVCSectionType) {
        self.title = title
        self.type = type
        self.buttonTitle = buttonTitle ?? ""
    }
}

enum EventProfileTVCSectionType {
    case bio
    case description
    case none
}

class FindDeskVCSection: PageSection {
    var title = ""
    var buttonTitle = ""
    var selectedButtonTitle: String?
    var type: FindDeskVCSectionType = .none
    
    public init(title: String, buttonTitle: String, type: FindDeskVCSectionType) {
        self.title = title
        self.buttonTitle = buttonTitle
        self.type = type
    }
}

enum FindDeskVCSectionType {
    case office
    case startTime
    case duration
    case submit
    case none
}

enum DeskReservationVCSectionType {
    case bio
    case cancelReservation
    case saveChanges
    case none
}

class DeskReservationVCSection: PageSection {
    var type: DeskReservationVCSectionType = .none
    var buttonTitle = ""
    var selectedButtonTitle: String?
    var title: String?
    
    public init(title: String, buttonTitle: String?, type: DeskReservationVCSectionType) {
        self.title = title
        self.type = type
        self.buttonTitle = buttonTitle ?? ""
    }
}

class ServiceRequestVCSection: PageSection {
    var title = ""
    var buttonTitle = ""
    var selectedButtonTitle: String?
    var type: ServiceRequestVCSectionType = .none
    
    public init(title: String, buttonTitle: String, type: ServiceRequestVCSectionType) {
        self.title = title
        self.buttonTitle = buttonTitle
        self.type = type
    }
}

enum ServiceRequestVCSectionType {
    case location
    case serviceType
    case image
    case note
    case submit
    case none
}

class RegisterGuestVCSection: PageSection {
    var title = ""
    var buttonTitle = ""
    var selectedButtonTitle: String?
    var type: RegisterGuestVCSectionType = .none
    
    public init(title: String, buttonTitle: String, type: RegisterGuestVCSectionType) {
        self.title = title
        self.buttonTitle = buttonTitle
        self.type = type
    }
}

enum RegisterGuestVCSectionType {
    case office
    case name
    case dateTime
    case email
    case submit
    case none
}

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
            return "Find a conference room today for"
        case .quickReserveDesk:
            return "Find a hot desk today for"
        case .reserveDesk:
            return "Find a hot desk"
        case .reserveRoom:
            return "Find a conference room"
        case .allRooms:
            return "All Your Conference Rooms"
        case .allDesks:
            return "All Your Hot Desks"
        }
    }
}

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
