import UIKit

extension CGPoint {
    /// Initializes `CGPoint` in a circle based on the radius of the circle and
    /// the angle in degrees with an additional offset applied.
    ///
    /// - Parameters:
    ///     - angle: The angle in degrees from the offset.
    ///     - radius: The radius of the circle the points are plotted on.
    ///     - offset: The offset from the radius.
    ///
    public init(angle: CGFloat, radius: CGFloat, offset: CGPoint) {
        self = CGPoint(x: radius * cos(angle) + offset.x, y: radius * sin(angle) + offset.y)
    }
}
