//
//  Date+Convenience.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 12/24/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import Foundation

public extension Date {
    static func date(dateFormat: String, dateString: String) throws -> Date {
        let dateFormatter = DateFormatter.dateFormatter(dateFormat: dateFormat)
        if let date = dateFormatter.date(from: dateString) {
            return date
        }
        else {
            throw DateFormatterError.DateFormatMismatch("Expecting a date string with format: \(dateFormat) but got date string: \(dateString)")
        }
    }
    
    func string(dateFormat: String) throws -> String {
        return DateFormatter.dateFormatter(dateFormat: dateFormat).string(from: self)
    }
}
