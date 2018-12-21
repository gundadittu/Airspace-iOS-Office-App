//
//  RoomAmenity.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/18/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

enum RoomAmenity: String, CaseIterable {
    case appleTV = "appletv"
    case whiteBoard = "whiteboard"
    
    var description: String {
        switch self {
        case .appleTV:
            return "Apple TV"
        case .whiteBoard:
            return "White Board"
        }
    }
}
