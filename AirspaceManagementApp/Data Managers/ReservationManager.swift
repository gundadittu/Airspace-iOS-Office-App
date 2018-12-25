//
//  ReservationManager.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/20/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

import Foundation
import FirebaseFunctions
import FirebaseStorage

class ReservationManager {
    static let shared = ReservationManager()
    lazy var functions = Functions.functions()
    let storageRef = Storage.storage().reference()
    
    func createConferenceRoomReservation(startTime: Date, endTime: Date, conferenceRoomUID: String, shouldCreateCalendarEvent: Bool, eventName: String?, description: String?, conferenceRoomName: String?, officeAddress: String?, attendees: [AirUser], completionHandler: @escaping (Error?) -> Void) {
        let startTimeString = startTime.serverTimestampString
        let endTimeString = endTime.serverTimestampString
        let attendeesArray = attendees.map { (user) -> [String:String] in
            if let email = user.email {
                return ["email":email]
            }
            // handle error
            return [:]
        }
        functions.httpsCallable("createConferenceRoomReservation").call(["shouldCreateCalendarEvent": shouldCreateCalendarEvent,"eventName": eventName, "description":description, "startTime": startTimeString, "endTime": endTimeString, "conferenceRoomUID": conferenceRoomUID,"attendees": attendeesArray, "conferenceRoomName": conferenceRoomName, "officeAddress": officeAddress]) { (result, error) in
            if let error = error {
                completionHandler(error)
            } else {
                completionHandler(nil)
            }
        }
    }
    

    func getReservationsForConferenceRoom(startDate: Date, endDate: Date, conferenceRoomUID: String, completionHandler: @escaping ([AirConferenceRoomReservation]?, Error?) -> Void) {
        functions.httpsCallable("getReservationsForConferenceRoom").call(["startDate":startDate.serverTimestampString,"endDate": endDate.serverTimestampString,"roomUID": conferenceRoomUID]) { (result, error) in
            if let error = error {
                completionHandler(nil, error)
            } else if let result = result,
                let resultData = result.data as? [[String: Any]]  {
                var reservations = [AirConferenceRoomReservation]()
                for item in resultData {
                    if let res = AirConferenceRoomReservation(dict: item) {
                        reservations.append(res)
                    }
                }
                completionHandler(reservations, nil)
            } else {
                completionHandler(nil, NSError())
            }
        }
    }
    
    func getAllConferenceRoomReservationsForUser(completionHandler: @escaping ([AirConferenceRoomReservation]?, Error?) -> Void) {
        functions.httpsCallable("getAllConferenceRoomReservationsForUser").call { (result, error) in
            if let error = error {
                completionHandler(nil, error)
            } else if let result = result,
                let resultData = result.data as? [[String: Any]]  {
                var reservations = [AirConferenceRoomReservation]()
                for item in resultData {
                    if let res = AirConferenceRoomReservation(dict: item) {
                        reservations.append(res)
                    }
                }
                completionHandler(reservations, nil)
            } else {
                completionHandler(nil, NSError())
            }
        }
    }
}
