//
//  ServiceRequestVCDataController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 11/29/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit
import NotificationBannerSwift

protocol ServiceRequestVCDataControllerDelegate {
    func didFinishSubmittingData(withError error: Error?)
    func startLoadingIndicator()
    func stopLoadingIndicator()
    func reloadTableView()
}

class ServiceRequestVCDataController {
    var delegate: ServiceRequestVCDataControllerDelegate?
    var selectedOffice: AirOffice?
    var note: String?
    var image: UIImage?
    var issueType: ServiceRequestTypeItem?
    
    public init(delegate: ServiceRequestVCDataControllerDelegate) {
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
    public func setNote(as note: String) {
        self.note = note
        self.delegate?.reloadTableView()
    }
    public func setImage(as image: UIImage?) {
        self.image = image ?? nil
        self.delegate?.reloadTableView()
    }
    public func setIssueType(as type: ServiceRequestTypeItem) {
        self.issueType = type
        self.delegate?.reloadTableView()
    }
    
    public func submitFormData() {
        guard let selectedOffice = self.selectedOffice,
            let uid = selectedOffice.uid,
            let issueType = self.issueType else {
                let error = DataSubmissionError.missingRequiredInput
                self.delegate?.didFinishSubmittingData(withError: error)
                return
        }
        let issueTypeName = issueType.rawValue
        self.delegate?.startLoadingIndicator()
        ServiceRequestManager.shared.createServiceRequest(officeUID: uid, issueType: issueTypeName, note: self.note, image: self.image) { (error) in
            self.delegate?.stopLoadingIndicator()
            self.delegate?.didFinishSubmittingData(withError: error)
        }
    }
}
