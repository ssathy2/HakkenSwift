//
//  HackernewsModel.swift
//  Hakken
//
//  Created by Sidd Sathyam on 10/11/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import UIKit
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
