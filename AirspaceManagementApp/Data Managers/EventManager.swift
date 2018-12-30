//
//  EventManager.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/27/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import FirebaseFunctions
import FirebaseStorage

class EventManager {
    static let shared = EventManager()
    lazy var functions = Functions.functions()
    let storageRef = Storage.storage().reference()

    public func getUpcomingEventsForUser(completionHandler: @escaping ([AirEvent]?,Error?) -> Void) {
        functions.httpsCallable("getUpcomingEventsForUser").call { (result, error) in
            if let error = error {
                completionHandler(nil, error)
            } else if let result = result,
                let resultData = result.data as? [[String: Any]] {
                var airEvents = [AirEvent]()
                for item in resultData {
                    if let event = AirEvent(dict: item){
                        airEvents.append(event)
                    }
                }
                completionHandler(airEvents, nil)
            } else {
                completionHandler(nil, NSError())
            }
        }
    }
    
    public func getProfileImage(for uid: String, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        let profileRef = storageRef.child("userProfileImages/\(uid).jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        profileRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                completionHandler(nil, error)
            } else if let data = data {
                let image = UIImage(data: data)
                completionHandler(image, nil)
            }
        }
    }
}
