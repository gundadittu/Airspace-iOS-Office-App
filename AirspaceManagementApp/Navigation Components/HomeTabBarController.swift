//
//  HomeTabBarController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/15/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFunctions

class HomeTabBarController : UITabBarController {
    lazy var functions = Functions.functions()

    override func viewDidLoad() {
        
        self.tabBar.tintColor = globalColor
        self.tabBar.barTintColor = .white
        self.tabBar.unselectedItemTintColor = .flatBlack
        
        switch UserAuth.shared.currUserType {
        case .admin?:
            let vc = InvalidUserVCViewController()
            UIApplication.shared.keyWindow?.rootViewController = vc
        case .receptionist?:
            let vc = InvalidUserVCViewController()
            UIApplication.shared.keyWindow?.rootViewController = vc
        case .tenantEmployee?:
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainNav = mainStoryboard.instantiateViewController(withIdentifier: "mainNav") as! HomeNavController
            mainNav.tabBarItem =  UITabBarItem(title: "HOME", image: UIImage(named: "home-icon"), selectedImage: nil)
            let reserveNav = mainStoryboard.instantiateViewController(withIdentifier: "reserveNav") as! ReserveNavController
            reserveNav.tabBarItem = UITabBarItem(title: "RESERVE", image: UIImage(named: "reserve-icon-tab"), selectedImage: nil)
            
    
            let alertNav = mainStoryboard.instantiateViewController(withIdentifier: "notificationNav") as! UINavigationController
            alertNav.tabBarItem =  UITabBarItem(title: "ALERTS", image: UIImage(named: "alert-icon"), selectedImage: nil)
            let profileNav = mainStoryboard.instantiateViewController(withIdentifier: "profileNav") as! ProfileNavController
            profileNav.tabBarItem =  UITabBarItem(title: "PROFILE", image: UIImage(named: "profile-icon"), selectedImage: nil)

            let array: [UIViewController] = [mainNav, reserveNav, alertNav, profileNav]
            self.setViewControllers(array, animated: false)
        case .tenantAdmin?:
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainNav = mainStoryboard.instantiateViewController(withIdentifier: "mainNav") as! HomeNavController
            mainNav.tabBarItem =  UITabBarItem(title: "HOME", image: UIImage(named: "home-icon"), selectedImage: nil)
            let reserveNav = mainStoryboard.instantiateViewController(withIdentifier: "reserveNav") as! ReserveNavController
            reserveNav.tabBarItem = UITabBarItem(title: "RESERVE", image: UIImage(named: "reserve-icon-tab"), selectedImage: nil)
            
            
            let alertNav = mainStoryboard.instantiateViewController(withIdentifier: "notificationNav") as! UINavigationController
            alertNav.tabBarItem =  UITabBarItem(title: "ALERTS", image: UIImage(named: "alert-icon"), selectedImage: nil)
            let profileNav = mainStoryboard.instantiateViewController(withIdentifier: "profileNav") as! ProfileNavController
            profileNav.tabBarItem =  UITabBarItem(title: "PROFILE", image: UIImage(named: "profile-icon"), selectedImage: nil)
            
            let array: [UIViewController] = [mainNav, reserveNav, alertNav, profileNav]
            self.setViewControllers(array, animated: false)
        case .landlord?:
            let vc = InvalidUserVCViewController()
            UIApplication.shared.keyWindow?.rootViewController = vc
        case .none:
            let vc = InvalidUserVCViewController()
            UIApplication.shared.keyWindow?.rootViewController = vc
        }
    }
}
