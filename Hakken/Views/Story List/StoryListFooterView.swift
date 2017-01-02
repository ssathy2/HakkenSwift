//
//  StoryListFooterView.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 12/26/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import CocoaLumberjack

enum FooterViewState {
    case Rest
    case Dragging
    case Refreshing
}

protocol StoryListFooterViewDelegate: class {
    func didTapMore()
}

class StoryListFooterView: UICollectionReusableView {
    private let FooterReleaseHeight: CGFloat = 50.0
    
    private let releaseToLoadMoreText = "Release to Load More"
    private let pullToLoadMoreText = "Pull to Load More"
    private var footerViewState: FooterViewState = .Rest
    
    weak var delegate: StoryListFooterViewDelegate?
    
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var instructionalLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        viewStateChanged(state: .Rest)
    }
    
    private func viewStateChanged(state: FooterViewState) {
        footerViewState = state
        switch state {
            case .Refreshing:
                moreLabel.alpha = 0
                activityIndicator.alpha = 1
                instructionalLabel.alpha = 0
                activityIndicator.startAnimating()
            case .Dragging:
                moreLabel.alpha = 0
                activityIndicator.alpha = 0
                instructionalLabel.alpha = 0
                activityIndicator.stopAnimating()
            case .Rest:
                moreLabel.alpha = 1
                activityIndicator.alpha = 0
                instructionalLabel.alpha = 0
                activityIndicator.stopAnimating()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapBackground = UITapGestureRecognizer()
        tapBackground.addTarget(self, action: #selector(didTapView))
        addGestureRecognizer(tapBackground)
        viewStateChanged(state: .Refreshing)
    }
    
    func didTapView(gestureRecognizer: UIGestureRecognizer) {
        viewStateChanged(state: .Refreshing)
        delegate?.didTapMore()
    }
    
    func finishRefreshing() {
        viewStateChanged(state: .Rest)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        viewStateChanged(state: .Dragging)
        let amountScrolledUnderneathView = (scrollView.contentOffset.y + scrollView.bounds.height) - scrollView.contentSize.height
        let percentageScrolled          = amountScrolledUnderneathView / FooterReleaseHeight
        moreLabel.alpha = 1.0-percentageScrolled
        instructionalLabel.alpha = percentageScrolled
        instructionalLabel.text = (percentageScrolled < 0.7) ? pullToLoadMoreText : releaseToLoadMoreText
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView) {
        let amountScrolledUnderneathView = (scrollView.contentOffset.y + scrollView.bounds.height) - scrollView.contentSize.height
        let percentageScrolled          = amountScrolledUnderneathView / FooterReleaseHeight
        if (percentageScrolled >= 0.7) {
            viewStateChanged(state: .Refreshing)
            delegate?.didTapMore()
        }
    }
}
