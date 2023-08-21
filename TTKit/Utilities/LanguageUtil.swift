import Foundation

/// 获取当前系统的语言
/// 读取本机设置的语言列表，获取第一个语言，该方法读取的语言为：国际通用语言Code+国际通用国家地区代码，所以实际上想获取语言还需将国家地区代码剔除
public func getPreferredLanguage() -> String {
    let languageList = kGetObjectFromUserDefaults(key: "AppleLanguages") as? [String] ?? [] //本机设置的语言列表
    //debugPrint("languageList: \(languageList)")
    guard var languageCode = languageList.first else { return "" } //当前设置的首选语言
    if let regionCode = NSLocale.current.regionCode {
        languageCode = languageCode.replacingOccurrences(of: "-\(regionCode)", with: "")
    }
    //debugPrint("languageCode: \(languageCode)")
    return languageCode
}
