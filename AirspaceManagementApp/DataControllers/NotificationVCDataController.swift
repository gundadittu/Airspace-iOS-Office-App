//
//  NotificationVCDataController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/23/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

class NotificationVCDataController {
    var delegate: NotificationVCDataControllerDelegate?
    var notifications = [AirNotification]()
    var isLoading = false
    
    public init(delegate: NotificationVCDataControllerDelegate) {
        self.delegate = delegate
        self.loadNotifications()
    }
    
    func loadNotifications() {
        self.isLoading = true
        self.delegate?.startLoadingIndicator()
        NotificationManager.shared.getUsersNotifications { (notifications, error) in
            self.isLoading = false
            self.delegate?.stopLoadingIndicator()
            if let error = error {
                self.delegate?.didLoadNotifications(nil, with: error)
            } else if let notifications = notifications {
                self.notifications = notifications
                self.delegate?.didLoadNotifications(notifications, with: nil)
            } else {
                self.delegate?.didLoadNotifications(nil, with: NSError())
            }
        }
    }
}
