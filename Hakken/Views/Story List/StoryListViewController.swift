//
//  StoryListViewController.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 12/24/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol StoryListViewDelegate: class {
    func listViewDidScroll(_ collectionView: UICollectionView)
    func listViewWillBeginDragging(_ collectionView: UICollectionView)
    func listViewWillEndDragging(_ collectionView: UICollectionView, targetContentOffset: CGPoint)
}

class StoryListViewController: ViewController {
    @IBOutlet weak var collectionView: UICollectionView!
 
    weak var delegate: StoryListViewDelegate?
    fileprivate var storyListViewModel: StoryListViewModel {
        guard let viewModel = viewModel as? StoryListViewModel else {
            return StoryListViewModel()
        }
        return viewModel as StoryListViewModel
    }
    
    private let disposeBag = DisposeBag()
    
    override class func storyboardName() -> String {
        return "StoryList"
    }
    
    override class func identifier() -> String {
        return "StoryListViewController"
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil) { (context) in
            self.collectionView.performBatchUpdates({ 
                self.collectionView.setCollectionViewLayout(self.collectionView.collectionViewLayout, animated: true)
            }, completion: nil)
        }
    }
    
    func setup(storiesService: StoriesService) {
        viewModel = StoryListViewModel(storiesService: storiesService)
        storyListViewModel.fetchNextStories()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
       
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "StoryListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StoryListCollectionViewCell")
        collectionView.register(UINib(nibName: "StoryListFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "StoryListFooterView")
        
        let dataSource = RxCollectionViewArrayInsertionDeletionDataSource<Story>()
        
        dataSource.configureCell = { (dataSource, cv, indexPath, element) in
            let cell = cv.dequeueReusableCell(withReuseIdentifier: "StoryListCollectionViewCell", for: indexPath) as! StoryListCollectionViewCell
            cell.update(model: element)
            return cell
        }
        
        dataSource.supplementaryViewFactory = { (dataSource, cv, kind, indexPath) in
            let view = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "StoryListFooterView", for: indexPath) as! StoryListFooterView
            view.delegate = self
            return view
        }
        
        storyListViewModel
            .storiesList
            .asObservable()
            .retry(2)
            .bindTo(collectionView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
    }
}

extension StoryListViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.listViewDidScroll(collectionView)
        guard let footerView = self.collectionView.visibleSupplementaryViews(ofKind: UICollectionElementKindSectionFooter).first as? StoryListFooterView else {
            return
        }
        
        footerView.scrollViewDidScroll(scrollView: scrollView)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.listViewWillEndDragging(collectionView, targetContentOffset: targetContentOffset.pointee)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.listViewWillBeginDragging(collectionView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let footerView = self.collectionView.visibleSupplementaryViews(ofKind: UICollectionElementKindSectionFooter).first as? StoryListFooterView else {
            return
        }
        
        footerView.scrollViewDidEndDragging(scrollView: scrollView)
    }
}

extension StoryListViewController: StoryListFooterViewDelegate {
    func didTapMore() {
        storyListViewModel.fetchNextStories()
    }
}

extension StoryListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let story: Story = try! collectionView.rx.model(at: indexPath)
        return CGSize(width: collectionView.bounds.width, height: StoryListCollectionViewCell.size(model: story, modelKey: "\(story.id)").height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if storyListViewModel.canFetchMoreStories() {
            return CGSize(width: collectionView.bounds.width, height: 75.0)
        }
        else {
            return CGSize(width: collectionView.bounds.width, height: 0.0)
        }
    }
}
