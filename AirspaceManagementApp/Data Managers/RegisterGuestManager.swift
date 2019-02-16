//
//  RegisterGuestManager.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 11/20/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import FirebaseFunctions
import Sentry

class RegisterGuestManager {
    
    static let shared = RegisterGuestManager()
    lazy var functions = Functions.functions()
    
    func createRegisteredGuest(guestName: String, visitingOfficeUID: String, expectedVisitDate: Date, guestEmail: String?, completionHandler: @escaping (Error?) -> Void) {
        let dateString = expectedVisitDate.serverTimestampString
        functions.httpsCallable("createRegisteredGuest").call(["guestName": guestName, "guestEmail": guestEmail, "expectedVisitDate": dateString, "visitingOfficeUID": visitingOfficeUID]) { (_, error) in
            if let error = error {
                let event = Event(level: .error)
                event.message = error.localizedDescription
                Client.shared?.send(event: event)
            }
            completionHandler(error)
        }
    }
    
    func cancelRegisteredGuest(registeredGuestUID: String, completionHandler: @escaping ((Error?) -> Void)) {
        functions.httpsCallable("cancelRegisteredGuest").call(["registeredGuestUID": registeredGuestUID]) { (_, error) in
            if let error = error {
                let event = Event(level: .error)
                event.message = error.localizedDescription
                Client.shared?.send(event: event)
            }
            completionHandler(error)
        }
    }
    
    func getUsersRegisteredGuests(completionHandler: @escaping ([AirGuestRegistration]?,[AirGuestRegistration]?, Error?) -> Void) {
        functions.httpsCallable("getUsersRegisteredGuests").call { (result, error) in
            if let error = error {
                let event = Event(level: .error)
                event.message = error.localizedDescription
                Client.shared?.send(event: event)
                
                completionHandler(nil, nil, error)
                return
            }
            
            guard let result = result,
                let guestData = result.data as? [String: Any],
            let upcoming = guestData["upcoming"] as? [[String: Any]],
            let past = guestData["past"] as? [[String: Any]] else {
                    completionHandler(nil, nil, NSError())
                    return
            }
            var upcomingGuests = [AirGuestRegistration]()
            for guest in upcoming {
                if let ao = AirGuestRegistration(dict: guest) {
                    upcomingGuests.append(ao)
                }
            }
            
            var pastGuests = [AirGuestRegistration]()
            for guest in past {
                if let ao = AirGuestRegistration(dict: guest) {
                    pastGuests.append(ao)
                }
            }
            completionHandler(upcomingGuests, pastGuests, nil)
        }
    }
}
