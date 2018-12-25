//
//  DateTimeInputVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/18/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit

protocol DateTimeInputVCDelegate {
    func didSaveInput(with date: Date, and identifier: String?)
}

class DateTimeInputVC: UIViewController {
    
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    var mode: UIDatePicker.Mode?
    var delegate: DateTimeInputVCDelegate?
    var identifier: String?
    var initialDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Choose Date and Time"
        guard let _ = self.delegate else {
            fatalError("Need to provide delegate value for DateTimeInputVC")
        }
        
        if let mode = self.mode {
            self.dateTimePicker.datePickerMode = mode
            if mode == .date {
                self.title = "Choose Date"
            } else if mode == .time {
                self.title = "Choose Time"
            }
        }
        
        self.dateTimePicker.minimumDate = Date()
        
        self.dateTimePicker.tintColor = globalColor
        if let initialDate = self.initialDate  {
            self.dateTimePicker.setDate(initialDate, animated: false)
        } else {
            self.dateTimePicker.setDate(Date(), animated: true)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didClickSave))
    }
    
    @objc func didClickSave() {
        let date = self.dateTimePicker.date
        self.delegate?.didSaveInput(with: date, and: self.identifier)
        self.navigationController?.popViewController(animated: true)
    }
    
}

