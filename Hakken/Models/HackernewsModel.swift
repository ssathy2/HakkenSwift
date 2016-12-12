//
//  HackernewsModel.swift
//  Hakken
//
//  Created by Sidd Sathyam on 10/11/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

protocol StringEnumerable {
    init(string: String) throws
}

protocol JSONInitializable {
    init(json: [String: AnyObject]) throws
}

enum SerializationError: Error {
    case UnknownEnum
}

enum HackernewsModelType: String, StringEnumerable {
    case Comment = "comment"
    case Story   = "story"
    case User    = "user"
    
    init(string: String) throws {
        switch (string) {
            case "comment": self = .Comment
            case "story": self = .Story
            case "user": self = .User
            default:
                throw SerializationError.UnknownEnum
        }
    }
}

protocol HackernewsModelable: JSONInitializable {
    var base: HackernewsNewsModel? { get set }
}

class HackernewsNewsModel: Object, JSONInitializable {
    dynamic var by: String = ""
    dynamic var id: Int = 0
    dynamic var time: Date = Date(timeIntervalSince1970: 0)
    dynamic var type: HackernewsModelType.RawValue = HackernewsModelType.Comment.rawValue
    var enumType: HackernewsModelType {
        get {
            return HackernewsModelType(rawValue: type)!
        }
        set {
            type = newValue.rawValue
        }
    }
    
    required convenience init(json: [String: AnyObject]) throws {
        self.init()
        self.by = try json.string(key: "by")
        self.id = try json.int(key: "id")
        self.time = Date(timeIntervalSince1970: TimeInterval(try json.int(key: "time")))
        self.type = try json.string(key: "type")
    }
}
