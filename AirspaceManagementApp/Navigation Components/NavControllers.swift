//
//  HomeNavController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/21/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework

class BaseNavController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.prefersLargeTitles = true
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.tintColor = globalColor
    }
}

class HomeNavController: BaseNavController {

}

class ProfileNavController: BaseNavController {
    
}

class NotificationNavController: BaseNavController {
    
}

class ReserveNavController: BaseNavController {
    
}

