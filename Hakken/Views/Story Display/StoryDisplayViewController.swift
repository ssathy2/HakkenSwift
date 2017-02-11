//
//  StoryDisplayViewController.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 2/11/17.
//  Copyright © 2017 dotdotdot. All rights reserved.
//

import WebKit

class StoryDisplayViewController: ViewController {
    @IBOutlet weak var articleDisplayContainer: UIView!
    @IBOutlet weak var webviewContainer: UIView!
    @IBOutlet weak var articleDisplayContainerHeightConstraint: NSLayoutConstraint!
    
    private var story: Story?
    
    override class func storyboardName() -> String {
        return "StoryDisplay"
    }
    
    override class func identifier() -> String {
        return "StoryDisplayViewController"
    }
    
    override func update(data: AnyObject?) {
        super.update(data: data)
        if let story = data as? Story {
            self.story = story
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        setupArticleDisplay()
        setupWebView()
    }
    
    func setupArticleDisplay() {
        let storyListCollectionViewCell = StoryListCollectionViewCell.view as! StoryListCollectionViewCell
        storyListCollectionViewCell.update(model: story!)
        storyListCollectionViewCell.setNeedsLayout()
        storyListCollectionViewCell.layoutIfNeeded()
        articleDisplayContainerHeightConstraint.constant = storyListCollectionViewCell.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        storyListCollectionViewCell.translatesAutoresizingMaskIntoConstraints = false
        articleDisplayContainer.addSubview(storyListCollectionViewCell)
        articleDisplayContainer.addConstraints(NSLayoutConstraint.fl_layoutConstraints(from: articleDisplayContainer, to: storyListCollectionViewCell, edges: .all))
        view.setNeedsUpdateConstraints()
    }
    
    func setupWebView() {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webviewContainer.addSubview(webView)
        webviewContainer.addConstraints(NSLayoutConstraint.fl_layoutConstraints(from: webviewContainer, to: webView, edges: .all))
        view.setNeedsUpdateConstraints()
        webView.load(URLRequest(url: story!.url!))
    }
}
