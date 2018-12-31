//
//  AuthManager.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 11/1/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFunctions

enum UserType : String, CaseIterable {
    case admin = "admin"
    case receptionist = "receptionist"
    case landlord = "landlord"
    case tenantEmployee = "tenantEmployee"
    case tenantAdmin = "tenantAdmin"
}

class UserAuth {
    
    static let shared = UserAuth()
    lazy var functions = Functions.functions()

    var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    var currUser: User? {
        return Auth.auth().currentUser
    }
    
    var displayName: String? {
        return Auth.auth().currentUser?.displayName
    }
    
    var email: String? {
        return Auth.auth().currentUser?.email
    }
    
    var uid: String? {
        return Auth.auth().currentUser?.uid
    }
    
    var currUserType: UserType?

    
    func populateUserType(completionHandler: @escaping (UserType?) -> Void) {
        functions.httpsCallable("getUserType").call { (result, error) in
            if let resultData = result?.data as? [String: Any],
                let typeString = resultData["type"] as? String,
                let userType = UserType(rawValue: typeString) {
                self.currUserType = userType
                completionHandler(userType)
            } else {
                completionHandler(nil)
            }
        }
    }
    
    func signInUser(email: String, password: String, completionHandler: @escaping (User?, NSError?)->Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (userResult, error) in
            guard error == nil,
                let user = userResult?.user else {
                completionHandler(nil, error! as NSError)
                return
            }
            completionHandler(user, nil)

//            self.populateUserType(completionHandler: { (type) in
//                if (type == nil) {
//                    completionHandler(nil, NSError())
//                } else {
//                    completionHandler(user, nil)
//                }
//            })
        }
    }
    
    func signOutUser(completionHandler: @escaping (NSError?)->Void) {
        do {
            try Auth.auth().signOut()
            completionHandler(nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            completionHandler(signOutError)
        }

    }
}
