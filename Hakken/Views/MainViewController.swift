//
//  MainViewController.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 12/25/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import UIKit

class MainViewController: ViewController {
    var containerSplitViewController: UISplitViewController?
    
    override func segueIdentifierToContainerViewControllerMapping() -> [String : String]? {
        return [ "EmbedSplitViewControllerSegue" : "containerSplitViewController" ]
    }
    
    override class func storyboardName() -> String {
        return "Main"
    }
    
    override class func identifier() -> String {
        return "MainViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router = Router(splitViewController: containerSplitViewController!, viewControllerMap: [ "StoryList": StoryListViewController.self])
        router?.root(view: "StoryList", data: nil, animated: true)
    }
}

