import UIKit
import DeviceKit

/// `TTKit` 全局配置
///
public struct TTKitConfiguration {
    /// 便捷配置入口
    public static func setupConfig(_ block: @escaping () -> Void) {
        block()
    }
    
    
    // MARK: - `General`配置
    public enum General {
        /// 当前UI基于哪种设备设计
        public static var standardDevice = Device.iPhoneX
        /// 视图背景颜色
        public static var backgroundColor: TTColor = .color(.white)
        /// 是否在调试模式下显示当前所在控制器
        public static var isShowDebugController = true
        /// 本地化`strings` table name
        public static var localizableTableName = "TTKitLocalizable"
        /// App开发环境名称
        public static var appEnviName = ""
        /// 支付宝Scheme
        public static var aliPayScheme = ""
        /// 微信Scheme
        public static var weChatScheme = ""
    }
    
    // MARK: - `HTTP`配置
    public enum Networking {
        /// 请求超时间隔
        public static var timeoutIntervalForRequest: TimeInterval = 30
        /// 响应超时间隔
        public static var timeoutIntervalForResource: TimeInterval = 30
        /// 是否使用本地模拟数据
        public static var isMockData: Bool = false
        /// 模拟数据响应间隔
        public static var mockRespTimeInterval: Double = 1.0
        /// 模拟响应数据的通用本地 json 文件名
        public static var mockGeneralJsonFileName: String = "general_response"
        /// 是否打印请求log
        public static var isShowRequestLog: Bool = true
        /// 动态参数Header - timestamp
        public static var dynamicHeaderTimestamp: String = "timestamp"
        /// 动态参数Header - language
        public static var dynamicHeaderLanguage: String = "language"
    }
    
    // MARK: - `UIScrollView扩展`配置
    public enum ScrollViewExp {
        /// 菊花顶部间距
        public static var indicatorTop: CGFloat = 20
    }
    
    // MARK: - `下拉刷新`配置
    public enum PullToRefresh {
        /// 菊花颜色
        public static var indicatorStyle: TTIndicatorStyle = .style(.gray)
    }
    
    // MARK: - `Loading`配置
    public enum ProgressHUD {
        /// 弹窗背景色
        public static var containerColor: TTColor = .color(UIColor.lightGray)
        /// 弹窗圆角
        public static var containerCornerRadius: CGFloat = 10
        /// 只显示Loading时内容四周间距
        public static var indicatorEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 27, left: 27, bottom: -27, right: -27)
        /// 显示Loading和文本时内容四周间距
        public static var indicatorTextEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 16, left: 27, bottom: -10, right: -27)
        /// 文本字体
        public static var textFont: UIFont = UIFont.fontMedium(fontSize: 13)
        /// 文本颜色
        public static var textColor: TTColor = .color(.white)
        /// Loading和文本之间的间距
        public static var indicatorTextSpace: CGFloat = 10
    }
    
    // MARK: - `Toast`配置
    public enum Toast {
        /// 背景图
        public static var bgColor: TTColor = .color(.black)
        /// 文本颜色
        public static var textColor: TTColor = .color(.white)
        /// 文本字体
        public static var textFont = UIFont.fontRegular(fontSize: 16)
        /// Toast圆角
        public static var cornerRadius: CGFloat = 5
        /// Toast 是否支持多任务顺序异步执行
        public static var supportQueue: Bool = true
        
        /// 显示成功图片
        public static var successImage = UIImage(named: "TToast.bundle/ic_toast_success.png")
        /// 显示失败图片
        public static var failImage = UIImage(named: "TToast.bundle/ic_toast_fail.png")
        /// 警告图片
        public static var warnImage = UIImage(named: "TToast.bundle/ic_toast_sign.png")
    }
    
    // MARK: - `WebView`配置
    public enum WebView {
        /// webView进度条前景色
        public static var progressTint: TTColor = .color(.green)
        /// webView进度条背景色
        public static var progressTrack: TTColor = .color(.white)
    }
    
}
