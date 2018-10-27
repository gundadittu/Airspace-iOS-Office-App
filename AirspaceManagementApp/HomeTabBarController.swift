//
//  HomeTabBarController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/15/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework

class HomeTabBarController : UITabBarController {
    
    override func viewDidLoad() {
        self.tabBar.tintColor = FlatPink()
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainNav = mainStoryboard.instantiateViewController(withIdentifier: "mainNav") as! HomeNavController
        mainNav.tabBarItem =  UITabBarItem(title: "Home", image: UIImage(named: "home-icon"), selectedImage: nil)
        let profileNav = mainStoryboard.instantiateViewController(withIdentifier: "profileNav") as! ProfileNavController
        profileNav.tabBarItem =  UITabBarItem(title: "Profile", image: UIImage(named: "profile-icon"), selectedImage: nil)
        let alertNav = mainStoryboard.instantiateViewController(withIdentifier: "notificationNav") as! UINavigationController
        alertNav.tabBarItem =  UITabBarItem(title: "Alerts", image: UIImage(named: "alert-icon"), selectedImage: nil)

        let array: [UIViewController] = [mainNav, alertNav, profileNav]
        self.setViewControllers(array, animated: true)
    }
}
