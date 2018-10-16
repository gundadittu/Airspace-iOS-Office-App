//
//  AppDelegate.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/15/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var handle: AuthStateDidChangeListenerHandle?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Set up Firebase for app
        FirebaseApp.configure()

        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            var viewController: UIViewController? = nil
            if user != nil {
                // Signed in, load appropriate user UI
                 viewController = mainStoryboard.instantiateViewController(withIdentifier: "home") as! UITabBarController
            } else {
                // Not signed in, load Login VC
                viewController = mainStoryboard.instantiateViewController(withIdentifier: "loginVC") as! LoginVC
            }
            UIApplication.shared.keyWindow?.rootViewController = viewController
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        // Remove listener for sign-in state of app
        Auth.auth().removeStateDidChangeListener(handle!)
    }


}

