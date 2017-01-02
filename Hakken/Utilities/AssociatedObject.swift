//
//  AssociatedObject.swift
//  Hakken
//
//  Created by Siddharth Sathyam on 12/24/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

import Foundation

final class Lifted<T> {
    let value: T
    init(_ x: T) {
        value = x
    }
}

private func lift<T>(x: T) -> Lifted<T>  {
    return Lifted(x)
}

public func associateObject<T>(object: AnyObject, key: UnsafeRawPointer, value: T, policy: objc_AssociationPolicy) {
    if let v: AnyObject = value as? AnyObject {
        objc_setAssociatedObject(object, key, v,  policy)
    }
    else {
        objc_setAssociatedObject(object, key, lift(x: value),  policy)
    }
}

public func associatedObjectInitializeIfNil<T>(object: AnyObject, key: UnsafeRawPointer, policy: objc_AssociationPolicy, initializer: () -> T) -> T {
    if let value = associatedObject(object: object, key: key, policy: policy) as T? {
        return value
    }
    else {
        let value = initializer()
        associateObject(object: object, key: key, value: value, policy: policy)
        return value
    }
}

public func associatedObject<T>(object: AnyObject, key: UnsafeRawPointer, policy: objc_AssociationPolicy) -> T? {
    if let value = objc_getAssociatedObject(object, key) as? T {
        return value
    }
    else if let v = objc_getAssociatedObject(object, key) as? Lifted<T> {
        return v.value
    }
    return nil
}
