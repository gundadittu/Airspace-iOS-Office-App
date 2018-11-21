//
//  DateController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 11/20/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import SwiftDate

class DateController {
    static let shared = DateController()
    
    func convertDateToColloqString(date: Date) -> String {
        return date.toRelative(style: RelativeFormatter.defaultStyle() , locale: nil)
    }
    
    func convertDateToString(date: Date) -> String {
        return date.toFormat("MMM dd',' yyyy 'at' HH:mm")
    }
    
    func convertDateToISOString(date: Date) -> String {
        return date.toISO()
    }
}

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options, timeZone: TimeZone? = nil) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone ?? TimeZone(abbreviation: "UTC")!
    }
}

extension Formatter {
    struct Date {
        static let iso8601 = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
    }
}
