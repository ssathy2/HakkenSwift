//
//  IndexSet+Extensions.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 12/25/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import Foundation

extension IndexSet {
    func indexPaths() -> [IndexPath] {
        var indexPaths = [IndexPath]()
        forEach { (element) in
            indexPaths.append(IndexPath(row: element, section: 0))
        }
        return indexPaths
    }
}
