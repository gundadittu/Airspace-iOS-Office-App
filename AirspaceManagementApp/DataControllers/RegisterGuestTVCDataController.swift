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
}

enum DateSubmissionError: Error {
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
    }
    
    public func setSelectedOffice(as office: AirOffice) {
        self.selectedOffice = office 
    }
    
    public func setGuestName(as name: String) {
        self.guestName = name
    }
    
    public func setGuestEmail(as email: String) {
        self.guestEmail = email
    }
    
    public func setGuestVistDate(as date: Date?) {
        self.guestVisitDate = date
    }
    
    public func submitFormData() {
        // call didFinishSubmittingData(withError: Error?) when done
        guard let guestName = self.guestName,
            let officeUID = self.selectedOffice?.uid,
            let guestVisitDate = self.guestVisitDate else {
                let error = DateSubmissionError.missingRequiredInput
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
