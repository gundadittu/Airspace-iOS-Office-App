//
//  MainOptions.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/17/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework


enum MainOptionsType {
    case reserveRoom
    case submitTicket
    case registerGuest
    case viewEvents
    case spaceInfo
    case none
}

class MainOptions: NSObject {
    var title: String!
    var icon: UIImage?
    var subtitle: String?
    var color: UIColor?
    var type: MainOptionsType
    
    public init(title: String, subtitle: String, icon: String, color: UIColor, type: MainOptionsType?) {
        self.title = title
        self.subtitle = subtitle
        self.icon = UIImage(named: icon)
        self.color = color
        self.type = type ?? MainOptionsType.none
    }
}
