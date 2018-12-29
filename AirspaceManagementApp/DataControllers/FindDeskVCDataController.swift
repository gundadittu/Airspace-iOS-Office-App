//
//  FindDeskVCDataController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/28/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import NotificationBannerSwift

class FindDeskVCDataController {
    var selectedOffice: AirOffice?
    var selectedDuration: Duration? = .fifteen
    var selectedStartDate: Date? = Date()
    var shouldAutomaticallySubmit = false
    var isLoading = false
    var delegate: FindDeskVCDataControllerDelegate?
    
    public init(delegate: FindDeskVCDataControllerDelegate, shouldAutomaticallySubmit: Bool = false) {
        self.delegate = delegate
        self.shouldAutomaticallySubmit = shouldAutomaticallySubmit
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Handling quickReserve actions
            if (shouldAutomaticallySubmit == true) {
                self.delegate?.startLoadingIndicator()
            }
        }
        
        // Auto-populate office field
        UserManager.shared.getCurrentUsersOffices { (offices, error) in
            
            if let _ = error {
                let banner = StatusBarNotificationBanner(title: "Error loading Offices.", style: .danger)
                banner.show()
                return
            }
            
            if let offices = offices,
                let firstOffice = offices.first,
                self.selectedOffice == nil {
                self.setSelectedOffice(with: firstOffice)
                self.delegate?.reloadTableView()
            }
            
            // Handling quickReserve actions
            if (self.shouldAutomaticallySubmit == true) {
                self.delegate?.stopLoadingIndicator()
                self.submitData()
                self.shouldAutomaticallySubmit = false
            }
        }
    }
    
    public func setSelectedOffice(with office: AirOffice) {
        self.selectedOffice = office
        self.delegate?.reloadTableView()
    }
    
    public func setSelectedDuration(with duration: Duration) {
        self.selectedDuration = duration
    }
    
    public func setSelectedStartDate(with date: Date) {
        self.selectedStartDate = date
        self.delegate?.reloadTableView()
    }
    
    public func getEndDate() -> Date? {
        if let startDate = self.selectedStartDate,
            let duration = self.selectedDuration {
            let durationVal = duration.rawValue
            let endDate = startDate.addingTimeInterval(TimeInterval(durationVal*60))
            return endDate
        }
        return nil
    }
    
    func submitData() {
        guard let office = self.selectedOffice,
            let officeUID = office.uid,
            let startDate = self.selectedStartDate,
            let duration = self.selectedDuration else {
                let error = NSError(domain: "missingArguments", code: 20, userInfo: nil)
                self.delegate?.didFindAvailableDesks(desks: nil, error: error as Error)
                return
        }
        
        self.isLoading = true
        self.delegate?.startLoadingIndicator()
        FindDeskManager.shared.findAvailableHotDesks(officeUID: officeUID, startDate: startDate, duration: duration) { (desks, error) in
            self.isLoading = false
            self.delegate?.stopLoadingIndicator()
            if let error = error {
                self.delegate?.didFindAvailableDesks(desks: nil, error: error)
            } else if let desks = desks {
                self.delegate?.didFindAvailableDesks(desks: desks, error: nil)
            }
        }
    }
    
    func configure(with controller: FindDeskVCDataController?) {
        guard let controller = controller else { return }
        if let selectedOffice = controller.selectedOffice {
            self.setSelectedOffice(with: selectedOffice)
        }
        if let selectedDuration = controller.selectedDuration {
            self.setSelectedDuration(with: selectedDuration)
        }
        if let selectedStartDate = controller.selectedStartDate {
            self.setSelectedStartDate(with: selectedStartDate)
        }
    }
    
}
