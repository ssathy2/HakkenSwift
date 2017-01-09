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
    var pageViewControllerScrollView: UIScrollView? {
        return self.pageViewController?.view.subviews.filter { $0 is UIScrollView }.first as? UIScrollView
    }

    let options: [SlidingTabOption] = [.Top, .New, .Show, .Ask, .Jobs]
    
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
        pageViewController?.dataSource = self
        pageViewControllerScrollView?.delegate = self
        
        setupSlidingTabView()
        if let initialViewController = orderedViewControllers.first {
            pageViewController?.setViewControllers([initialViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    private func setupSlidingTabView() {
        slidingTabView.delegate = self
        slidingTabView.setup(options: options)
        slidingTabView.translatesAutoresizingMaskIntoConstraints = false
        slidingTabContainerView.addSubview(slidingTabView)
        slidingTabContainerView.addConstraints(NSLayoutConstraint.fl_layoutConstraints(from: slidingTabContainerView, to: slidingTabView, edges: .all))
        slidingTabContainerView.setNeedsUpdateConstraints()
    }
    
    func scrollToViewController(index newIndex: Int) {
        if let firstViewController = pageViewController?.viewControllers?.first,
            let currentIndex = orderedViewControllers.index(of: firstViewController) {
            let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .forward : .reverse
            let nextViewController = orderedViewControllers[newIndex]
            scrollToViewController(viewController: nextViewController, direction: direction)
        }
    }
    
    private func scrollToViewController(viewController: UIViewController,
                                        direction: UIPageViewControllerNavigationDirection = .forward) {
        pageViewController?.setViewControllers([viewController], direction: direction, animated: true, completion: nil)
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

extension HomeScreenViewController: SlidingTabViewDelegate {
    func didTapOption(option: SlidingTabOption) {
        guard let index = options.index(of: option) else {
            print("Option not found")
            return
        }
        
        scrollToViewController(index: index)
    }
}

extension HomeScreenViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = scrollView.contentOffset
        var percentComplete: CGFloat
        percentComplete = (point.x - view.frame.size.width)/view.frame.size.width
        print("percentComplete: \(percentComplete)")
    }
}
