//
//  InvalidUserVCViewController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/28/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit
import CFAlertViewController

class InvalidUserVCViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = globalColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let alertController = CFAlertViewController(title: "Oops!", message: "Our iOS app is currently only available to Airspace office tenants.", textAlignment: .left, preferredStyle: .alert, didDismissAlertHandler: nil)
        alertController.shouldDismissOnBackgroundTap = false
        let action = CFAlertAction(title: "Log Out", style: .Default, alignment: .justified, backgroundColor: globalColor, textColor: nil) { (action) in
            UserAuth.shared.signOutUser(completionHandler: { (_) in
                return
            })
        }
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
}
