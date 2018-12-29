//
//  FindDeskManager.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/18/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import FirebaseFunctions
import FirebaseStorage

class FindDeskManager {
    static let shared = FindDeskManager()
    lazy var functions = Functions.functions()
    let storageRef = Storage.storage().reference()
    
    public func getAllHotDesksForUser(completionHandler: @escaping ([AirDesk]?, Error?) -> Void) {
        functions.httpsCallable("getAllHotDesksForUser").call { (result, error) in
            if let error = error {
                completionHandler(nil, error)
            } else if let resultData = result?.data as? [[String: Any]] {
                var desks = [AirDesk]()
                for result in resultData {
                    if let desk = AirDesk(dict: result) {
                        desks.append(desk)
                    }
                }
                completionHandler(desks, nil)
            } else {
                completionHandler(nil, NSError())
            }
        }
    }
    
    
    public func findAvailableHotDesks(officeUID: String, startDate: Date?, duration: Duration?, completionHandler: @escaping ([AirDesk]?, Error?) -> Void) {
        let dateString: String? = startDate?.serverTimestampString
        
        functions.httpsCallable("findAvailableHotDesks").call(["officeUID":officeUID, "startDate": dateString,  "duration": duration?.rawValue]) { (result, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            if let resultData = result?.data as? [[String:Any]] {
                let hotDesks = resultData.reduce([AirDesk](), { (result, item) -> [AirDesk] in
                    if let desk = AirDesk(dict: item) {
                        var newResult = result
                        newResult.append(desk)
                        return newResult
                    }
                    return result
                })
                completionHandler(hotDesks, nil)
                return
            }
            completionHandler(nil,NSError())
        }
    }
}
