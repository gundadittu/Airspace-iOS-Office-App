//
//  AirGuestRegistration.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 11/22/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import FirebaseFirestore

class AirGuestRegistration: NSObject {
    
    var uid: String?
    var arrived: Bool?
    var expectedVisitDate: Date?
    var actualVisitDate: Date?
    var guestEmail: String?
    var guestName: String?
    var hostUID: String?
    var visitingOfficeUID: String?
    var visitingOffice: AirOffice?
    
    public init?(dict dictionary: [String: Any]) {
        super.init()
        
        if let uid = dictionary["uid"] as? String {
            self.uid = uid
        } else {
            print("No uid found for AirGuestRegistration, AirGuestRegistration not created.")
            return nil
        }
        
        if let hostUID = dictionary["hostUID"] as? String {
            self.hostUID = hostUID
        } else {
            print("No hostUID found for AirGuestRegistration, AirGuestRegistration not created.")
            return nil
        }
        
        if let arrived = dictionary["arrived"] as? Bool {
            self.arrived = arrived
        } else {
            print("No arrived found for AirGuestRegistration")
        }
        
        if let timestampDict = dictionary["expectedVisitDate"] as? [String:Any],
        let seconds = timestampDict["_seconds"] as? Int64,
        let nanoseconds = timestampDict["_nanoseconds"] as? Int32 {
            self.expectedVisitDate = Timestamp(seconds: seconds, nanoseconds: nanoseconds).dateValue()
        } else {
            print("No expectedVisitDate found for AirGuestRegistration, AirGuestRegistration not created.")
            return nil
        }
        
        if let visitingOfficeUID = dictionary["visitingOfficeUID"] as? String {
            self.visitingOfficeUID = visitingOfficeUID
        } else {
            print("No visitingOffice found for AirGuestRegistration, AirGuestRegistration not created.")
            return nil
        }
        
        if let actualVisitDate = dictionary["actualVisitDate"] as? Date {
            self.actualVisitDate = actualVisitDate
        } else {
            print("No actualVisitDate found for AirGuestRegistration.")
        }
        
        if let guestName = dictionary["guestName"] as? String {
            self.guestName = guestName
        } else {
            print("No guestName found for AirGuestRegistration")
        }
        
        if let guestEmail = dictionary["guestEmail"] as? String {
            self.guestEmail = guestEmail
        } else {
            print("No guestEmail found for AirGuestRegistration")
        }
        
        if let officeData = dictionary["visitingOffice"] as? [String: Any],
            let visitingOffice = AirOffice(dict: officeData) {
            self.visitingOffice = visitingOffice
        } else {
            print("No visitingOffice found for AirGuestRegistration")
        }
    }
}
