//
//  DateFormatter+Convienience.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 12/24/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import Foundation

enum DateFormatterError: Error {
    case DateFormatMismatch(String)
}

private var dateFormatStringToDateFormatterMapKey: UInt8 = 0

public extension DateFormatter {
    private class var dateFormatStringToDateFormatterMap: NSCache<AnyObject, DateFormatter> {
        get {
            return associatedObjectInitializeIfNil(object: self, key: &dateFormatStringToDateFormatterMapKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC, initializer: {
                return NSCache()
            })
        }
        set {
            associateObject(object: self, key: &dateFormatStringToDateFormatterMapKey, value: newValue, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    class func dateFormatter(dateFormat: String) -> DateFormatter {
        if let dateFormatter = DateFormatter.dateFormatStringToDateFormatterMap.object(forKey: dateFormat as NSString)! as? DateFormatter {
            return dateFormatter
        }
        else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            DateFormatter.dateFormatStringToDateFormatterMap.setObject(dateFormatter, forKey: dateFormat as NSString)
            return dateFormatter
        }
    }
}
