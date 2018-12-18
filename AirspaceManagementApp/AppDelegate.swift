//
//  AppDelegate.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/15/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import NotificationBannerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var handle: AuthStateDidChangeListenerHandle?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Set up Firebase for app
        FirebaseApp.configure()

        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            var viewController: UIViewController? = nil
            if user != nil {
                // Signed in, load appropriate user UI
                 viewController = mainStoryboard.instantiateViewController(withIdentifier: "home") as! UITabBarController
                
                if #available(iOS 10.0, *) {
                    // For iOS 10 display notification (sent via APNS)
                    UNUserNotificationCenter.current().delegate = self
                    
                    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                    UNUserNotificationCenter.current().requestAuthorization(
                        options: authOptions,
                        completionHandler: {_, _ in })
                } else {
                    let settings: UIUserNotificationSettings =
                        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                    application.registerUserNotificationSettings(settings)
                }
                
                application.registerForRemoteNotifications()
                
            } else {
                // Not signed in, load Login VC
                viewController = mainStoryboard.instantiateViewController(withIdentifier: "loginVC") as! LoginVC
            }
            UIApplication.shared.keyWindow?.rootViewController = viewController
        }
        
        Messaging.messaging().delegate = self
        
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

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Displays notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
    
//         Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        if UIApplication.shared.applicationState == .active {
            // find better alert system, be able to handle clicks
            let banner = StatusBarNotificationBanner(title: "Recieved push notification.")
            banner.show()
        }

        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    // Handles user action on notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}

extension AppDelegate : MessagingDelegate {
    
    // Called whenever the firebase registration token changes
    // (Registration token is used to send push notifications to specific users)
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        let ud = UserDefaults.standard
        if let val = ud.value(forKey: "regToken") as? String {
            // Remove old regToken for this device if there is one
            UserManager.shared.updateUserFCMRegToken(regToken: fcmToken, oldToken: val)
        } else {
            // Or just set new token
            UserManager.shared.updateUserFCMRegToken(regToken: fcmToken)
        }
        // Update user defaults with new value
        ud.set(fcmToken, forKey: "regToken")
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
