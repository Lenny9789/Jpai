import UIKit
#if canImport(SwiftTheme)
import SwiftTheme
#endif


//UI设计图基准（iPhone6）
public let kDesignResolutionWidth: CGFloat = 375.0
public let kDesignResolutionHeight: CGFloat = 812.0


//==================================================================================================
// 设备相关

/// 系统版本
public let kSysVersion = UIDevice.current.systemVersion

/// 判断系统版本号
public func kIsIosVersion(version: Float) -> Bool {
    return UIDevice.current.systemVersion.toFloat() >= version
}

/// 是否手机
public let kIsIPhone = UIDevice.current.userInterfaceIdiom == .phone

/// 是否刘海屏（利用safeAreaInsets.bottom > 0 来判断是否是iPhoneX系列）
public func kIsIPhoneX() -> Bool {
    guard let window = UIApplication.shared.delegate?.window else {
        return false
    }
    guard #available(iOS 11.0, *) else {
        return false
    }
    return window!.safeAreaInsets.bottom > 0.0
}

/// 是否iPad
public let kIsIPad = UIDevice.current.userInterfaceIdiom == .pad

/// 是否视网膜屏幕
public func kIsRetina() -> Bool {
    let screenScale: CGFloat = UIScreen.main.responds(to: #selector(getter: UIScreen.main.scale)) ? UIScreen.main.scale : 1.0
    return screenScale >= 2.0 || screenScale >= 3.0
}


//==================================================================================================
// 视图相关

/// 屏幕bounds
public var kScreenBounds = UIScreen.main.bounds

/// 屏幕size
public var kScreenSize = UIScreen.main.bounds.size

/// 屏幕宽
//public var kScreenWidth = UIScreen.main.bounds.size.width

/// 屏幕高
//public var kScreenHeight = UIScreen.main.bounds.size.height

/// 状态栏高
//public let kStatusBarHeight = UIApplication.shared.statusBarFrame.size.height

/// 导航栏高
public let kNavBarHeight = CGFloat(44.0)

/// 状态栏+导航栏的高度
public let kStatusAndNavBarHeight = (kStatusBarHeight + kNavBarHeight)

/// 底部菜单栏高度
public let kTabBarHeight = kIsIPhoneX() ? CGFloat(83.0) : CGFloat(49.0)

/// 通用工具栏高度
public let kToolbarHeight = CGFloat(49.0)

/// 键盘工具栏高度
public let kKeyboardBarHeight = CGFloat(44.0)

/// keyWindow
public func kKeyWindow() -> UIWindow? {
    return UIApplication.shared.windows.first { $0.isKeyWindow }
}

/// 顶部安全区域高
public func kSafeAreaTopHeight() -> CGFloat {
    if #available(iOS 11.0, *) { //47
        if let height = UIApplication.shared.keyWindow?.safeAreaInsets.top {
            return height
        }
    }
    return 20.0;
}

/// 底部安全区域高
//public func kSafeAreaBottomHeight() -> CGFloat {
//    if #available(iOS 11.0, *) { //34
//        if let height = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
//            return height
//        }
//    }
//    return 0.0;
//}

/// 左侧安全区域高
public func kSafeAreaLeftWidth() -> CGFloat {
    if #available(iOS 11.0, *) { //landscapeRight：47
        if let height = UIApplication.shared.keyWindow?.safeAreaInsets.left {
            return height
        }
    }
    return 20.0;
}

/// 键盘高
public let kKeyboardHeight = CGFloat(252.0)

/// 键盘最小高度
public let kKeyboardMinHeight = CGFloat(216.0)

/// 不同屏幕相对于设计图适配宽度比例
public let kScreenWidthRatio = UIScreen.main.bounds.size.width / kDesignResolutionWidth

/// 不同屏幕相对于设计图适配高度比例
public let kScreenHeightRatio = UIScreen.main.bounds.size.height / kDesignResolutionHeight

/// 返回自适应的宽度大小
public func kScaleWidth(size: CGFloat) -> CGFloat {
    return size * kScreenWidthRatio;
}

/// 返回自适应的高度大小
public func kScaleHeight(size: CGFloat) -> CGFloat {
    return size * kScreenHeightRatio;
}

