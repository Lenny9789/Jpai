import UIKit

extension UITapGestureRecognizer {

    /// Creates a gesture-recognizer with a target, action selector and allowed press type.
    ///
    /// - Parameters:
    ///   - target: An object that is the recipient of action messages sent by the receiver when it
    ///             recognizes a gesture.
    ///   - action: A selector that handles the gesture recognized by the receiver.
    ///   - pressType: The press types that activate the gesture.
    public convenience init(target: Any?, action: Selector?, pressType: UIPress.PressType) {
        self.init(target: target, action: action)

        allowedPressTypes = [NSNumber(value: pressType.rawValue)]
    }
}

extension Array where Element == UIGestureRecognizer {
    /// Returns a gesture recognizer matching the given press type.
    ///
    /// - Parameter pressType: The press types that activate the gesture.
    /// - Returns: A gesture recognizer activated by press type or `nil`.
    public func recognizer(for pressType: UIPress.PressType) -> UIGestureRecognizer? {
        return first {
            $0.allowedPressTypes.contains(.init(value: pressType.rawValue))
        }
    }
}
