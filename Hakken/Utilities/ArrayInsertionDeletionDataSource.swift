//
//  ArrayInsertionDeletionDataSource.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 1/2/17.
//  Copyright © 2017 dotdotdot. All rights reserved.
//

import Foundation
import RxCocoa

class _ArrayInsertionDeletionDataSource : NSObject, UICollectionViewDataSource {
    func _rx_numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 0
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return _rx_numberOfSectionsInCollectionView(collectionView: collectionView)
    }
    
    func _rx_collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _rx_collectionView(collectionView: collectionView, numberOfItemsInSection: section)
    }
    
    func _rx_collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        return (nil as UICollectionViewCell?)!
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return _rx_collectionView(collectionView: collectionView, cellForItemAtIndexPath: indexPath)
    }
    
    func _rx_collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: IndexPath) -> UICollectionReusableView {
        return (nil as UICollectionReusableView?)!
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return _rx_collectionView(collectionView: collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
    }
    
    func _rx_collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return _rx_collectionView(collectionView: collectionView, canMoveItemAtIndexPath: indexPath)
    }
    
    func _rx_collectionView(collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        _rx_collectionView(collectionView: collectionView, moveItemAt: sourceIndexPath, to: destinationIndexPath)
    }
    
}

class ArrayInsertionDeletionDataSource<S: TrackableItem>
    : _ArrayInsertionDeletionDataSource
, SectionedViewDataSourceType {
    public typealias CellFactory = (ArrayInsertionDeletionDataSource<S>, UICollectionView, IndexPath, S) -> UICollectionViewCell
    public typealias SupplementaryViewFactory = (ArrayInsertionDeletionDataSource<S>, UICollectionView, String, IndexPath) -> UICollectionReusableView
    
    #if DEBUG
    // If data source has already been bound, then mutating it
    // afterwards isn't something desired.
    // This simulates immutability after binding
    var _dataSourceBound: Bool = false
    
    private func ensureNotMutatedAfterBinding() {
        assert(!_dataSourceBound, "Data source is already bound. Please write this line before binding call (`bindTo`, `drive`). Data source must first be completely configured, and then bound after that, otherwise there could be runtime bugs, glitches, or partial malfunctions.")
    }
    
    #endif
    
    private var _arrayInsertionDeletion: ArrayInsertionDeletion<S> = ArrayInsertionDeletion<S>()
    
    public func itemAtIndexPath(indexPath: IndexPath) -> S {
        return self._arrayInsertionDeletion.backingArray[indexPath.row]
    }
    
    func model(at indexPath: IndexPath) throws -> Any {
        return itemAtIndexPath(indexPath: indexPath)
    }
    
    public func setArrayInsertionDeletion(arrayInsertionDeletion: ArrayInsertionDeletion<S>) {
        self._arrayInsertionDeletion = arrayInsertionDeletion
    }
    
    public var configureCell: CellFactory! = nil {
        didSet {
            #if DEBUG
                ensureNotMutatedAfterBinding()
            #endif
        }
    }
    
    @available(*, deprecated: 0.8.1, renamed: "configureCell")
    public var cellFactory: CellFactory! {
        get {
            return self.configureCell
        }
        set {
            self.configureCell = newValue
        }
    }
    
    public var supplementaryViewFactory: SupplementaryViewFactory {
        didSet {
            #if DEBUG
                ensureNotMutatedAfterBinding()
            #endif
        }
    }
    
    public var moveItem: ((ArrayInsertionDeletionDataSource<S>, _ sourceIndexPath:IndexPath, _ destinationIndexPath:IndexPath) -> Void)? {
        didSet {
            #if DEBUG
                ensureNotMutatedAfterBinding()
            #endif
        }
    }
    public var canMoveItemAtIndexPath: ((ArrayInsertionDeletionDataSource<S>, _ indexPath:IndexPath) -> Bool)? {
        didSet {
            #if DEBUG
                ensureNotMutatedAfterBinding()
            #endif
        }
    }
    
    public override init() {
        self.configureCell = {_, _, _, _ in return (nil as UICollectionViewCell?)! }
        self.supplementaryViewFactory = {_, _, _, _ in (nil as UICollectionReusableView?)! }
        
        super.init()
        
        self.configureCell = { [weak self] _ in
            precondition(false, "There is a minor problem. `cellFactory` property on \(self!) was not set. Please set it manually, or use one of the `rx_bindTo` methods.")
            
            return (nil as UICollectionViewCell!)!
        }
        
        self.supplementaryViewFactory = { [weak self] _ in
            precondition(false, "There is a minor problem. `supplementaryViewFactory` property on \(self!) was not set.")
            return (nil as UICollectionReusableView?)!
        }
    }
    
    // UICollectionViewDataSource
    
    override func _rx_numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func _rx_collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self._arrayInsertionDeletion.backingArray.count
    }
    
    override func _rx_collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        precondition(indexPath.item < _arrayInsertionDeletion.backingArray.count)
        
        return configureCell(self, collectionView, indexPath, itemAtIndexPath(indexPath: indexPath))
    }
    
    override func _rx_collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: IndexPath) -> UICollectionReusableView {
        return supplementaryViewFactory(self, collectionView, kind, indexPath)
    }
    
    override func _rx_collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: IndexPath) -> Bool {
        guard let canMoveItem = canMoveItemAtIndexPath?(self, indexPath) else {
            return super._rx_collectionView(collectionView: collectionView, canMoveItemAtIndexPath: indexPath)
        }
        
        return canMoveItem
    }
    
    override func _rx_collectionView(collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    }
}
