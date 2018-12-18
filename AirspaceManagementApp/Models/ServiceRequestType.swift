//
//  ServiceRequestType.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/1/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

enum ServiceRequestStatus: String {
    case open = "open"
    case closed = "closed"
    case pending = "pending"
    
    var title: String {
        switch self {
        case .open:
            return "Received"
        case .pending:
            return "In Progress"
        case .closed:
            return "Finished"
        }
    }
}

enum ServiceRequestTypeItem: String {
    case coffeeRefill = "coffeeRefill"
    case deskRepair = "deskRepair"
    
    var title: String {
        switch self {
        case .coffeeRefill:
            return "Coffee needs to be restocked."
        case .deskRepair:
            return "Desk needs to be repaired."
        }
    }
}

class ServiceRequestTypeSection {
    var title: String?
    var items = [ServiceRequestTypeItem?]()
    
    public init(title: String, items: [ServiceRequestTypeItem?]) {
        self.title = title
        self.items = items
    }
    
}

class ServiceRequestTypeController {
    static let shared = ServiceRequestTypeController()
    var sections = [ServiceRequestTypeSection]()
    
    public init() {
        let coffeeItems = [ServiceRequestTypeItem(rawValue: "coffeeRefill")]
        let coffeeSection = ServiceRequestTypeSection(title: "Coffee", items: coffeeItems)
        sections.append(coffeeSection)
        let furnitureItems = [ServiceRequestTypeItem(rawValue: "deskRepair")]
        let furnitureSection = ServiceRequestTypeSection(title: "Furniture", items: furnitureItems)
        sections.append(furnitureSection)
    }
    
}
