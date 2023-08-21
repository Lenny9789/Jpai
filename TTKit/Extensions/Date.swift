import Foundation

extension Date {
    /// A static property used to override the current date for unit testing.
    public static var mockCurrentDate: Date?

    /// The current date and time. This can be overwritten by setting `mockCurrentDate` during testing.
    public static var now: Date {
        return mockCurrentDate ?? Date()
    }

    /// Returns a date as a string in the provided format.
    ///
    /// - Parameters:
    ///     - format: The format to convert the date to.
    ///
    /// - Returns: A date as a string in the provided format.
    ///
    public func string(format: String, locale: Locale = .current) -> String {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.setLocalizedDateFormatFromTemplate(format)
        return formatter.string(from: self)
    }

    /// Returns a date from the provided string.
    ///
    /// - Parameter utcString: The string used to create the date.
    ///
    /// - Returns: A date from the provided string.
    ///
    public static func utcDate(from utcString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "UTC")!
        return formatter.date(from: utcString)
    }
}

extension Date {
    
    /// 获取当前 秒级 时间戳 - 10位
    public var timeStamp : Int {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return timeStamp
    }

    /// 获取当前 毫秒级 时间戳 - 13位
    public var milliStamp : Int {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return Int(millisecond)
    }
}
