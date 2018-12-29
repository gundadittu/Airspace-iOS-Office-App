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
                    UserAuth.shared.populateUserType(completionHandler: { (_) in
                        // Signed in, load appropriate user UI based on user type
                        viewController = mainStoryboard.instantiateViewController(withIdentifier: "home") as! UITabBarController
                        UIApplication.shared.keyWindow?.rootViewController = viewController
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
                            application.registerForRemoteNotifications()
                        }
                    })
            } else {
                // Not signed in, load Login VC
                viewController = mainStoryboard.instantiateViewController(withIdentifier: "loginVC") as! LoginVC
                UIApplication.shared.keyWindow?.rootViewController = viewController
            }
        }
        
        UINavigationBar.appearance().titleTextAttributes =    [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 20) ?? UIFont.systemFont(ofSize: 20)]
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 10) ??
            UIFont.systemFont(ofSize: 10)], for: .normal)
        
        Messaging.messaging().delegate = self
        return true
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
