import Foundation

/// 获取关联对象属性
public func tt_associatedObject<ValueType: AnyObject>(
        base: AnyObject,
        key: UnsafePointer<UInt8>,
        initialiser: () -> ValueType)
        -> ValueType {
    if let associated = objc_getAssociatedObject(base, key) as? ValueType {
        return associated
    }
    let associated = initialiser()
    objc_setAssociatedObject(base, key, associated, .OBJC_ASSOCIATION_RETAIN)
    return associated
}

/// 设置关联对象属性
public func tt_associateObject<ValueType: AnyObject>(
        base: AnyObject,
        key: UnsafePointer<UInt8>,
        value: ValueType) {
    objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
}
