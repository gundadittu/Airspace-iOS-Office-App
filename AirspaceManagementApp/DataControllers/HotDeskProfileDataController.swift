//
//  HotDeskProfileDataController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/28/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import Firebase

protocol HotDeskProfileDataControllerDelegate {
    func didFinishSubmittingData(withError error: Error?)
    func startLoadingIndicator()
    func stopLoadingIndicator()
    func reloadTableView()
}

class HotDeskProfileDataController {
    var hotDesk: AirDesk?
    var selectedStartDate: Date?
    var selectedEndDate: Date?
    var shouldCreateCalendarEvent: Bool?
    var delegate: HotDeskProfileDataControllerDelegate?
    
    public init(delegate: HotDeskProfileDataControllerDelegate) {
        self.delegate = delegate
    }
    
    public func setHotDesk(with desk: AirDesk) {
        self.hotDesk = desk
        self.delegate?.reloadTableView()
    }
    
    public func setSelectedStartDate(with date: Date?) {
        self.selectedStartDate = date
    }
    
    public func setSelectedEndDate(with date: Date?) {
        self.selectedEndDate = date
    }
    
    public func setShouldCreateCalendarEvent(with value: Bool) {
        self.shouldCreateCalendarEvent = value
    }
    
    public func submitData() {
        guard let startTime = self.selectedStartDate,
            let endTime = self.selectedEndDate else {
                // handle error
                return
        }
        guard let deskUID = self.hotDesk?.uid else {
            // handle error
            return
        }
        let createCalendarEvent = self.shouldCreateCalendarEvent ?? false

        self.delegate?.startLoadingIndicator()
        DeskReservationManager.shared.createHotDeskReservation(startTime: startTime, endTime: endTime, hotDeskUID: deskUID, shouldCreateCalendarEvent: createCalendarEvent) { (error) in
            self.delegate?.stopLoadingIndicator()
            if let error = error {
                self.delegate?.didFinishSubmittingData(withError: error)
                return
            } else {
                self.delegate?.didFinishSubmittingData(withError: nil)
                return
            }
        }
    }
}
