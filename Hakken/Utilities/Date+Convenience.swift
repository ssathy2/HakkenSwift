//
//  Date+Convenience.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 12/24/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import Foundation

public extension Date {
    private static let SECONDSINONEMINUTE = 60.0
    private static let SECONDSINONEHOUR = (SECONDSINONEMINUTE * 60.0)
    private static let SECONDSINONEDAY = (SECONDSINONEHOUR * 24.0)
    
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
    
    func relativeDateTimeStringToNow() -> String {
        let timeDifferenceBetweenDates = Date().timeIntervalSince(self)
        
        if (timeDifferenceBetweenDates >= 0 && timeDifferenceBetweenDates < Date.SECONDSINONEMINUTE) {
            return (timeDifferenceBetweenDates == 1) ? "\(timeDifferenceBetweenDates) second ago" : "\(timeDifferenceBetweenDates) seconds ago";
        }
        else if (timeDifferenceBetweenDates >= Date.SECONDSINONEMINUTE && timeDifferenceBetweenDates < Date.SECONDSINONEHOUR) {
            let timeVal = Int(timeDifferenceBetweenDates/Date.SECONDSINONEMINUTE);
            return (timeVal == 1) ? "\(timeVal) minute ago" : "\(timeVal) minutes ago"
        }
        else if (timeDifferenceBetweenDates >= Date.SECONDSINONEHOUR && timeDifferenceBetweenDates < Date.SECONDSINONEDAY) {
            let timeVal = Int(timeDifferenceBetweenDates/Date.SECONDSINONEHOUR);
            return (timeVal == 1) ? "\(timeVal) hour ago" : "\(timeVal) hours ago"
        }
        else {
            let timeVal = Int(timeDifferenceBetweenDates/Date.SECONDSINONEDAY);
            return (timeVal == 1) ? "\(timeVal) day ago" : "\(timeVal) days ago"
        }
    }
}
