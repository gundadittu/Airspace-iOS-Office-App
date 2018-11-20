//
//  RegisterGuestTVCDataController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 11/19/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

protocol RegisterGuestTVCDataControllerDelegate {
    func didUpdateSections(sections: [RegisterGuestVCSection])
}

class RegisterGuestTVCDataController {
    var delegate: RegisterGuestTVCDataControllerDelegate?
    
    public init(delegate: RegisterGuestTVCDataControllerDelegate) {
        self.delegate = delegate
    }
}
