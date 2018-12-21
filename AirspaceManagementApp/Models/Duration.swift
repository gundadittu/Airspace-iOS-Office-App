//
//  Duration.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/18/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

enum Duration: Int, CaseIterable {
    case fifteen = 15
    case thirty = 30
    case oneHour = 60
    case oneHourThirtyMins = 90
    case twoHours = 120
    case threeHours = 180
    case fourHours = 240
    case fiveHours = 300
    case sixHours = 360
    
    var description: String {
        switch self {
        case .fifteen:
            return "15 mins"
        case .thirty:
            return "30 mins"
        case .oneHour:
            return "1 hr"
        case .oneHourThirtyMins:
            return "1 hr 30 mins"
        case .twoHours:
            return "2 hrs"
        case .threeHours:
            return "3 hrs"
        case .fourHours:
            return "4 hrs"
        case .fiveHours:
            return "5 hrs"
        case .sixHours:
            return "6 hrs"
        }
    }
}
