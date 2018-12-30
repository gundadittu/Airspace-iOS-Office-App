//
//  ChooseTVCDelegate.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/27/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

protocol ChooseTVCDelegate {
    func didSelectUser(landlord: AirUser)
    func didSelectBuilding(building: AirBuilding)
    func didSelectOffice(office: AirOffice)
    func didSelectDuration(duration: Duration)
    func didSelectSRType(type: ServiceRequestTypeItem)
    func didSelectCapacity(number: Int)
    func didSelectRoomAmenities(amenities: [RoomAmenity])
    func didChooseEmployees(employees: [AirUser])
}

extension ChooseTVCDelegate {
    func didSelectUser(landlord: AirUser) {
        // Makes method optional to implement
    }
    func didSelectBuilding(building: AirBuilding) {
        // Makes method optional to implement
    }
    func didSelectOffice(office: AirOffice) {
        // Makes method optional to implement
    }
    func didSelectDuration(duration: Duration) {
        // Makes method optional to implement
    }
    
    func didSelectSRType(type: ServiceRequestTypeItem) {
        // Makes method optional to implement
    }

    func didSelectCapacity(number: Int) {
        // Makes method optional to implement
    }
    func didSelectRoomAmenities(amenities: [RoomAmenity]) {
        // Makes method optional to implement
    }
    
    func didChooseEmployees(employees: [AirUser]) {
        // Makes method optional to implement
    }
}
