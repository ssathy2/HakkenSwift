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

class Comment: Object, HackernewsModelable {
    dynamic var base: HackernewsNewsModel? = nil
    var kids: List<Comment> = List<Comment>()
    dynamic var parent: Int = 0
    dynamic var text: String = ""
    
    required convenience init(json: [String: AnyObject]) throws {
        self.init()
        self.base = try HackernewsNewsModel(json: json)
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
