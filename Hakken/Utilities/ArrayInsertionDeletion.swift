//
//  ArrayInsertionDeletion.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 12/25/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import Foundation
import RxSwift

protocol TrackableItem {
    var id: Int { get set }
}

enum ArrayInsertionDeletionError: Error {
    case ElementNotFound
}

class ArrayInsertionDeletion<T: TrackableItem> {
    var backingArray: [T] = [T]()
    var indexesInserted: IndexSet?
    var indexesDeleted: IndexSet?
    var indexesUpdated: IndexSet?
    
    private func resetState() {
        indexesInserted = nil
        indexesUpdated = nil
        indexesDeleted = nil
    }
    
    func reset(array: [T]) -> Observable<ArrayInsertionDeletion<T>> {
        resetState()
        return Observable.create({ (observer) -> Disposable in
            let indexesRemoved = IndexSet(integersIn: 0...self.backingArray.count-1)
            let indexesAdded   = IndexSet(integersIn: 0...array.count-1)
            self.backingArray.removeAll()
            self.backingArray.append(contentsOf: array)
            self.indexesInserted = indexesAdded
            self.indexesDeleted = indexesRemoved
            
            observer.onNext(self)
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
    func remove(indexes: IndexSet) -> Observable<ArrayInsertionDeletion<T>> {
        resetState()
        return Observable.create({ (observer) -> Disposable in
            self.backingArray.remove(indexes: indexes)
            self.indexesDeleted = indexes
            
            observer.onNext(self)
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
    func remove(item: T) -> Observable<ArrayInsertionDeletion<T>> {
        resetState()
        return Observable.create({ (observer) -> Disposable in
            guard let indexesRemoved = self.backingArray.remove(item: item) else {
                observer.onError(ArrayInsertionDeletionError.ElementNotFound)
                observer.onCompleted()
                return Disposables.create()
            }
            self.indexesDeleted = indexesRemoved
            observer.onNext(self)
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
    func remove(items: [T]) -> Observable<ArrayInsertionDeletion<T>> {
        resetState()
        return Observable.create({ (observer) -> Disposable in
            guard let indexesRemoved = self.backingArray.remove(items: items) else {
                observer.onError(ArrayInsertionDeletionError.ElementNotFound)
                observer.onCompleted()
                return Disposables.create()
            }
            self.indexesDeleted = indexesRemoved
            observer.onNext(self)
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
    func update(item: T) -> Observable<ArrayInsertionDeletion<T>> {
        resetState()
        return Observable.create({ (observer) -> Disposable in
            guard let indexesRemoved = self.backingArray.update(item: item) else {
                observer.onError(ArrayInsertionDeletionError.ElementNotFound)
                observer.onCompleted()
                return Disposables.create()
            }
            self.indexesUpdated = indexesRemoved
            observer.onNext(self)
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
    func update(items: [T]) -> Observable<ArrayInsertionDeletion<T>> {
        resetState()
        return Observable.create({ (observer) -> Disposable in
            guard let indexesRemoved = self.backingArray.update(items: items) else {
                observer.onError(ArrayInsertionDeletionError.ElementNotFound)
                observer.onCompleted()
                return Disposables.create()
            }
            self.indexesUpdated = indexesRemoved
            observer.onNext(self)
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
    func add(item: T) -> Observable<ArrayInsertionDeletion<T>> {
        resetState()
        return Observable.create({ (observer) -> Disposable in
            let indexesAdded   = IndexSet(integer: self.backingArray.count)
            self.backingArray.append(item)
            self.indexesInserted = indexesAdded
            observer.onNext(self)
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
    func add(items: [T]) -> Observable<ArrayInsertionDeletion<T>> {
        resetState()
        return Observable.create({ (observer) -> Disposable in
            var start = 0
            if self.backingArray.count > 0 {
                start = self.backingArray.count - 1
            }
            let indexesAdded   = IndexSet(integersIn: start...(self.backingArray.count-1)+(items.count-1))
            self.backingArray.append(contentsOf: items)
            self.indexesInserted = indexesAdded
            observer.onNext(self)
            observer.onCompleted()
            return Disposables.create()
        })
    }

}
