//
//  SubmitTicketField.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/21/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

enum SubmitTicketFieldType {
    case buildingLocation
    case officeLocation
    case note
}

class SubmitTicketField: NSObject {
    var title: String?
    var actionTitle: String?
    var type: SubmitTicketFieldType?
    
    public init(title: String, actionTitle: String) {
        self.title = title
        self.actionTitle = actionTitle
    }

}
