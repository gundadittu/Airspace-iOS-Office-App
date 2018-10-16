//
//  LoginVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/15/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginVC : UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        
        // Add logic to make sure fields are not blank, etc.
        
        guard let email = usernameTextField.text,
            let password = passwordTextField.text else {
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil || user == nil {
                // add error handling
                print("fail log in")
                return
            }
        }
    }
}
