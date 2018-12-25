//
//  OfficeManager.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/22/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import FirebaseFunctions

class OfficeManager {
    static let shared = OfficeManager()
    lazy var functions = Functions.functions()
    
    public func getEmployeesForOffice(officeUID: String, completionHandler: @escaping ([AirUser]?, Error?) -> Void) {
        functions.httpsCallable("getEmployeesForOffice").call(["officeUID": officeUID]) { (result, error) in
            if let error = error {
                completionHandler(nil,error)
            } else if let resultData = result?.data as? [[String:Any]]  {
                var employees = [AirUser]()
                for item in resultData {
                    if let user = AirUser(dictionary: item) {
                        employees.append(user)
                    }
                }
                completionHandler(employees,nil)
            } else {
                completionHandler([], nil)
            }
        }
    }
}
