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
    
    public func getSpaceInfoForUser(completionHandler: @escaping (URL?, URL?, URL?, Error?) -> Void) {
        functions.httpsCallable("getSpaceInfoForUser").call([:]) { (result, error) in
            if let error = error {
                completionHandler(nil, nil, nil, error)
            } else if let resultData = result?.data as? [String:Any]  {
                var onboardingURL: URL?
                var floorplanURL: URL?
                var buildingDetailsURL: URL?

               if let string = resultData["onboardingURL"] as? String,
                let url = URL(string: string) {
                    onboardingURL = url
                }
                if let string = resultData["floorplanURL"] as? String,
                    let url = URL(string: string) {
                    floorplanURL = url
                }
                if let string = resultData["buildingDetailsURL"] as? String,
                    let url = URL(string: string) {
                    buildingDetailsURL = url
                }
                
                completionHandler(onboardingURL, floorplanURL, buildingDetailsURL, nil)
            } else {
                completionHandler(nil, nil, nil, nil)
            }
        }
    }
}
