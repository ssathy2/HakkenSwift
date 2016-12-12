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

class Story: Object, HackernewsModelable {
    dynamic var base: HackernewsNewsModel? = nil
    dynamic var score: Int = 0
    dynamic var title: String = ""
    dynamic var urlString: String = ""
    var url: URL? {
        get {
            return URL(string: urlString)
        }
        set {
            if let newValue = newValue {
                urlString = newValue.absoluteString
            }
        }
    }
    
    required convenience init(json: [String: AnyObject]) throws {
        self.init()
        self.base = try HackernewsNewsModel(json: json)
        self.score = try json.int(key: "score")
        self.title = try json.string(key: "title")
        self.urlString = try json.string(key: "url")
    }
    
    override static func ignoredProperties() -> [String] {
        return ["url"]
    }
}
