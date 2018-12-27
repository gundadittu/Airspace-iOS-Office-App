//
//  UserManager.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 11/20/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import FirebaseFunctions
import FirebaseStorage

class UserManager {
    static let shared = UserManager()
    lazy var functions = Functions.functions()
    let storageRef = Storage.storage().reference()

    func getProfileImage(for user: AirUser, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        // Create a reference to the file you want to download
        guard let uid = user.uid as? String else {
            completionHandler(nil, NSError())
            return
        }
        let profileRef = storageRef.child("userProfileImages/\(uid).jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        profileRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                completionHandler(nil, error)
            } else if let data = data {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data)
                completionHandler(image, nil)
            }
        }
    }
    
    func getProfileImage(for uid: String, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        // Create a reference to the file you want to download
        let profileRef = storageRef.child("userProfileImages/\(uid).jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        profileRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                completionHandler(nil, error)
            } else if let data = data {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data)
                completionHandler(image, nil)
            }
        }
    }
    
    func getCurrentUsersOffices(completionHandler: @escaping ([AirOffice]?, Error?) -> Void) {
        functions.httpsCallable("getCurrentUsersOffices").call([:]) { (result, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let result = result,
                let officeData = result.data as? [[String: Any]]  else {
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
    
    func updateUserFCMRegToken(regToken: String, oldToken: String? = nil) {
        functions.httpsCallable("updateUserFCMRegToken").call(["regToken": regToken, "oldToken": oldToken]) { (_, _) in
            return
        }
    }
    
    func updateBioInfo(firstName: String?, lastName: String?, completionHandler: @escaping (Error?) -> Void) {
        functions.httpsCallable("updateUserBioInfo").call(["firstName": firstName, "lastName": lastName]) { (result, error) in
            if let error = error {
                completionHandler(error)
            } else {
                completionHandler(nil)
            }
        }
    }
    
}
