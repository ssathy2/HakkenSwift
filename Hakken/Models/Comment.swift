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

class Comment: HackernewsModel {
    var kids: List<Comment> = List<Comment>()
    dynamic var parent: Int = 0
    dynamic var text: String = ""
    
    required init(json: [String: AnyObject]) throws {
        try super.init(json: json)
        self.kids = try json.list(key: "kids")
        self.parent = try json.int(key: "id")
        self.text = try json.string(key: "text")
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        fatalError("init(realm:schema:) has not been implemented")
    }
    
    required init(value: Any, schema: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }
}
