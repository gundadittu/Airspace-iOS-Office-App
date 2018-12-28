//
//  EventsTVCDataController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/27/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

protocol EventsTVCDataControllerDelegate {
    func didUpdateData(with error: Error?)
    func startLoadingIndicator()
    func stopLoadingIndicator()
}

class EventsTVCDataController {
    var isLoading = false
    var delegate: EventsTVCDataControllerDelegate?
    var events = [AirEvent]()
    
    public init?(delegate: EventsTVCDataControllerDelegate) {
        self.delegate = delegate
        self.loadData()
    }
    
    public func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.delegate?.startLoadingIndicator()
        }
        self.isLoading = true
        EventManager.shared.getUpcomingEventsForUser { (events, error) in
            self.isLoading = false
            self.delegate?.stopLoadingIndicator()
            if let error = error {
                self.delegate?.didUpdateData(with: error)
            } else if let events = events {
                self.events = events
                self.delegate?.didUpdateData(with: nil)
            }
        }
    }
}
