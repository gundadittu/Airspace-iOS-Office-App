//
//  RoomAmenity.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/18/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

enum RoomAmenity: String, CaseIterable {
    case whiteBoard = "whiteBoard"
    case conferenceCallPhone = "conferenceCallPhone"
    case largeMonitor = "largeMonitor"
    case screenSharing = "screenSharing"
    case videoConferencing = "videoConferencing"
    
    var description: String {
        switch self {
        case .whiteBoard:
            return "White Board"
        case .conferenceCallPhone:
            return "Conference Call Phone"
        case .largeMonitor:
            return "Large Monitor"
        case .screenSharing:
            return "Screen Sharing"
        case .videoConferencing:
            return "Video Conferencing"
        }
    }
}
