//
//  Services.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 12/24/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import Foundation
import RxSwift

protocol StoriesService {
    func stories(from: Int, to: Int) -> Observable<[Story]>
}

protocol CommentsService {
    func comments(storyId: Int) -> Observable<[Comment]>
}
