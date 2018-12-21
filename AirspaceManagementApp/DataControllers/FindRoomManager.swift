//
//  FindRoomManager.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/18/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import FirebaseFunctions
import FirebaseStorage

class FindRoomManager {
    static let shared = FindRoomManager()
    lazy var functions = Functions.functions()
    let storageRef = Storage.storage().reference()

    
    public func findAvailableConferenceRooms(officeUID: String, startDate: Date?, duration: Duration?, amenities: [RoomAmenity]?, capacity: Int?, completionHandler: @escaping ([AirConferenceRoom]?, Error?) -> Void) {
        let dateString: String? = startDate?.serverTimestampString
        var amenitiesStringArr: [String]? = nil
        if let amenities = amenities {
            amenitiesStringArr = amenities.map { (amenity) -> String in
                return amenity.rawValue
            }
        }
        functions.httpsCallable("findAvailableConferenceRooms").call(["officeUID":officeUID, "startDate": dateString, "capacity": capacity, "duration": duration?.rawValue, "amenities": amenitiesStringArr]) { (result, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            if let resultData = result?.data as? [[String:Any]] {
                let conferenceRooms = resultData.reduce([AirConferenceRoom](), { (result, item) -> [AirConferenceRoom] in
                    if let room = AirConferenceRoom(dict: item) {
                        var newResult = result
                        newResult.append(room)
                        return newResult
                    }
                    return result
                })
                completionHandler(conferenceRooms, nil)
                return
            }
            completionHandler(nil,NSError())
        }
    }
}
