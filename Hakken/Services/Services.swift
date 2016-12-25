//
//  Services.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 12/24/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import Foundation
import RxSwift

protocol Services {
    func topstories(from: Int, to: Int) -> Observable<[Story]>
    func showhnstories(from: Int, to: Int) -> Observable<[Story]>
    func askhnstories(from: Int, to: Int) -> Observable<[Story]>
    func jobhnstories(from: Int, to: Int) -> Observable<[Story]>
    func newhnstories(from: Int, to: Int) -> Observable<[Story]>
    func comments(storyId: Int) -> Observable<[Comment]>
}
