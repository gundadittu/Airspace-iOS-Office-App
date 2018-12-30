//
//  QuickActions.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/30/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit

enum QuickActionType {
    case reserveRoom
    case reserveDesk
    case submitTicket
    case registerGuest
    case viewEvents
    case spaceInfo
    case none
}

class QuickAction: NSObject {
    var title: String!
    var icon: UIImage?
    var subtitle: String?
    var color: UIColor?
    var type: QuickActionType
    
    public init(title: String, subtitle: String, icon: String, color: UIColor?, type: QuickActionType?) {
        self.title = title
        self.subtitle = subtitle
        self.icon = UIImage(named: icon)
        self.color = color ?? .black
        self.type = type ?? QuickActionType.none
    }
}
