//
//  DateFormatterManager.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 12/4/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import UIKit

enum DateFormatterError: Error {
    case DateStringDateFormatMismatch
}

class DateFormatterManager {
    static let sharedInstance = DateFormatterManager()
    var dateFormatStringToDateFormatterMap: [String: DateFormatter] = [String: DateFormatter]()
    
    private func date(dateFormatter: DateFormatter, dateString: String) throws -> Date {
        guard let date = dateFormatter.date(from: dateString) else {
            throw DateFormatterError.DateStringDateFormatMismatch
        }
        return date
    }
    
    func date(dateString: String, dateFormat: String) throws -> Date {
        var dateFormatter = dateFormatStringToDateFormatterMap[dateFormat] as DateFormatter?
        if (dateFormatter == nil) {
            dateFormatter = DateFormatter()
            dateFormatter!.dateFormat = dateFormat
            dateFormatStringToDateFormatterMap[dateFormat] = dateFormatter!
        }
        return try date(dateFormatter: dateFormatter!, dateString: dateString)
    }
}
