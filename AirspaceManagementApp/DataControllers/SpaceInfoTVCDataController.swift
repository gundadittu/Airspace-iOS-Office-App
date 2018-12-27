//
//  SpaceInfoTVCDataController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/26/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

class SpaceInfoTVCDataController {
    var delegate: SpaceInfoTVCDataControllerDelegate?
    
    public init(delegate: SpaceInfoTVCDataControllerDelegate) {
        self.delegate = delegate 
    }
}
