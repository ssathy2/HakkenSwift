//
//  RxCollectionViewArrayInsertionDeletionDataSource.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 1/2/17.
//  Copyright © 2017 dotdotdot. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class RxCollectionViewArrayInsertionDeletionDataSource<S: TrackableItem>: ArrayInsertionDeletionDataSource<S>, RxCollectionViewDataSourceType {
    
    public typealias Element = ArrayInsertionDeletion<S>
    
    public override init() {
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, observedEvent: Event<Element>) {
        UIBindingObserver(UIElement: self) { dataSource, element in
            #if DEBUG
                self._dataSourceBound = true
            #endif
            dataSource.setArrayInsertionDeletion(arrayInsertionDeletion: element)
            // FIXME: Get animated insertion deletion working here!
//            if element.backingArray.count == 0 {
                collectionView.reloadData()
//            }
//            else {
//                collectionView.performBatchUpdates({
//                    if let indexesInserted = element.indexesInserted {
//                        collectionView.insertItems(at: indexesInserted.indexPaths())
//                    }
//                    
//                    if let indexesUpdated = element.indexesUpdated {
//                        collectionView.insertItems(at: indexesUpdated.indexPaths())
//                    }
//                    
//                    if let indexesDeleted = element.indexesDeleted {
//                        collectionView.insertItems(at: indexesDeleted.indexPaths())
//                    }
//                    }, completion: nil)
//            }
            }.on(observedEvent)
    }
}
