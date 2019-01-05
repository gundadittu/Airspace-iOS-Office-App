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
    var buildingDetails: URL?
    var floorPlan: URL?
    var onboardingURL: URL?
    
    public init(delegate: SpaceInfoTVCDataControllerDelegate) {
        self.delegate = delegate
        self.loadData()
    }
    
    func loadData() {
        self.delegate?.startLoadingIndicator()
        self.delegate?.stopLoadingIndicator()
        self.delegate?.didLoadData()
    }
}
