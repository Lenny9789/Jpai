import UIKit

public enum TToastPosition {
    case top
    case middle
    case bottom
}

public class TToast: NSObject {
    
    private static var utils: TToastUtils?
    
    /// 显示Toast弹框提示（默认纯文本、展示在window上、2秒消失、中间位置）
    ///
    /// - Parameters:
    ///   - msg： 提示文本
    ///   - onView: 可以指定显示在指定的view上
    ///   - success=nil,展示纯文本，success=false展示错误的图片，success=true展示成功的图片
    ///   - duration: 停留时长
    ///   - position: 展示的位置
    ///
    public static func show(_ msg: String,
                            onView:UIView? = nil,
                            success: TToastUtilsImageType? = nil,
                            duration:CGFloat? = nil,
                            position: TToastPosition? = .middle) {
        DispatchQueue.main.async {
            if (utils != nil) {
                utils?.cancel()
            }
            utils = TToastUtils.init(msg: msg, onView: onView, success: success, duration: duration, position: position)
        }
    }
    
    public static func hide() {
        utils?.cancel()
    }
}
