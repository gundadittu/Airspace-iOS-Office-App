//
//  NotificationManager.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/23/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import FirebaseAnalytics
import FirebaseFunctions
import CFAlertViewController
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    lazy var functions = Functions.functions()
    let center = UNUserNotificationCenter.current()

    public func getUsersNotifications(completionHandler: @escaping ([AirNotification]?, Error?) -> Void) {
        functions.httpsCallable("getUsersNotifications").call { (result, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let result = result,
                let notificationData = result.data as? [[String: Any]]  else {
                    completionHandler(nil, NSError())
                    return
            }
            
            var notifications = [AirNotification]()
            for notification in notificationData {
                if let an = AirNotification(dict: notification) {
                    notifications.append(an)
                }
            }
            completionHandler(notifications, nil)
        }
    }
    
    func requestPermission(_ showAllAlerts: Bool = false){
        
        let defaults = UserDefaults.standard
        if defaults.value(forKey: "showGeneralOnboarding") == nil {
           return
        }
        
        if showAllAlerts == false {
            let defaults = UserDefaults.standard
            if defaults.value(forKey: "notificationRequestCount") == nil {
                defaults.setValue(1, forKey: "notificationRequestCount")
            } else {
                let count = defaults.value(forKey: "notificationRequestCount") as! Int
                let newCount = count + 1
                defaults.setValue(newCount, forKey: "notificationRequestCount")
                
                if newCount%3 != 2  || newCount < 4{
                    return
                }
            }
        }
        
        
        self.center.getNotificationSettings(completionHandler: { (settings) in
            let status = settings.authorizationStatus
            switch status {
            case .notDetermined:
                self.displayNotDeterminedAlert()
            case .denied:
                if (showAllAlerts) {
                    self.displayDeniedAlert()
                }
            case .authorized:
                if (showAllAlerts) {
                    self.displayAuthorizedAlert()
                }
            case .provisional:
                break
            }
        })
    }
    
    func displayDeniedAlert() {
        DispatchQueue.main.async {
            let alertController = CFAlertViewController(title: "Unfortunately, you already prevented us from sending you notifications.",
                                                        message: "To modify these settings, visit your phone's settings > Notifications.",
                                                        textAlignment: .left,
                                                        preferredStyle: .alert,
                                                        didDismissAlertHandler: nil)
            let action = CFAlertAction(title: "Thanks",
                                       style: .Default,
                                       alignment: .justified,
                                       backgroundColor: globalColor,
                                       textColor: nil,
                                       handler: { (action) in
                                        return
            })
            alertController.addAction(action)
            alertController.shouldDismissOnBackgroundTap = false
            
            let vc = UIApplication.topViewController()
            vc?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func displayAuthorizedAlert() {
        DispatchQueue.main.async {
            let alertController = CFAlertViewController(title: "We already have permission to send you notifications! ",
                                                        message: "To modify these settings, visit your phone's settings > Notifications.",
                                                        textAlignment: .left,
                                                        preferredStyle: .alert,
                                                        didDismissAlertHandler: nil)
            let action = CFAlertAction(title: "Cool",
                                              style: .Default,
                                              alignment: .justified,
                                              backgroundColor: globalColor,
                                              textColor: nil,
                                              handler: { (action) in
                                                return
            })
            alertController.addAction(action)
            alertController.shouldDismissOnBackgroundTap = false
            
            let vc = UIApplication.topViewController()
            vc?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func displayNotDeterminedAlert() {
        DispatchQueue.main.async {
            let alertController = CFAlertViewController(title: "👋 We need your permission to send you notifications! ",
                                                        message: "Nothing annoying. We promise. We will only send you notifications when something changes with your reservations, events, service requests, or registered guests.",
                                                        textAlignment: .left,
                                                        preferredStyle: .alert,
                                                        didDismissAlertHandler: nil)
            
            let grantedAction = CFAlertAction(title: "Ask me Now",
                                              style: .Default,
                                              alignment: .justified,
                                              backgroundColor: globalColor,
                                              textColor: nil,
                                              handler: { (action) in
                                                
                                                Analytics.logEvent("user-did-click-ask-me-now-for-notification-permissions", parameters: nil)
                                                
                                                if #available(iOS 10.0, *) {
                                                    // For iOS 10 display notification (sent via APNS)
                                                    
                                                    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                                                    UNUserNotificationCenter.current().requestAuthorization(
                                                        options: authOptions,
                                                        completionHandler: {_, _ in })
                                                } else {
                                                    let settings: UIUserNotificationSettings =
                                                        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                                                   
                                                     UIApplication.shared.registerUserNotificationSettings(settings)
                                                }
                                                UIApplication.shared.registerForRemoteNotifications()
                                                
            })
            
            let laterAction = CFAlertAction(title: "Decide Later",
                                            style: .Cancel,
                                            alignment: .justified,
                                            backgroundColor: UIColor.flatWhiteDark,
                                            textColor: nil,
                                            handler: { (action) in
                Analytics.logEvent("user-did-click-decide-later-for-notification-permissions", parameters: nil)
            })
                
            alertController.addAction(grantedAction)
            alertController.addAction(laterAction)
            
            alertController.shouldDismissOnBackgroundTap = false
            
            let vc = UIApplication.topViewController()
            vc?.present(alertController, animated: true, completion: nil)
        }
    }
    
}
