//
//  StoryListViewController.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 12/24/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import Foundation

class StoryListViewController: ViewController {
    var storyListViewModel: StoryListViewModel {
        return viewModel as! StoryListViewModel
    }
    
    override class func storyboardName() -> String {
        return "StoryList"
    }
    
    override class func identifier() -> String {
        return "StoryListViewController"
    }
    
    override class func viewModelClass() -> ViewModel.Type {
        return StoryListViewModel.self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storyListViewModel.list.subscribe(onNext: { (a) in
            print(a)
            }, onError: { (error) in
                print(error)
            }, onCompleted: { 
                print("done")
            }, onDisposed: nil)
    }
}
