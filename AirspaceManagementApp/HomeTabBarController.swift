//
//  HomeTabBarController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/15/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit

class HomeTabBarController : UITabBarController {
    
    override func viewDidLoad() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let srVC = mainStoryboard.instantiateViewController(withIdentifier: "serviceRequestNavController") as! UINavigationController
        
        let array: [UIViewController] = [srVC]
        self.setViewControllers(array, animated: true)
    }
}
