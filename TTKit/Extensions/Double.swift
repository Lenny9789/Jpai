import Foundation

extension Double {

    /// Returns a string with the double value rounded to the specified number of fraction digits.
    ///
    /// - Parameter fractionDigits: The number of fraction digits to round to.
    ///
    /// - Returns: A string with the double value rounded to the specified number of fraction digits.
    ///
    public func string(fractionDigits: Int) -> String? {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self))
    }
}
