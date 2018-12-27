//
//  ServiceRequestVCSection.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/27/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

class ServiceRequestVCSection: PageSection {
    var title = ""
    var buttonTitle = ""
    var selectedButtonTitle: String?
    var type: ServiceRequestVCSectionType = .none
    
    public init(title: String, buttonTitle: String, type: ServiceRequestVCSectionType) {
        self.title = title
        self.buttonTitle = buttonTitle
        self.type = type
    }
}

enum ServiceRequestVCSectionType {
    case location
    case serviceType
    case image
    case note
    case submit
    case none
}
