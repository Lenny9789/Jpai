import Foundation

/// `Notification name` defines
public enum TTNotifyName {

    /// `TTKit`层通知名称定义
    public enum Kit {
        
        // API请求报错
        public static let apiRequestError         = NSNotification.Name("apiRequestErrorNotification")
        // 图片请求报错
        public static let imageRequestError       = NSNotification.Name("imageRequestErrorNotification")
        // 网络状态变化通知
        public static let networkStatus           = NSNotification.Name("networkStatusNotification")
    }
}
