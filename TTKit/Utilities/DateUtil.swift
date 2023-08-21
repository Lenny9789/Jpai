import Foundation

/// 时间格式
public enum DateFormat: String
{
    case format_default            = "yyyy-MM-dd HH:mm:ss"
    case format_yyMdHm             = "yy-MM-dd HH:mm"
    case format_yyyyMdHm           = "yyyy-MM-dd HH:mm"
    case format_yMd                = "yyyy-MM-dd"
    case format_MdHms              = "MM-dd HH:mm:ss"
    case format_MdHm               = "MM-dd HH:mm"
    case format_Hms                = "HH:mm:ss"
    case format_Hm                 = "HH:mm"
    case format_Md                 = "MM-dd"
    case format_yyMd               = "yy-MM-dd"
    case format_YYMMdd             = "yyyyMMdd"
    case format_yyyyMdHms          = "yyyyMMddHHmmss"
    case format_yyyyMdHmsS         = "yyyy-MM-dd HH:mm:ss.SSS"
    case format_yyyyMMddHHmmssSSS  = "yyyyMMddHHmmssSSS"
    case format_yMdHmsWithSlash    = "yyyy/MM/dd HH:mm:ss"
    case format_yMdWithSlash       = "yyyy/MM/dd"
    case format_yM                 = "yyyy 年 MM 月"
    case format_yMdChangeSeparator = "yyyy.MM.dd"
    case format_HHmmss             = "HHmmss"
    case format_HyMd               = "yyyy 年 MM 月 dd 日"
    case format_HyMd2              = "yyyy年MM月dd日"
}

/// 时间戳转显示时间字符串
public func tt_timeStampToTime(timeStamp: Double, isMilliSecond: Bool = false, format: DateFormat) -> String {
    let timeInterval:TimeInterval = isMilliSecond ? timeStamp/Double(1000) : timeStamp
    let date = NSDate(timeIntervalSince1970: timeInterval)
    let formatter = DateFormatter()
    formatter.dateFormat = format.rawValue
    return formatter.string(from: date as Date)
}

/// 显示时间字符串转时间戳(秒)
public func tt_timeToTimeStamp(time: String, format: DateFormat) -> Double {
    let formatter = DateFormatter()
    formatter.dateFormat = format.rawValue
    let last = formatter.date(from: time)
    let timeStamp = last?.timeIntervalSince1970 //10位数时间戳
    return timeStamp!
}

/// 显示时间字符串转时间戳(毫秒)
public func tt_timeConversionTimeStamp(time: String, format: DateFormat) -> Int {
    let formatter = DateFormatter()
    formatter.dateFormat = format.rawValue
    let last = formatter.date(from: time)
    let timeStamp = last!.timeIntervalSince1970*1000
    return Int(timeStamp)
}

/// NSDate转时间戳(秒)
public func tt_dateToTimeStamp(date: NSDate) -> Double {
    return date.timeIntervalSince1970
}

/// 时间戳转NSDate
public func tt_timeStampToDate(fromMillisecond timestamp: Int?) -> Date? {
    guard let timestamp = timestamp else {
        return nil
    }
    let second = TimeInterval(timestamp) / 1000.0
    return Date(timeIntervalSince1970: second)
}

/// 时间戳转【几分钟，小时，天...】
///     5分钟以下的：刚刚
///     60分钟以下的：X分钟
///     24小时以内的：X小时
///     48小时内的，算昨天
///     过了 0 点的，不足一天的也按天计算了，例如 11:59分发的，过了 0点，就算昨天
///     大于48小时的，X天
///     大于7天的：09-08 08:09
///     
public func tt_timeStampToCurrentTime(timeStamp: Double, isMilliSecond: Bool = false, format: DateFormat = .format_yMd) -> String {
    let sourceTimeInterval = isMilliSecond ? timeStamp/Double(1000) : timeStamp
    let currentTimeInterval = Date().timeIntervalSince1970
    let reduceTime: TimeInterval = currentTimeInterval - sourceTimeInterval
    
    //时间差小于5分钟
    if reduceTime < 60 * 5 {
        return .localized_just
    }
    //时间差小于60分钟
    let mins = Int(reduceTime / 60)
    if mins < 60 {
        return "\(mins)\(String.localized_minutes)"
    }
    //时间差小于24小时 判断是否过0点
    let hours = Int(reduceTime / 3600)
    if hours < 24 {
        if Calendar.current.isDateInYesterday(Date.init(timeIntervalSince1970: timeStamp)) {
            return .localized_yesterday
        }
        return "\(hours)\(String.localized_hours)"
    }
    //时间差小于48小时
    if hours < 48 {
        return .localized_yesterday
    }
    //时间差小于30天
    let days = Int(reduceTime / 3600 / 24) + 1
    if days < 7 {
        return "\(days)\(String.localized_days)"
    }
    //时间差小于12月
//    let months = Int(reduceTime / 3600 / 24 / 30)
//    if months < 12 {
//        return "\(months)\(Localizations.Kit.timeMonths)"
//    }
    //不满足上述条件,或者是未来日期,直接返回日期
    let date = NSDate(timeIntervalSince1970: sourceTimeInterval)
    let formatter = DateFormatter()
    formatter.dateFormat = DateFormat.format_MdHm.rawValue
    return formatter.string(from: date as Date)
}

