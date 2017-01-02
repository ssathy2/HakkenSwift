//
//  StoryListViewModel.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 12/24/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class StoryListViewModel: ViewModel {
    private static let StoriesRefreshFetchCount    = 20
    private static let StoriesMaxTopStoriesCount   = 500

    var storiesService: StoriesService
    private var storiesArrayInsertionDeletion = ArrayInsertionDeletion<Story>()
    let storiesList = BehaviorSubject<ArrayInsertionDeletion<Story>>(value: ArrayInsertionDeletion<Story>())
    
    var isFetchingStories = false

    private var storyFrom = 0
    private var storyTo = StoriesRefreshFetchCount
        
    override func update(data: AnyObject?) {
        super.update(data: data)
    }
    
    init(storiesService: StoriesService) {
        self.storiesService = storiesService
        super.init()
    }
    
    func fetchNextStories() {
        let from = (storyFrom == 0) ? 0 : storyTo + 1
        let to   = (storyTo == StoryListViewModel.StoriesRefreshFetchCount) ? StoryListViewModel.StoriesRefreshFetchCount : storyTo + StoryListViewModel.StoriesRefreshFetchCount
        
        let _ = storiesService
            .stories(from: from, to: to)
            .flatMap { (stories) -> Observable<ArrayInsertionDeletion<Story>> in
                return self.storiesArrayInsertionDeletion.add(items: stories)
            }
            .bindTo(storiesList)
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    func canFetchMoreStories() -> Bool {
        return storyTo < StoryListViewModel.StoriesMaxTopStoriesCount
    }
}
