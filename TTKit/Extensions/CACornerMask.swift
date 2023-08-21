import UIKit

extension CACornerMask {
    /// All four corners of the layer.
    public static var allCorners: CACornerMask = [
        .layerMaxXMaxYCorner,
        .layerMaxXMinYCorner,
        .layerMinXMaxYCorner,
        .layerMinXMinYCorner,
    ]

    /// All corners on the left side.
    public static var leftSideCorners: CACornerMask = [
        .layerMinXMinYCorner,
        .layerMinXMaxYCorner,
    ]

    /// All corners on the right side.
    public static var rightSideCorners: CACornerMask = [
        .layerMaxXMinYCorner,
        .layerMaxXMaxYCorner,
    ]

    /// All corners on the top side.
    public static var topCorners: CACornerMask = [
        .layerMinXMinYCorner,
        .layerMaxXMinYCorner,
    ]

    /// All corners on the bottom side
    public static var bottomCorners: CACornerMask = [
        .layerMinXMaxYCorner,
        .layerMaxXMaxYCorner,
    ]
}
