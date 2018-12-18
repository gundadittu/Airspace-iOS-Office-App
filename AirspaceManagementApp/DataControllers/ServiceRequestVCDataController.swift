//
//  ServiceRequestVCDataController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 11/29/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit

protocol ServiceRequestVCDataControllerDelegate {
    func didFinishSubmittingData(withError error: Error?)
    func startLoadingIndicator()
    func stopLoadingIndicator()
}

class ServiceRequestVCDataController {
    var delegate: ServiceRequestVCDataControllerDelegate?
    var selectedOffice: AirOffice?
    var note: String?
    var image: UIImage?
    var issueType: ServiceRequestTypeItem?
    
    public init(delegate: ServiceRequestVCDataControllerDelegate) {
        self.delegate = delegate
    }
    
    public func setSelectedOffice(as office: AirOffice) {
        self.selectedOffice = office 
    }
    public func setNote(as note: String) {
        self.note = note
    }
    public func setImage(as image: UIImage?) {
        self.image = image ?? nil
    }
    public func setIssueType(as type: ServiceRequestTypeItem) {
        self.issueType = type
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
