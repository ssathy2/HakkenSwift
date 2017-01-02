//
//  CollectionViewCell.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 12/24/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import UIKit

private var viewKey: UInt8 = 0

public class CollectionViewCell: UICollectionViewCell, ViewSizeCacheable, CellModelBindable {
    public class func size(model: AnyObject, modelKey: String, useCached: Bool, fittingSize: CGSize) -> CGSize {
        let cachedSizeValue = modelKeyToSizingInformation[modelKey]
        if cachedSizeValue != nil && useCached {
            return cachedSizeValue!
        }
        
        let sizingCell = view as! CollectionViewCell
        sizingCell.prepareForReuse()
        sizingCell.update(model: model)
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        let size = sizingCell.systemLayoutSizeFitting(fittingSize)
        // TODO: Add logging
        modelKeyToSizingInformation[modelKey] = size
        return size;
    }
    
    public func update(model: AnyObject) { }
    
    public static var view: UIView {
        get {
            return associatedObjectInitializeIfNil(object: self, key: &viewKey, policy: .OBJC_ASSOCIATION_RETAIN, initializer: {
                return UINib(nibName: nibName(), bundle: nil)
                    .instantiate(withOwner: nil, options: nil)
                    .first as! UIView
            })
        }
        set {
            associateObject(object: self, key: &viewKey, value: newValue, policy: .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public class func nibName() -> String {
        return ""
    }
}
