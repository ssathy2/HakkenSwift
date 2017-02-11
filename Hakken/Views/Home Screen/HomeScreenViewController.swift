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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var slidingTabContainerView: UIView!
    @IBOutlet weak var slidingTabHeightConstraint: NSLayoutConstraint!
    
    let slidingTabView = SlidingTabView.instance()!
    
    lazy var topStoriesView: StoryListViewController = {
        let storyListVC = StoryListViewController.instance() as! StoryListViewController
        storyListVC.delegate = self
        storyListVC.setup(storiesService: TopStories())
        return storyListVC
    }()
    
    lazy var newStoriesView: StoryListViewController = {
        let storyListVC = StoryListViewController.instance() as! StoryListViewController
        storyListVC.delegate = self
        storyListVC.setup(storiesService: NewHNStories())
        return storyListVC
    }()
    
    lazy var showStoriesView: StoryListViewController = {
        let storyListVC = StoryListViewController.instance() as! StoryListViewController
        storyListVC.delegate = self
        storyListVC.setup(storiesService: ShowHNStories())
        return storyListVC
    }()
    
    lazy var jobsStoriesView: StoryListViewController = {
        let storyListVC = StoryListViewController.instance() as! StoryListViewController
        storyListVC.delegate = self
        storyListVC.setup(storiesService: JobHNStories())
        return storyListVC
    }()
    
    lazy var askHNStoriesView: StoryListViewController = {
        let storyListVC = StoryListViewController.instance() as! StoryListViewController
        storyListVC.delegate = self
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

    let options: [SlidingTabOption] = [.Top, .New, .Show, .Ask, .Jobs]
    fileprivate let CellReuseIdentifier = "CellReuseIdentifier"
    override class func storyboardName() -> String {
        return "HomeScreen"
    }
    
    override class func identifier() -> String {
        return "HomeScreenViewController"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupSlidingTabView()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: CellReuseIdentifier)
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing = 0.0
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing = 0.0
    }
    
    private func setupSlidingTabView() {
        slidingTabView.delegate = self
        slidingTabView.setup(options: options)
        slidingTabView.translatesAutoresizingMaskIntoConstraints = false
        slidingTabContainerView.addSubview(slidingTabView)
        slidingTabContainerView.addConstraints(NSLayoutConstraint.fl_layoutConstraints(from: slidingTabContainerView, to: slidingTabView, edges: .all))
        slidingTabContainerView.setNeedsUpdateConstraints()
    }
    
    fileprivate func scrollToViewController(index newIndex: Int) {
        collectionView.scrollToItem(at: IndexPath(row: newIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    fileprivate func host(viewController: UIViewController, inView: UIView) {
        addChildViewController(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        inView.addSubview(viewController.view)
        inView.addConstraints(NSLayoutConstraint.fl_layoutConstraints(from: inView, to: viewController.view, edges: .all))
        viewController.didMove(toParentViewController: self)
    }
    
    fileprivate func unhost(viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
}

extension HomeScreenViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        slidingTabView.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        slidingTabView.scrollViewWillBeginDragging(scrollView)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        slidingTabView.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}

extension HomeScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

extension HomeScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        host(viewController: orderedViewControllers[indexPath.row], inView: cell.contentView)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        unhost(viewController: orderedViewControllers[indexPath.row])
    }
}

extension HomeScreenViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderedViewControllers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellReuseIdentifier, for: indexPath)
        return cell
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

extension HomeScreenViewController: StoryListViewDelegate {
    func listViewDidTap(story: Story) {
        router?.push(view: "StoryDisplay", data: story, animated: true)
    }
    
    func listViewDidScroll(_ collectionView: UICollectionView) {
        //TODO: Implement me
    }
    
    func listViewWillEndDragging(_ collectionView: UICollectionView, targetContentOffset: CGPoint) {
        //TODO: Implement me
    }
    
    func listViewWillBeginDragging(_ collectionView: UICollectionView) {
        //TODO: Implement me
    }
}
