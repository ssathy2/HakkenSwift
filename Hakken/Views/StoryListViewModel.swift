//
//  StoryListViewModel.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 12/24/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import Foundation
import RxSwift

class StoryListViewModel: ViewModel {
    private static let StoriesRefreshFetchCount    = 20
    private static let StoriesMaxTopStoriesCount   = 500

    let storiesService: StoriesService
    var list = BehaviorSubject<ArrayInsertionDeletion<Story>>(value: ArrayInsertionDeletion<Story>())
    var currentArrayInsertionDeletion = ArrayInsertionDeletion<Story>()
    var isFetchingStories = false
    var storyFrom = 0
    var storyTo = StoriesRefreshFetchCount
    
    override func update(data: AnyObject?) {
        super.update(data: data)
    }
    
    init(storiesService: StoriesService) {
        self.storiesService = storiesService
    }
    
    required convenience init() {
        // TODO: Replace this!
        self.init(storiesService: TopStories())
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        let _ = storiesService
                .stories(from: storyFrom, to: storyTo)
                .flatMap {
                    self.currentArrayInsertionDeletion.add(items: $0)
                }
                .subscribe(onNext: { (latestArrayInsertionDeletion) in
                    self.list.onNext(latestArrayInsertionDeletion)
                    }, onError: { (error) in
                        self.list.onError(error)
                    }, onCompleted: {
                        self.list.onCompleted()
                    }, onDisposed: nil)
        
    }
}
