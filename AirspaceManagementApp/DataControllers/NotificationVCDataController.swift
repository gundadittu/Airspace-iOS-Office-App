//
//  NotificationVCDataController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/23/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

protocol NotificationVCDataControllerDelegate {
    func didLoadNotifications(_ notifications: [AirNotification]?, with error: Error?)
    func startLoadingIndicator()
    func stopLoadingIndicator()
}

class NotificationVCDataController {
    var delegate: NotificationVCDataControllerDelegate?
    var notifications = [AirNotification]()
    
    public init(delegate: NotificationVCDataControllerDelegate) {
        self.delegate = delegate
    }
    
    func loadNotifications() {
        return 
    }
}
