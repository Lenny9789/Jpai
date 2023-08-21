import UIKit

public protocol TTMonitorDelTextFieldDelegate: AnyObject {
    /// 删除按钮点击事件
    func ttTextFieldDeleteBackward(textField: TTMonitorDelTextField)
}

/// 实现在UITextField内容为空时，也可以监听到删除按钮事件
///
open class TTMonitorDelTextField: UITextField {
    public weak var tt_delegate: TTMonitorDelTextFieldDelegate?
    
    open override func deleteBackward() {
        super.deleteBackward()
        
        if self.tt_delegate != nil {
            self.tt_delegate!.ttTextFieldDeleteBackward(textField: self)
        }
    }
}
