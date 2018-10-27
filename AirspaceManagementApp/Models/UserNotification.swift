//
//  UserNotification.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/22/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

enum UserNotificationType {
    case buildingAnnouncement
    case guestArrival
    case servReqStatusChange
    case serReqAssigned
    case newEvent
    case upcomingEvent
    case unknown
}

class UserNotification: NSObject {
    var title: String?
    var body: String?
    var type: UserNotificationType?
    
    public init(title: String, body: String, type: UserNotificationType) {
        self.title = title
        self.body = body
        self.type = type
    }
}
