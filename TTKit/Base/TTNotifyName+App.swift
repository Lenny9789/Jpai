import Foundation

/// 通知名称定义
extension TTNotifyName {
    
    /// `App`层通知名称定义
    public enum App {
        
        // 登陆成功通知
        public static let loginSuccess          = NSNotification.Name("loginSuccessNotification")
        // 退出成功通知
        public static let logoutSuccess         = NSNotification.Name("logoutSuccessNotification")
        // 需要重新登陆通知
        public static let userNeedReLogin       = NSNotification.Name("userNeedReLoginNotification")
        // 域名切换成功通知
        public static let domainSwitchSuccess   = NSNotification.Name("domainSwitchSuccessNotification")
        // ws请求报错通知
        public static let webSocketRequestError = NSNotification.Name("webSocketRequestErrorNotification")
        // Tab item双击通知
        public static let tabItemDoubleClicked  = NSNotification.Name("tabItemDoubleClickedNotification")
        // 作品属性改变通知
        public static let worksAttrChanged  = NSNotification.Name("worksAttrChangedNotification")
        // CD-KEY兑换成功
        public static let CDKEYExchanged  = NSNotification.Name("CDKEYExchangedNotification")
    }
}
