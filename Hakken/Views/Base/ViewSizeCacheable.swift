//
//  ViewSizeCacheable.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 12/24/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import UIKit

protocol NibViewInstantiable: class {
    static var view: UIView { get set }
    static func nibName() -> String
}

public protocol ViewSizeCacheable: class {
    static var modelKeyToSizingInformation: [String: CGSize] { get set }
    static func size(model: AnyObject, modelKey: String) -> CGSize
    static func size(model: AnyObject, modelKey: String, useCached: Bool) -> CGSize
    static func size(model: AnyObject, modelKey: String, useCached: Bool, fittingSize: CGSize) -> CGSize
}

public protocol CellModelBindable: class {
    func update(model: AnyObject)
}

private var modelKeyToSizingInformationKey: UInt8 = 0

extension ViewSizeCacheable {
    public static var modelKeyToSizingInformation: [String: CGSize] {
        get {
            let obj = associatedObjectInitializeIfNil(object: self, key: &modelKeyToSizingInformationKey, policy: .OBJC_ASSOCIATION_RETAIN) {
                return [String: CGSize]()
            }
            return obj
        }
        set {
            associateObject(object: self, key: &modelKeyToSizingInformationKey, value: newValue, policy: .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public static func size(model: AnyObject, modelKey: String) -> CGSize {
        return size(model: model, modelKey: modelKey, useCached: true, fittingSize: UILayoutFittingCompressedSize)
    }
    
    public static func size(model: AnyObject, modelKey: String, useCached: Bool) -> CGSize {
        return size(model: model, modelKey: modelKey, useCached: useCached, fittingSize: UILayoutFittingCompressedSize)
    }
    
    public static func size(model: AnyObject, modelKey: String, useCached: Bool, fittingSize: CGSize) -> CGSize {
        // TODO: Add logging
        return CGSize.zero
    }
}