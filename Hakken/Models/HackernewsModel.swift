//
//  HackernewsModel.swift
//  Hakken
//
//  Created by Sidd Sathyam on 10/11/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import UIKit

//"by": "trkulja",
//"id": 10284607,
//"parent": 10284321,
//"text": "Hey guys,<p>Damjan asked me to post a comment here, he says he is sorry but HN is not allowing him to respond to all coments quick enough. But stay assured he will anwer each and every question. :)<p>Cheers.",
//"time": 1443305735,
//"type": "comment"

enum HackernewsModelType: String {
    case Comment = "comment"
    case Story   = "story"
    case User    = "user"
}

class HackernewsModel: NSObject {
    var by: String = ""
    var id: String = ""
    var time: Date = Date()
    var type: HackernewsModelType = .Story
}
