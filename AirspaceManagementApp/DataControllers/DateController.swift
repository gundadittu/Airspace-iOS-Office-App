//
//  DateController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 11/20/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

extension Date {
    
    var localizedDescription: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let shortDateString = dateFormatter.string(from: self)
        return shortDateString
    }
}

extension Formatter {
    struct Date {
        static let iso8601 = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
    }
}

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options, timeZone: TimeZone? = nil) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone ?? TimeZone(abbreviation: "UTC")!
    }
}
