//
//  Comment.swift
//  Hakken
//
//  Created by Sidd Sathyam on 10/11/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class Comment: Object, JSONInitializable, TrackableItem {
    var kids: List<Comment> = List<Comment>()
    dynamic var parent: Int = 0
    dynamic var text: String = ""
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
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init(json: [String: AnyObject]) throws {
        self.init()
        self.by = try json.string(key: "by")
        self.id = try json.int(key: "id")
        self.time = Date(timeIntervalSince1970: TimeInterval(try json.int(key: "time")))
        self.type = try json.string(key: "type")
        let valArray: [[String: AnyObject]] = try json.serialize(key: "kids")
        let list = List<Comment>()
        for dict in valArray {
            let obj = try Comment(json: dict)
            list.append(obj)
        }
        self.kids = list
        self.parent = try json.int(key: "id")
        self.text = try json.string(key: "text")
    }
}
