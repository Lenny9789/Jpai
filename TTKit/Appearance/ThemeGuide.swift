import SwiftTheme

private let kLastThemeIndexKey = "lastThemeIndexKey"
private let kFollowDeviceKey = "followDeviceKey"

/// 主题指南定义
public enum ThemeGuide {}

/// 主题样式
public enum ThemeStyle: Int {
    /// 浅色（白天）
    case day = 0
    
    /// 深色（夜晚）
    case night = 1
    
    // MARK: -
    
    public static var current: ThemeStyle { return ThemeStyle(rawValue: ThemeManager.currentThemeIndex)! }
    
    /// 是否跟随系统
    public static var followDevice: Bool {
        set {
            kSaveObjectToUserDefaults(key: kFollowDeviceKey, value: newValue)
        }
        get {
            return kUserDefaults.bool(forKey: kFollowDeviceKey)
        }
    }
    
    // MARK: - Switch Theme
    
    public static func switchTo(theme: ThemeStyle) {
        ThemeManager.setTheme(index: theme.rawValue)
        saveLastTheme()
    }
    
    // MARK: - Switch Night
    
    public static func switchNight(isToNight: Bool) {
        if isToNight {
            switchTo(theme: .night)
        } else {
            switchTo(theme: .day)
        }
    }
    
    public static func isNight() -> Bool {
        return current == .night
    }
        
    // MARK: - Save & Restore
    
    public static func restoreLastTheme() {
        if (kUserDefaults.value(forKey: kLastThemeIndexKey) == nil) { //如果第一次启动，之前未保存模式信息
            switchTo(theme: .night) //默认显示切换到 深色
        } else {
            switchTo(theme: ThemeStyle(rawValue: kUserDefaults.integer(forKey: kLastThemeIndexKey))!)
        }
    }
    
    public static func saveLastTheme() {
        kSaveObjectToUserDefaults(key: kLastThemeIndexKey, value: ThemeManager.currentThemeIndex)
    }
}
