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
    case conferencePhone = "conferencePhone"
    case largeMonitor = "largeMonitor"
    case screenSharing = "screenSharing"
    case videoConferencing = "videoConferencing"
    case smartTV = "smartTV"
    case projector = "projector"
    case speakers = "speakers"
    case powerStrip = "powerStrip"
    case hdmiCables = "hdmiCables"
    case adapters = "adapters"
    case builtInComputer = "builtInComputer"
    case microphone = "microphone"
    case inputSwitchingEnabled = "inputSwitchingEnabled"
    
    
    var description: String {
        switch self {
        case .whiteBoard:
            return "White Board"
        case .conferencePhone:
            return "Conference Phone"
        case .largeMonitor:
            return "Large Monitor"
        case .screenSharing:
            return "Screen Sharing"
        case .videoConferencing:
            return "Video Conferencing"
        case .smartTV:
            return "Smart TV"
        case .projector:
            return "Projector"
        case .speakers:
            return "Speakers"
        case .powerStrip:
            return "Power Strip"
        case .hdmiCables:
            return "HDMI Cables"
        case .adapters:
            return "Adapters"
        case .builtInComputer:
            return "Built-in Computer"
        case .microphone:
            return "Microphone"
        case .inputSwitchingEnabled:
            return "Input Switching Enabled"
        }
    }
}
