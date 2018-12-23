//
//  HomeNavController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/21/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit

class BaseNavController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.tintColor = globalColor
        self.navigationBar.barTintColor = .white
        self.navigationBar.isTranslucent = true
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.red,
             NSAttributedString.Key.font: UIFont(name: "Avenir Next", size: 21)!]
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

