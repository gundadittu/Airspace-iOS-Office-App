//
//  NotificationManager.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/23/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import FirebaseFunctions

class NotificationManager {
    static let shared = NotificationManager()
    lazy var functions = Functions.functions()
    
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
}
