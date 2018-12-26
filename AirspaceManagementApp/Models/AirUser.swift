//
//  AirUser.swift
//  AirspaceAdminApp
//
//  Created by Aditya Gunda on 11/5/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import FirebaseFirestore

class AirUser: NSObject {
    
    var displayName: String?
    var uid: String?
    var email: String?
    var type: UserType?
    let db = Firestore.firestore()
    
    public init?(dictionary: [String: Any]) {
        super.init()
        
        if let uid = dictionary["uid"] as? String {
            self.uid = uid
        } else {
            print("No uid found for AirUser, AirUser not created.")
            return nil
        }
        
        self.fillData(dict: dictionary)
        //        self.addListener()
    }
    
    public init?(uid: String) {
        super.init()
        self.uid = uid
        //        self.addListener()
    }
    
    func fillData(dict dictionary: [String: Any]) {
        if let displayName = dictionary["displayName"] as? String {
            self.displayName = displayName
        }else if let fname = dictionary["firstName"] as? String,
            let lname = dictionary["lastName"] as? String {
            self.displayName = fname + " " + lname
        } else {
            print("No display name found for AirUser")
        }
        
        if let email = dictionary["email"] as? String {
            self.email = email
        } else {
            print("No email found for AirUser")
        }
        
        if let uid = dictionary["uid"] as? String {
            self.uid = uid
        }
    }
    
    func addListener() {
        guard let uid = self.uid else { return }
        db.collection("users").document(uid)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                let source = document.metadata.hasPendingWrites ? "Local" : "Server"
                print("\(source) data: \(document.data() ?? [:])")
                if let data = document.data() {
                    self.fillData(dict: data)
                }
        }
    }
}