/// 返回自适应的字体大小
public func kScaleFontSize(size: CGFloat) -> CGFloat {
    return size * kScreenWidthRatio;
}


//==================================================================================================
// 应用相关

///  应用名称
public func kAppDisplayName() -> String {
    let infoDictionary = Bundle.main.localizedInfoDictionary ?? Bundle.main.infoDictionary
    guard let infoDictionary = infoDictionary else { return ""}
    if let appDisplayName = infoDictionary["CFBundleDisplayName"] as? String {
        return appDisplayName
    }
    return ""
}

///  工程名字
public func kProjectName() -> String {
    guard let infoDictionary = Bundle.main.infoDictionary else { return ""}
    if let projectName = infoDictionary["CFBundleName"] as? String {
        return projectName
    }
    return ""
}

///  APP版本号
public func kAppVersion() -> String {
    guard let infoDictionary = Bundle.main.infoDictionary else { return ""}
    if let appVersion = infoDictionary["CFBundleShortVersionString"] as? String {
        return appVersion
    }
    return ""
}

///  build版本号
public func kBuildVersion() -> String {
    guard let infoDictionary = Bundle.main.infoDictionary else { return ""}
    if let buildVersion = infoDictionary["CFBundleVersion"] as? String {
        return buildVersion
    }
    return ""
}

///  返回文件的Documents目录路径
public func kDocumentPath(path: String) -> String {
    var dirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
    dirPath = dirPath.appendingPathComponent(path) as NSString
    return dirPath as String
}

///  返回文件的缓存目录路径
public func kCachePath(path: String) -> String {
    var dirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
    dirPath = dirPath.appendingPathComponent(path) as NSString
    return dirPath as String
}

///  返回文件的临时目录路径
public func kTempPath(path: String) -> String {
    var dirPath = NSTemporaryDirectory() as NSString
    dirPath = dirPath.appendingPathComponent(path) as NSString
    return dirPath as String
}

///  加载mainBundle里面的图片
public func kLoadImage(resource: String, ofType: String) -> UIImage? {
    guard let path = Bundle.main.path(forResource: resource, ofType: ofType) else { return nil}
    return UIImage(contentsOfFile: path)
}

///  加载mainBundle里面的png图片
public func kLoadPng(resource: String) -> UIImage? {
    return kLoadImage(resource: resource, ofType: "png")
}

/// APPIcon  logo
public func kAPPIcon() -> UIImage? {
    let infoDict = Bundle.main.infoDictionary
    if let icons = infoDict?["CFBundleIcons"] as? [String: Any],
       let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
       let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
       let lastIcon = iconFiles.last {
        return UIImage(named: lastIcon)
    }
    return nil
}

public typealias TTVoidBlock = () -> Void


public enum TTColor {
    case color(_ color: UIColor)
    #if canImport(SwiftTheme)
    case themeColor(_ themeColor: ThemeColorPicker)
    #endif
}

public enum TTCGColor {
    case cgColor(_ cgColor: CGColor)
    #if canImport(SwiftTheme)
    case themeCGColor(_ themeCGColor: ThemeCGColorPicker)
    #endif
}

public enum TTIndicatorStyle {
    case style(_ style: UIActivityIndicatorView.Style)
    #if canImport(SwiftTheme)
    case themeStyle(_ themeStyle: ThemeActivityIndicatorViewStylePicker)
    #endif
}


///  UserDefaults实例
public let kUserDefaults = UserDefaults.standard


/// 保存key-value到UserDefaults
public func kSaveObjectToUserDefaults(key: String, value: Any?) {
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
}

/// 根据key获取UserDefaults对应的值
public func kGetObjectFromUserDefaults(key: String) -> Any? {
    UserDefaults.standard.object(forKey: key)
}


/// 判断是否第一次启动App
public func kAppIsFristLaunch() -> Bool {
    UserDefaults.standard.bool(forKey: "appLaunched")
}

/// 标记已启动过App
public func kSetAppLaunched() {
    UserDefaults.standard.set(true, forKey: "appLaunched")
    UserDefaults.standard.synchronize()
}

/// 判断是否第一次登录App
public func kAppIsNotFristLogin() -> Bool {
    UserDefaults.standard.bool(forKey: "appLogined")
}

