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
    
    func createConferenceRoomReservation(startTime: Date, endTime: Date, conferenceRoomUID: String, shouldCreateCalendarEvent: Bool, reservationTitle: String, note: String?, attendees: [AirUser], completionHandler: @escaping (Error?) -> Void) {
        let startTimeString = startTime.serverTimestampString
        let endTimeString = endTime.serverTimestampString
        let attendeesArray = attendees.map { (user) -> [String: String] in
            var dict = [String:String]()
            dict["email"] = user.email
            dict["uid"] = user.uid
            return dict
        }
        
    functions.httpsCallable("createConferenceRoomReservation").call(["shouldCreateCalendarEvent": shouldCreateCalendarEvent,"reservationTitle": reservationTitle, "note":note, "startTime": startTimeString, "endTime": endTimeString, "conferenceRoomUID": conferenceRoomUID, "attendees": attendeesArray]) { (result, error) in
            if let error = error {
                completionHandler(error)
            } else {
                completionHandler(nil)
            }
        }
    }
    
    func updateConferenceRoomReservation(reservationUID: String, startTime: Date, endTime: Date, reservationTitle: String, note: String, attendees: [AirUser], completionHandler: @escaping (Error?) -> Void) {
        let attendeesArray = attendees.map { (user) -> [String: String] in
            var dict = [String:String]()
            dict["email"] = user.email
            dict["uid"] = user.uid
            return dict
        }
        functions.httpsCallable("updateConferenceRoomReservation").call(["reservationUID": reservationUID, "startTime": startTime.serverTimestampString, "endTime": endTime.serverTimestampString, "reservationTitle": reservationTitle, "note": note, "attendees": attendeesArray]) { (result, error) in
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
    
    func getAllConferenceRoomReservationsForUser(completionHandler: @escaping ([AirConferenceRoomReservation]?, [AirConferenceRoomReservation]?, Error?) -> Void) {
        functions.httpsCallable("getAllConferenceRoomReservationsForUser").call { (result, error) in
            if let error = error {
                completionHandler(nil, nil, error)
            } else if let result = result,
                let resultData = result.data as? [String: Any],
            let upcoming = resultData["upcoming"] as? [[String: Any]],
            let past = resultData["past"] as? [[String: Any]]  {
                
                var upcomingReservations = [AirConferenceRoomReservation]()
                for item in upcoming {
                    if let res = AirConferenceRoomReservation(dict: item) {
                        upcomingReservations.append(res)
                    }
                }
                
                var pastReservations = [AirConferenceRoomReservation]()
                for item in past {
                    if let res = AirConferenceRoomReservation(dict: item) {
                        pastReservations.append(res)
                    }
                }
                
                completionHandler(upcomingReservations, pastReservations, nil)
            } else {
                completionHandler(nil, nil, NSError())
            }
        }
    }
    
    func getUsersReservationsForToday(completionHandler: @escaping ([AirReservation]?, Error?) -> Void) {
        functions.httpsCallable("getUsersReservationsForToday").call { (result, error) in
            if let error = error {
                completionHandler(nil, error)
            } else if let result = result,
                let resultData = result.data as? [[String: Any]] {
                var reservations = [AirReservation]()
                for reservationDict in resultData {
                    if let _ = reservationDict["roomUID"] as? String,
                        let room = AirConferenceRoomReservation(dict: reservationDict) {
                        reservations.append(room)
                    } else if let _ = reservationDict["deskUID"] as? String {
                        // create AirDeskRes
                        return
                    }
                }
                completionHandler(reservations, nil)
            } else {
                completionHandler(nil, NSError())
            }
        }
    }
}
