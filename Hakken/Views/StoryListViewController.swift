//
//  StoryListViewController.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 12/24/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import UIKit
import RxSwift

class StoryListViewController: ViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var storyListViewModel: StoryListViewModel {
        return viewModel as! StoryListViewModel
    }
    
    var listUpdateDisposable: Disposable?
    
    override class func storyboardName() -> String {
        return "StoryList"
    }
    
    override class func identifier() -> String {
        return "StoryListViewController"
    }
    
    override class func viewModelClass() -> ViewModel.Type {
        return StoryListViewModel.self
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil) { (context) in
            self.collectionView.performBatchUpdates({ 
                self.collectionView.setCollectionViewLayout(self.collectionView.collectionViewLayout, animated: true)
            }, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        listUpdateDisposable = storyListViewModel
                .list
                .subscribe(onNext: { (arrayInsertionDeletion) in
                    self.update(insertionDeletion: arrayInsertionDeletion, animated: true)
                    if let footerView = self.collectionView.visibleSupplementaryViews(ofKind: UICollectionElementKindSectionFooter).first as? StoryListFooterView {
                        footerView.finishRefreshing()
                    }
                    }, onError: { (error) in
                        print(error)
                    }, onCompleted: nil, onDisposed: nil)
    }
    
    func update(insertionDeletion: ArrayInsertionDeletion<Story>?, animated: Bool) {
        guard let insertionDeletion = insertionDeletion else {
            return
        }
        
        collectionView.performBatchUpdates({ 
            if let indexesInserted = insertionDeletion.indexesInserted {
                self.collectionView.insertItems(at: indexesInserted.indexPaths())
            }
            
            if let indexesUpdated = insertionDeletion.indexesUpdated {
                self.collectionView.insertItems(at: indexesUpdated.indexPaths())
            }

            if let indexesDeleted = insertionDeletion.indexesDeleted {
                self.collectionView.insertItems(at: indexesDeleted.indexPaths())
            }
        }, completion: nil)
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "StoryListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StoryListCollectionViewCell")
        collectionView.register(UINib(nibName: "StoryListFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "StoryListFooterView")
    }
}

extension StoryListViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let footerView = self.collectionView.visibleSupplementaryViews(ofKind: UICollectionElementKindSectionFooter).first as? StoryListFooterView else {
            return
        }
        
        footerView.scrollViewDidScroll(scrollView: scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let footerView = self.collectionView.visibleSupplementaryViews(ofKind: UICollectionElementKindSectionFooter).first as? StoryListFooterView else {
            return
        }
        
        footerView.scrollViewDidEndDragging(scrollView: scrollView)
    }
}

extension StoryListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storyListViewModel.currentArrayInsertionDeletion.backingArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryListCollectionViewCell", for: indexPath) as! StoryListCollectionViewCell
        cell.update(model: storyListViewModel.currentArrayInsertionDeletion.backingArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "StoryListFooterView", for: indexPath) as! StoryListFooterView
        footerView.delegate = self
        return footerView
    }
}

extension StoryListViewController: StoryListFooterViewDelegate {
    func didTapMore() {
        storyListViewModel.fetchNextStories()
    }
}

extension StoryListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let story = storyListViewModel.currentArrayInsertionDeletion.backingArray[indexPath.row]
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
