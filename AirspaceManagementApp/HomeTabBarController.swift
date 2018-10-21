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
        let mainNav = mainStoryboard.instantiateViewController(withIdentifier: "mainNav") as! HomeNavController
        mainNav.tabBarItem =  UITabBarItem(title: "Home", image: nil, selectedImage: nil)
//            UITabBarItem(title: "Home", image: UIImage(named: "home-icon"), selectedImage: UIImage(named: "home-selected-icon"))
        let profileNav = mainStoryboard.instantiateViewController(withIdentifier: "profileNav") as! ProfileNavController
        profileNav.tabBarItem =  UITabBarItem(title: "My Stuff", image: nil, selectedImage: nil)
//         UITabBarItem(title: "My Stuff", image: UIImage(named: "profile-selected-icon"), selectedImage: UIImage(named: "profile-selected-icon"))

        let array: [UIViewController] = [mainNav, profileNav]
        self.setViewControllers(array, animated: true)
    }
}
