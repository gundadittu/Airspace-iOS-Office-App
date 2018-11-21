//
//  UserManager.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 11/20/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import FirebaseFunctions

class UserManager {
    static let shared = UserManager()
    lazy var functions = Functions.functions()
    
    func getCurrentUsersOffices(completionHandler: @escaping ([AirOffice]?, Error?) -> Void) {
        functions.httpsCallable("getCurrentUsersOffices").call([:]) { (result, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let result = result,
                let officeData = result.data as? [[String: Any]]  else {
                    // proper error handling
                    completionHandler(nil, NSError())
                    return
            }
            
            var offices = [AirOffice]()
            for office in officeData {
                if let ao = AirOffice(dict: office) {
                    offices.append(ao)
                }
            }
            completionHandler(offices, nil)
        }
    }
    
}
