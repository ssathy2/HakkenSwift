//
//  Story.swift
//  Hakken
//
//  Created by Sidd Sathyam on 10/11/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class Story: Object, JSONInitializable {
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
    dynamic var score: Int = 0
    dynamic var title: String = ""
    dynamic var urlString: String? = nil
    var url: URL? {
        get {
            guard let urlString = urlString else {
                return nil
            }
            return URL(string: urlString)
        }
        set {
            if let newValue = newValue {
                urlString = newValue.absoluteString
            }
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience required init(json: [String: AnyObject]) throws {
        self.init()
        self.by = try json.string(key: "by")
        self.id = try json.int(key: "id")
        self.time = Date(timeIntervalSince1970: TimeInterval(try json.int(key: "time")))
        self.type = try json.string(key: "type")
        self.score = try json.int(key: "score")
        self.title = try json.string(key: "title")
        self.urlString = json["url"] as? String
    }
    
    override static func ignoredProperties() -> [String] {
        return ["url"]
    }
}
