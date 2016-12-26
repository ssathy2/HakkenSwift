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
    
    func canFetchMoreStories() -> Bool {
        return storyTo < StoryListViewModel.StoriesMaxTopStoriesCount
    }
    
    func fetchNextStories() {
        fetch(from: storyTo+1, to: storyTo+1+StoryListViewModel.StoriesRefreshFetchCount)
    }
    
    private func fetch(from: Int, to: Int) {
        if !canFetchMoreStories() || isFetchingStories {
            return
        }
        
        storyFrom = from
        storyTo   = to
        isFetchingStories = true
        
        let _ = storiesService
            .stories(from: from, to: to)
            .flatMap {
                self.currentArrayInsertionDeletion.add(items: $0)
            }
            .subscribe(onNext: { (latestArrayInsertionDeletion) in
                self.list.onNext(latestArrayInsertionDeletion)
                self.isFetchingStories = false
                }, onError: { (error) in
                    self.list.onError(error)
                    self.isFetchingStories = false
                }, onCompleted: {
                    self.list.onCompleted()
                    self.isFetchingStories = false
                }, onDisposed: nil)
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        fetch(from: 0, to: StoryListViewModel.StoriesRefreshFetchCount-1)
    }
}
