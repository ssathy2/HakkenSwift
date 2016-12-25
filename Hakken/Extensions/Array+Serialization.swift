//
//  Array+Serialization.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 12/24/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import Foundation

extension Array where Element: ExpressibleByDictionaryLiteral {
    func serialize<T: JSONInitializable>() throws -> [T] {
        return try map({ (element) -> T in
            let elementDict = element as! [String: AnyObject]
            return try T(json: elementDict)
        })
    }
}
