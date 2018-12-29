//
//  DeskReservationManager.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/20/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

import Foundation
import FirebaseFunctions
import FirebaseStorage

class DeskReservationManager {
    static let shared = DeskReservationManager()
    lazy var functions = Functions.functions()
    let storageRef = Storage.storage().reference()
    
    func createHotDeskReservation(startTime: Date, endTime: Date, hotDeskUID: String, shouldCreateCalendarEvent: Bool, completionHandler: @escaping (Error?) -> Void) {
        
        let startTimeString = startTime.serverTimestampString
        let endTimeString = endTime.serverTimestampString
        
        let parameters = ["shouldCreateCalendarEvent": shouldCreateCalendarEvent, "startTime": startTimeString, "endTime": endTimeString, "hotDeskUID": hotDeskUID] as [String: Any]
        functions.httpsCallable("createConferenceRoomReservation").call(parameters) { (result, error) in
            if let error = error {
                completionHandler(error)
            } else {
                completionHandler(nil)
            }
        }
    }
    
    func updateHotDeskReservation(reservationUID: String, startTime: Date, endTime: Date, completionHandler: @escaping (Error?) -> Void) {
        functions.httpsCallable("updateHotDeskReservation").call(["reservationUID": reservationUID, "startTime": startTime.serverTimestampString, "endTime": endTime.serverTimestampString]) { (result, error) in
            if let error = error {
                completionHandler(error)
            } else {
                completionHandler(nil)
            }
        }
        
    }
    
    func getReservationsForHotDesk(startDate: Date, endDate: Date, deskUID: String, completionHandler: @escaping ([AirDeskReservation]?, Error?) -> Void) {
        functions.httpsCallable("getReservationsForHotDesk").call(["startDate":startDate.serverTimestampString,"endDate": endDate.serverTimestampString,"deskUID": deskUID]) { (result, error) in
            if let error = error {
                completionHandler(nil, error)
            } else if let result = result,
                let resultData = result.data as? [[String: Any]]  {
                var reservations = [AirDeskReservation]()
                for item in resultData {
                    if let res = AirDeskReservation(dict: item) {
                        reservations.append(res)
                    }
                }
                completionHandler(reservations, nil)
            } else {
                completionHandler(nil, NSError())
            }
        }
    }
    
    func getAllHotDeskReservationsForUser(completionHandler: @escaping ([AirDeskReservation]?, [AirDeskReservation]?, Error?) -> Void) {
        functions.httpsCallable("getAllHotDeskReservationsForUser").call { (result, error) in
            if let error = error {
                completionHandler(nil, nil, error)
            } else if let result = result,
                let resultData = result.data as? [String: Any],
                let upcoming = resultData["upcoming"] as? [[String: Any]],
                let past = resultData["past"] as? [[String: Any]]  {
                
                var upcomingReservations = [AirDeskReservation]()
                for item in upcoming {
                    if let res = AirDeskReservation(dict: item) {
                        upcomingReservations.append(res)
                    }
                }
                
                var pastReservations = [AirDeskReservation]()
                for item in past {
                    if let res = AirDeskReservation(dict: item) {
                        pastReservations.append(res)
                    }
                }
                
                completionHandler(upcomingReservations, pastReservations, nil)
            } else {
                completionHandler(nil, nil, NSError())
            }
        }
    }
    
    func cancelHotDeskReservation(reservationUID: String, completionHandler: @escaping (Error?)->Void) {
        functions.httpsCallable("cancelHotDeskReservation").call(["reservationUID":reservationUID]) { (result, error) in
            completionHandler(error)
        }
    }
}

