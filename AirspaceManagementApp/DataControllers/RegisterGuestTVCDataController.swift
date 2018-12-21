//
//  RegisterGuestTVCDataController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 11/19/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import NotificationBannerSwift

protocol RegisterGuestTVCDataControllerDelegate {
    func didFinishSubmittingData(withError: Error?)
    func toggleLoadingIndicator()
    func reloadTableView()
}

enum DataSubmissionError: Error {
    case missingRequiredInput
    case invalidInput
}

class RegisterGuestTVCDataController {
    var delegate: RegisterGuestTVCDataControllerDelegate?
    var selectedOffice: AirOffice?
    var guestName: String?
    var guestEmail: String?
    var guestVisitDate: Date?
    
    public init(delegate: RegisterGuestTVCDataControllerDelegate) {
        self.delegate = delegate
        
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
                self.setSelectedOffice(as: firstOffice)
                self.delegate?.reloadTableView()
            }
        }
    }
    
    public func setSelectedOffice(as office: AirOffice) {
        self.selectedOffice = office
        self.delegate?.reloadTableView()
    }
    
    public func setGuestName(as name: String) {
        self.guestName = name
        self.delegate?.reloadTableView()
    }
    
    public func setGuestEmail(as email: String) {
        self.guestEmail = email
        self.delegate?.reloadTableView()
    }
    
    public func setGuestVistDate(as date: Date?) {
        self.guestVisitDate = date
        self.delegate?.reloadTableView()
    }
    
    public func submitFormData() {
        // call didFinishSubmittingData(withError: Error?) when done
        guard let guestName = self.guestName,
            let officeUID = self.selectedOffice?.uid,
            let guestVisitDate = self.guestVisitDate else {
                let error = DataSubmissionError.missingRequiredInput
                self.delegate?.didFinishSubmittingData(withError: error)
                return
        }
        self.delegate?.toggleLoadingIndicator()
        RegisterGuestManager.shared.createRegisteredGuest(guestName: guestName, visitingOfficeUID: officeUID, expectedVisitDate: guestVisitDate, guestEmail: guestEmail) { (error) in
            self.delegate?.toggleLoadingIndicator()
            self.delegate?.didFinishSubmittingData(withError: error)
        }
        
    }
}