// 还剩几天到期
public func tt_timeStampToCurrentTimeForDays(timeStamp: Double, isMilliSecond: Bool = false) -> String {
    let sourceTimeInterval = isMilliSecond ? timeStamp/Double(1000) : timeStamp
    let currentTimeInterval = Date().timeIntervalSince1970
    let reduceTime: TimeInterval = sourceTimeInterval - currentTimeInterval
    
    let days = Int(reduceTime / 3600 / 24)
    
    return "\(days)\(String.localized_days)"
}

/// 将媒体时长转换成【时:分:秒】显示样式
public func tt_transformMediaDuration(for dur: Int) -> String {
    switch dur {
    case 0 ..< 60:
        return String(format: "00:%02d", dur)
    case 60 ..< 3600:
        let m = dur / 60
        let s = dur % 60
        return String(format: "%02d:%02d", m, s)
    case 3600... :
        let h = dur / 3600
        let m = (dur % 3600) / 60
        let s = dur % 60
        return String(format: "%02d:%02d:%02d", h, m, s)
    default:
        return ""
    }
}

/// 将日期时长转换成【xxx年xxx月xxx天xxx小时xxx分钟xxx秒】显示样式
public func tt_transformDateDuration(for dur: Int, isLocalized: Bool = true) -> String {
    let oneMinute = 60
    let oneHour = oneMinute*60
    let oneDay = oneHour*24
    let oneMonth = oneDay*30
    let oneYear = oneMonth*12

    let strSeconds = isLocalized ? String.localized_seconds: "秒"
    let strMinutes = isLocalized ? String.localized_minutes: "分钟"
    let strHours = isLocalized ? String.localized_hours: "小时"
    let strDays = isLocalized ? String.localized_days: "天"
    let strMonths = isLocalized ? String.localized_months: "月"
    let strYears = isLocalized ? String.localized_years: "年"

    switch dur {
    case 0 ..< oneMinute:
        return "\(dur)\(strSeconds)"
    case oneMinute ..< oneHour:
        let m = dur / oneMinute
        let s = dur % oneMinute
        return "\(m)\(strMinutes)\(s)\(strSeconds)"
    case oneHour ..< oneDay:
        let h = dur / oneHour
        let m = (dur % oneHour) / oneMinute
        let s = (dur % oneHour) % oneMinute
        return "\(h)\(strHours)\(m)\(strMinutes)\(s)\(strSeconds)"
    case oneDay ..< oneMonth:
        let d = dur / oneDay
        let h = (dur % oneDay) / oneHour
        return "\(d)\(strDays)\(h)\(strHours)"
    case oneMonth ..< oneYear:
        let m = dur / oneMonth
        let d = (dur % oneMonth) / oneDay
        return "\(m)\(strMonths)\(d)\(strDays)"
    case oneYear... :
        let y = dur / oneYear
        let m = (dur % oneYear) / oneMonth
        return "\(y)\(strYears)\(m)\(strMonths)"
    default:
        return ""
    }
}

/// 判断该出生日期是多少岁
public func tt_age(withBirthday date: Date) -> Int {
    let currentDate = Date()
    let calendar = Calendar.current
    
    // 获取年月日
    let birthComp = calendar.dateComponents([.year, .month, .day], from: date)
    let birthYear = birthComp.year ?? 0
    let birthMonth = birthComp.month ?? 0
    let birthDay = birthComp.day ?? 0
    
    // 非法日期
    guard birthYear > 0, birthMonth > 0, birthDay > 0 else {
        return 0
    }
    
    let currentComp = calendar.dateComponents([.year, .month, .day], from: currentDate)
    let currentYear = currentComp.year ?? 0
    let currentMonth = currentComp.month ?? 0
    let currentDay = currentComp.day ?? 0
    
    // 计算
    var age = currentYear - birthYear
    if currentMonth < birthMonth || (currentMonth == birthMonth && currentDay < birthDay) {
        age -= 1
    }
    
    // age必须比0大
    if age < 0 {
        return 0
    }
    
    return age
}
