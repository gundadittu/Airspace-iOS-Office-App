//
//  RegisterGuestVCSection.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/27/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

class RegisterGuestVCSection: PageSection {
    var title = ""
    var buttonTitle = ""
    var selectedButtonTitle: String?
    var type: RegisterGuestVCSectionType = .none
    
    public init(title: String, buttonTitle: String, type: RegisterGuestVCSectionType) {
        self.title = title
        self.buttonTitle = buttonTitle
        self.type = type
    }
}

enum RegisterGuestVCSectionType {
    case office
    case name
    case dateTime
    case email
    case submit
    case none
}