/// 标记已登录过App
public func kSetAppLogined() {
    UserDefaults.standard.set(true, forKey: "appLogined")
    UserDefaults.standard.synchronize()
}

/// 判断是否已显示隐私弹框
public func kAppIsShowPrivacy() -> Bool {
    UserDefaults.standard.bool(forKey: "isShowPrivacy")
}

/// 标记已显示隐私弹框
public func kSetShowPrivacy() {
    UserDefaults.standard.set(true, forKey: "isShowPrivacy")
    UserDefaults.standard.synchronize()
}


/// 获取单行文本size
public func kSingleLineTextSize(text: String, font: UIFont) -> CGSize {
    if text.count > 0 {
        let size = NSString(string: text).size(withAttributes: [NSAttributedString.Key.font: font])
        return size
    } else {
        return CGSize.zero
    }
}

/// 获取多行文本size
public func kMultilineTextSize(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
    if text.count > 0 {
        let size = NSString(string: text).boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).size
        return size
    } else {
        return CGSize.zero
    }
}


/// 计算类似CollectionView Item的宽
public func kAdaptedItemWidth(viewWidth: Float, insetLeft: Float, insetRight: Float, itemSpace: Float, itemCount: Int) -> Float {
    let contentWidth = viewWidth - insetLeft - insetRight - itemSpace * Float(itemCount-1)
    let remainder = contentWidth.truncatingRemainder(dividingBy: Float(itemCount)) //取余
    let itemWidth = (contentWidth - remainder) / Float(itemCount) - 1.0
    return itemWidth
}

/// 计算类似CollectionView Item的自适应高
public func kAdaptedItemHeight(itemWidth: Float, referWidth: Float, referHeight: Float) -> Float {
    let itemHeight = (itemWidth * referHeight) / referWidth
    return itemHeight
}


/// 取四舍五入整数值
public func kRoundingValue(value: Float) -> Int {
    return Int(value * 10 + 5) / 10
}


/// 调试方法打印输出
public func debugPrint<T>(_ message: T, filePath: String = #file, function:String = #function, rowCount: Int = #line) {
#if DEBUG
    let fileName = (filePath as NSString).lastPathComponent
    print("<" + fileName + ":" + "\(rowCount)" + "> " + "\(function)" + ": \(message)")
#endif
}

/// 精简调试方法打印输出
public func debugPrintS<T>(_ message: T) {
#if DEBUG
    print(message)
#endif
}

/// 主线程中执行任务
public func mainQueueExecuting(_ closure: @escaping () -> Void) {
    if Thread.isMainThread {
        closure()
    } else {
        DispatchQueue.main.async {
            closure()
        }
    }
}

/// 后台线程中执行任务
public func backgroundQueueExecuting(_ closure: @escaping () -> Void) {
    if Thread.isMainThread {
        DispatchQueue.global(qos: .default).async {
            closure()
        }
    } else {
        closure()
    }
}

/// 主队列同步执行任务
public func mainQueueSync<T>(task: () throws -> T) rethrows -> T {
    if Thread.isMainThread {
        return try task()
    } else {
        return try DispatchQueue.main.sync {
            try task()
        }
    }
}

/// 延迟执行
public func delayExecuting(_ seconds: Double, inMain: Bool = true, closure: @escaping () -> Void) {
    let dispatchAfter = DispatchTimeInterval.milliseconds(Int(seconds*1000))
    if inMain {
        DispatchQueue.main.asyncAfter(deadline: .now() + dispatchAfter) {
            closure()
        }
    } else {
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + dispatchAfter) {
            closure()
        }
    }
}


/// 同步Protocol
public protocol InternalSynchronizing {
    
    var mutex: NSLock { get }
}

/// 同步实现
extension InternalSynchronizing {
    
    public func sync<T>(_ closure: @autoclosure () throws -> T) rethrows -> T {
        return try self.sync(closure: closure)
    }
    
    public func sync<T>(closure: () throws -> T) rethrows -> T {
        self.mutex.lock()
        defer {
            self.mutex.unlock()
        }
        return try closure()
    }
}


/// 文件载体类型
public enum FilePayload {
    // data
    case data(_ data: Data)
    // url
    case url(_ url: URL)
}
