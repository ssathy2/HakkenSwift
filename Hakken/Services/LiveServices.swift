//
//  LiveServices.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 12/24/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import RealmSwift

class TopStories: StoriesService {
    func stories(from: Int, to: Int) -> Observable<[Story]> {
        let requestURL = URL(string: "top?from=\(from)&to=\(to)", relativeTo: LiveServices.shared.baseURL)
        return LiveServices.shared.fetch(url: requestURL!)
    }
}

class ShowHNStories: StoriesService {
    func stories(from: Int, to: Int) -> Observable<[Story]> {
        let requestURL = URL(string: "showhn?from=\(from)&to=\(to)", relativeTo: LiveServices.shared.baseURL)
        return LiveServices.shared.fetch(url: requestURL!)
    }
}

class AskHNStories: StoriesService {
    func stories(from: Int, to: Int) -> Observable<[Story]> {
        let requestURL = URL(string: "askhn?from=\(from)&to=\(to)", relativeTo: LiveServices.shared.baseURL)
        return LiveServices.shared.fetch(url: requestURL!)
    }
}

class JobHNStories: StoriesService {
    func stories(from: Int, to: Int) -> Observable<[Story]> {
        let requestURL = URL(string: "jobhn?from=\(from)&to=\(to)", relativeTo: LiveServices.shared.baseURL)
        return LiveServices.shared.fetch(url: requestURL!)
    }

}

class NewHNStories: StoriesService {
    func stories(from: Int, to: Int) -> Observable<[Story]> {
        let requestURL = URL(string: "new?from=\(from)&to=\(to)", relativeTo: LiveServices.shared.baseURL)
        return LiveServices.shared.fetch(url: requestURL!)
    }
}

class Comments: CommentsService {
    func comments(storyId: Int) -> Observable<[Comment]> {
        let requestURL = URL(string: "comments/\(storyId)", relativeTo: LiveServices.shared.baseURL)
        return LiveServices.shared.fetch(url: requestURL!)
    }
}

class LiveServices {
    static var shared = LiveServices()
    var baseURL: URL {
        return URL(string: "http://hackernews-api-newyork1.siddsathyam.com/v2/")!
    }
    
    func fetch<T: JSONInitializable>(url: URL) -> Observable<[T]> {
        return Observable.create { (observer) in
            let r = request(url).responseJSON { (response) in
                switch response.result {
                case .success(let data):
                    let json = data as! [[String: AnyObject]]
                    do {
                        let data = try json.serialize() as [T]
                        try self.updateRealm(item: data)
                        observer.onNext(data)
                        observer.onCompleted()
                    }
                    catch {
                        observer.onError(error)
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                r.cancel()
            }
        }
    }
    
    func updateRealm<T: Collection>(item: T) throws {
        let realm = try Realm()
        realm.beginWrite()
        item.forEach { (element) in
            realm.add(element as! Object, update: true)
        }
        try realm.commitWrite()
    }
}
