import Foundation

extension Array where Element: NSAttributedString {

    /// Returns the elements of the array concatenated together, inserting the separator between
    /// each element.
    ///
    /// - Parameter separator: A separator to insert between each element of the array.
    /// - Returns: The joined attributed string.
    ///
    public func joined(separator: NSAttributedString) -> NSAttributedString {
        reduce(into: NSMutableAttributedString()) { result, element in
            result.append(element)
            if let last = last, last != element {
                result.append(separator)
            }
        }
    }
}

extension Array {

    /// Returns the elements index of the array in middle
    /// 
    public var middleIndex: Int {
        let leftIdx: Int = 0
        let rightIdx: Int = self.count-1
        let midIdx: Int = leftIdx + ((rightIdx - leftIdx) >> 1)
        return midIdx
    }
}
