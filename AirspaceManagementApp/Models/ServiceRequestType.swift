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

enum ServiceRequestTypeItem: String, CaseIterable {
    case infoTech = "infoTech"
    case plumbing = "plumbing"
    case lighting = "lighting"
    case generalMaintenance = "generalMaintenance"
    case furniture = "furniture"
    case door = "door"
    case heatingCooling = "heatingCooling"
    case cleaning = "cleaning"
    case supplies = "supplies"
    case other = "other"
    
    var title: String {
        switch self {
        case .infoTech:
            return "IT"
        case .plumbing:
            return "Plumbing"
        case .lighting:
            return "Lighting"
        case .generalMaintenance:
            return "General Maintenance"
        case .furniture:
            return "Furniture"
        case .door:
            return "Door"
        case .heatingCooling:
            return "Heating/Cooling"
        case .cleaning:
            return "Cleaning"
        case .supplies:
            return "Supplies"
        case .other:
            return "Other"
        }
    }
}
    
    
//    case furnitureRepair = "furnitureRepair"
//    case brokenFixtures = "brokenFixtures"
//    case lightsNotWorking = "lightsNotWorking"
//    case waterDamageLeak = "waterDamageLeak"
//    case brokenACHeating = "brokenACHeating"
//    case kitchenIssues = "kitchenIssues"
//    case bathroomIssues = "bathroomIssues"
//    case damagedDyingPlants = "damagedDyingPlants"
//    case conferenceRoomHardware = "conferenceRoomHardware"
//    case webMobileIssues = "webMobileIssues"
//    case furnitureMovingRequest = "furniturefurnitureMovingRequestMoving"
//    case printingIssues = "printingIssues"
//    case wifiIssues = "wifiIsssues"
//    case other = "other"
    
//    var title: String {
//        switch self {
//        case .furnitureRepair:
//            return "Furniture Repair"
//        case .brokenFixtures:
//            return "Fixture Repair"
//        case .lightsNotWorking:
//            return "Lights Not Working"
//        case .waterDamageLeak:
//            return "Water/Damage Leak"
//        case .brokenACHeating:
//            return "Broken AC/Heating"
//        case .kitchenIssues:
//            return "Kitchen Issues"
//        case .bathroomIssues:
//            return "Bathroom Issues"
//        case .damagedDyingPlants:
//            return "Damaged/Dying Plants"
//        case .conferenceRoomHardware:
//            return "Conference Room Hardware Issues"
//        case .webMobileIssues:
//            return "Web/Mobile App Issues"
//        case .furnitureMovingRequest:
//            return "Furniture Moving Request"
//        case .printingIssues:
//            return "Printing Issues"
//        case .wifiIssues:
//            return "Wifi Issues"
//        case .other:
//            return "Other"
//        }
//    }
