//
//  RegisterGuestManager.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 11/20/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import FirebaseFunctions

class RegisterGuestManager {
    
    static let shared = RegisterGuestManager()
    lazy var functions = Functions.functions()
    
    func createRegisteredGuest(guestName: String, visitingOfficeUID: String, expectedVisitDate: Date, guestEmail: String?, completionHandler: @escaping (Error?) -> Void) {
        let dateString = DateController.shared.convertDateToISOString(date: expectedVisitDate)
        functions.httpsCallable("createRegisteredGuest").call(["guestName": guestName, "guestEmail": guestEmail, "expectedVisitDate": dateString, "visitingOfficeUID": visitingOfficeUID]) { (_, error) in
            completionHandler(error)
        }
    }
}
