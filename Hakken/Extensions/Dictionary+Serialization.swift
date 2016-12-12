//
//  Dictionary+Serialization.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 12/4/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import Foundation
import RealmSwift

enum DictionarySerializationError: Error {
    case MissingKey(String)
    case InvalidType(String)
}

extension Dictionary where Key: ExpressibleByStringLiteral, Value: AnyObject {
    func serialize<T>(key: String) throws -> T {
        guard let val = self[key as! Key] else {
            throw DictionarySerializationError.MissingKey("\(key) not found in dictionary")
        }
        
        guard let serializedVal = val as? T else {
            throw DictionarySerializationError.InvalidType("\(key) has invalid type")
        }
        
        return serializedVal

    }
    
    func url(key: String) throws -> URL {
        let urlString: String = try serialize(key: key)
        guard let url = URL(string: urlString) else {
            throw DictionarySerializationError.InvalidType("Can't create URL with url string \(urlString)")
        }
        return url
    }
    
    func string(key: String) throws -> String {
        return try serialize(key: key)
    }
    
    func int(key: String) throws -> Int {
        return try serialize(key: key)
    }
    
    func date(key: String, dateFormat: String) throws -> Date {
        return try DateFormatterManager.sharedInstance.date(dateString: try serialize(key: key), dateFormat: dateFormat)
    }
    
    func model<T: JSONInitializable>(key: String) throws -> T {
        return try T(json: try serialize(key: key))
    }
    
    func array<T: JSONInitializable>(key: String) throws -> [T] {
        let valArray: [[String: AnyObject]] = try serialize(key: key)
        
        return try valArray.map({ (dict) -> T in
            return try T(json: dict)
        })
    }
    
    func enumValue<T: StringEnumerable>(key: String) throws -> T {
        return try T(string: try serialize(key: key))
    }
}
