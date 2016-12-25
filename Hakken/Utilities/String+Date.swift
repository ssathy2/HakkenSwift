//
//  String+Date.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 12/24/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import Foundation

extension String {
    func date(dateFormat: String) throws -> Date {
        let dateFormatter = DateFormatter.dateFormatter(dateFormat: dateFormat)
        if let date = dateFormatter.date(from: self) {
            return date
        }
        else {
            throw DateFormatterError.DateFormatMismatch("Expecting a date string with format: \(dateFormat) but got date string: \(self)")
        }
    }
}
