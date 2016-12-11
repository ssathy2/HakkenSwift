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

class Story: HackernewsModel {
    dynamic var score: Int = 0
    dynamic var title: String = ""
    dynamic var url = URL(fileURLWithPath: "")
    
    required init(json: [String: AnyObject]) throws {
        try super.init(json: json)
        self.score = try json.int(key: "score")
        self.title = try json.string(key: "title")
        self.url = try json.url(key: "url")
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
