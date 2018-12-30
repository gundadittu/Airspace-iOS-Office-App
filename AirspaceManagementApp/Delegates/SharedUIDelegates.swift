//
//  SharedUIDelegates.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/30/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

protocol TextInputVCDelegate {
    func didSaveInput(with text: String, and identifier: String?)
}

protocol DateTimeInputVCDelegate {
    func didSaveInput(with date: Date, and identifier: String?)
    func changeInDate(interval: TimeInterval, and identifier: String?)
}

extension DateTimeInputVCDelegate {
    func changeInDate(interval: TimeInterval, and identifier: String?) {
        // makes method optional
    }
}
