//
//  DateTimeInputVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/18/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit
import SwiftDate

class DateTimeInputVC: UIViewController {
    
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    var mode: UIDatePicker.Mode?
    var delegate: DateTimeInputVCDelegate?
    var identifier: String?
    var initialDate: Date?
    var minimumDate: Date?
    var maximumDate: Date?
    
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
        
        self.dateTimePicker.date = self.initialDate ?? Date()
        
        if let minimumDate = self.minimumDate  {
            self.dateTimePicker.minimumDate = minimumDate
        } else if let initialDate = self.initialDate {
            // initial date, but no minimum
            if initialDate.isToday {
                self.dateTimePicker.minimumDate = Date()
            } else {
                var dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: initialDate)
                dateComponents.setValue(0, for: .hour)
                dateComponents.setValue(0, for: .minute)
                dateComponents.setValue(0, for: .second)
                dateComponents.setValue(0, for: .nanosecond)
                
                if let date = dateComponents.date {
                    self.dateTimePicker.minimumDate = date
                } else {
                    self.dateTimePicker.minimumDate = initialDate
                }
            }
        } else {
            // no minimum & no initial date
            self.dateTimePicker.minimumDate = Date()
        }
        if let initialDate = self.initialDate {
            self.initialDate = initialDate
        }
        
        if let maxDate = self.maximumDate {
            self.dateTimePicker.maximumDate = maxDate
        }
        
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
        if let initialDate = self.initialDate {
            let differenceInterval = date.timeIntervalSince(initialDate)
            self.delegate?.changeInDate(interval: differenceInterval, and: self.identifier)
        }
        self.delegate?.didSaveInput(with: date, and: self.identifier)
        self.navigationController?.popViewController(animated: true)
    }
}

