import UIKit

public class TToastManager {
    public static let shared = TToastManager()
    
    /// 便捷配置函数
    open func setupCustom(_ block: @escaping (TToastManager) -> Void) {
        block(self)
    }
    
    /// 背景图
    public var bgColor: TTColor = TTKitConfiguration.Toast.bgColor
    /// 文本颜色
    public var textColor: TTColor = TTKitConfiguration.Toast.textColor
    /// 文本字体
    public var textFont = TTKitConfiguration.Toast.textFont
    /// Toast圆角
    public var cornerRadius: CGFloat = TTKitConfiguration.Toast.cornerRadius
    /// TToast 默认是支持多任务顺序异步执行的，如果连续调用多次show, toast会依次执行。通过以下属性可控制该功能
    public var supportQueue: Bool = TTKitConfiguration.Toast.supportQueue
    
    /// 显示成功图片
    public var successImage = TTKitConfiguration.Toast.successImage
    /// 显示失败图片
    public var failImage = TTKitConfiguration.Toast.failImage
    /// 警告图片
    public var warnImage = TTKitConfiguration.Toast.warnImage
    
    
    private let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    public func tt_resetDefaultProps() {
        self.common()
    }
    
    @available(*, deprecated, message: "Use 'tt_reset' instead.")
    public func reset() {
        self.common()
    }
    
    func common() {
        self.bgColor = .color(.black)
        self.textColor = .color(.white)
        self.textFont = UIFont.fontRegular(fontSize: 16)
        self.cornerRadius = 5
        self.successImage = UIImage(named: "TToast.bundle/ic_toast_success.png")
        self.failImage = UIImage(named: "TToast.bundle/ic_toast_fail.png")
        self.warnImage = UIImage(named: "TToast.bundle/ic_toast_sign.png")
        
        self.supportQueue = true
    }
    
    func add(_ toast: TToastUtils) {
        self.queue.addOperation(toast)
    }
    
    public func cancelAll() {
        self.queue.cancelAllOperations()
    }
}
