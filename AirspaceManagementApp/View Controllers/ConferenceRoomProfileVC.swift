//
//  ConferenceRoomProfileTVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/20/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit
import DateTimePicker

class ConferenceRoomProfileTVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func showPicker(min: Date, max: Date) {
        let picker = DateTimePicker.create(minimumDate: min, maximumDate: max)
        picker.frame = CGRect(x: 0, y: (self.view.layer.frame.height - picker.frame.size.height), width: picker.frame.size.width, height: picker.frame.size.height)
        self.view.addSubview(picker)
    }
}
