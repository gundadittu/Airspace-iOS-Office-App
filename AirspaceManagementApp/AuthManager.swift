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

enum UserType : String {
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
    
    // remove default admin case 
    var currUserType: UserType? = .tenantEmployee
    
    func signInUser(email: String, password: String, completionHandler: @escaping (User?, NSError?)->Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (userResult, error) in
            guard error == nil,
                let user = userResult?.user else {
                completionHandler(nil, error! as NSError)
                return
            }
//        Need to set user type, otherwise return error
            completionHandler(user, nil)
        }
    }
    
    func createUser(email: String, type: UserType, completionHandler: @escaping (NSError?) -> Void) {
        functions.httpsCallable("createUser").call(["email": email, "type": type.rawValue]) { (result, error) in
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
//                    let code = FunctionsErrorCode(rawValue: error.code)
//                    let message = error.localizedDescription
//                    let details = error.userInfo[FunctionsErrorDetailsKey]
                    completionHandler(error)
                } else {
                    completionHandler(nil)
                }
            }
        }
    }
}
