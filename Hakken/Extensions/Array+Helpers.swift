//
//  Array+Helpers.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 12/25/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import Foundation

extension Array where Element: TrackableItem {
    mutating func remove(indexes: IndexSet) {
        indexes.forEach { (element) in
            remove(at: element)
        }
    }
    
    mutating func remove(item: Element) -> IndexSet? {
        let indexOfItem = index { (element) -> Bool in
            return element.id == item.id
        }
        guard let index = indexOfItem else {
            return nil
        }
        remove(at: index)
        return IndexSet(integer: index)
    }
    
    mutating func update(item: Element) -> IndexSet? {
        let indexOfItem = index { (element) -> Bool in
            return element.id == item.id
        }
        guard let index = indexOfItem else {
            return nil
        }
        self[index] = item
        return IndexSet(integer: index)
    }
    
    mutating func update(items: [Element]) -> IndexSet? {
        var indexes: IndexSet = IndexSet()
        var didUpdateAllItems = true
        items.forEach { (item) in
            guard let removedIndexSet = self.update(item: item) else {
                didUpdateAllItems = false
                return
            }
            removedIndexSet.forEach({ (removedIdx) in
                indexes.insert(removedIdx)
            })
        }
        
        if didUpdateAllItems {
            return indexes
        }
        else {
            return nil
        }
    }
    
    mutating func remove(items: [Element]) -> IndexSet? {
        var indexes: IndexSet = IndexSet()
        var didRemoveAllItems = true
        items.forEach { (item) in
            guard let removedIndexSet = self.remove(item: item) else {
                didRemoveAllItems = false
                return
            }
            removedIndexSet.forEach({ (removedIdx) in
                indexes.insert(removedIdx)
            })
        }
        
        if didRemoveAllItems {
            return indexes
        }
        else {
            return nil
        }
    }
}
