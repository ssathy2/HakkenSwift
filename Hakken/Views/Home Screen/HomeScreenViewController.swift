//
//  HomeScreenViewController.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 12/26/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import UIKit

enum SlidingTabOption: String, CustomStringConvertible {
    case Top = "Top"
    case New = "New"
    case Show = "Show"
    case Jobs = "Jobs"
    case Ask = "Ask"
    
    init(string: String) {
        switch (string) {
        case "Top": self = .Top
        case "New": self = .New
        case "Show": self = .Show
        case "Jobs": self = .Jobs
        case "Ask": self = .Ask
        default:
            self = .Top
        }
    }
    
    var description: String {
        return rawValue
    }
}

class HomeScreenViewController: ViewController {
    @IBOutlet weak var slidingTabContainerView: UIView!
    private let slidingTabView = SlidingTabView.instance()!
    
    lazy var topStoriesView: StoryListViewController = {
        let storyListVC = StoryListViewController.instance() as! StoryListViewController
        storyListVC.setup(storiesService: TopStories())
        return storyListVC
    }()
    
    lazy var newStoriesView: StoryListViewController = {
        let storyListVC = StoryListViewController.instance() as! StoryListViewController
        storyListVC.setup(storiesService: NewHNStories())
        return storyListVC
    }()
    
    lazy var showStoriesView: StoryListViewController = {
        let storyListVC = StoryListViewController.instance() as! StoryListViewController
        storyListVC.setup(storiesService: ShowHNStories())
        return storyListVC
    }()
    
    lazy var jobsStoriesView: StoryListViewController = {
        let storyListVC = StoryListViewController.instance() as! StoryListViewController
        storyListVC.setup(storiesService: JobHNStories())
        return storyListVC
    }()
    
    lazy var askHNStoriesView: StoryListViewController = {
        let storyListVC = StoryListViewController.instance() as! StoryListViewController
        storyListVC.setup(storiesService: AskHNStories())
        return storyListVC
    }()
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        // The view controllers will be shown in this order
        return [self.topStoriesView,
                self.newStoriesView,
                self.showStoriesView,
                self.askHNStoriesView,
                self.jobsStoriesView]
    }()
    
    
    var pageViewController: UIPageViewController?

    override class func storyboardName() -> String {
        return "HomeScreen"
    }
    
    override class func identifier() -> String {
        return "HomeScreenViewController"
    }
    
    override func segueIdentifierToContainerViewControllerMapping() -> [String : String]? {
        return [ "EmbedPageViewController" : "pageViewController" ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController?.delegate = self
        pageViewController?.dataSource = self
        
        setupSlidingTabView()
        if let initialViewController = orderedViewControllers.first {
            pageViewController?.setViewControllers([initialViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    private func setupSlidingTabView() {
        slidingTabView.setup(options: [.Top, .New, .Show, .Ask, .Jobs])
        slidingTabView.translatesAutoresizingMaskIntoConstraints = false
        slidingTabContainerView.addSubview(slidingTabView)
        slidingTabContainerView.addConstraints(NSLayoutConstraint.fl_layoutConstraints(from: slidingTabContainerView, to: slidingTabView, edges: .all))
        slidingTabContainerView.setNeedsUpdateConstraints()
    }
}

extension HomeScreenViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
                return nil
            }
            
            let previousIndex = viewControllerIndex - 1
            
            guard previousIndex >= 0 else {
                return nil
            }
            
            guard orderedViewControllers.count > previousIndex else {
                return nil
            }
            
            return orderedViewControllers[previousIndex]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
                return nil
            }
            
            let nextIndex = viewControllerIndex + 1
            let orderedViewControllersCount = orderedViewControllers.count
            
            guard orderedViewControllersCount != nextIndex else {
                return nil
            }
            
            guard orderedViewControllersCount > nextIndex else {
                return nil
            }
            
            return orderedViewControllers[nextIndex]
    }
}

extension HomeScreenViewController: UIPageViewControllerDelegate {
    
}
