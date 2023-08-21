import UIKit

public class TTDebuger {
    public static let shared = TTDebuger()

    public var customNote = "CurrentContrller"
    
    public var noticeLabel: UILabel {
        if _noteLabel == nil {
            _noteLabel = UILabel(
                text: "",
                font: UIFont.fontRegular(fontSize: 14),
                color: .color(UIColor(hex: "#35CD49")),
                lines: 1
            )
            if kIsIPhoneX() {
                _noteLabel!.origin = CGPoint(x: 0, y: 35)
            } else {
                _noteLabel!.origin = CGPoint(x: 0, y: 16)
            }
            _noteLabel!.size = CGSize(width: kScreenWidth, height: 20)
            _noteLabel!.backgroundColor = UIColor(hex: "#000000", alpha: 0.5)
        }
        if _noteLabel!.superview == nil {
            kKeyWindow()?.addSubview(_noteLabel!)
        }
        return _noteLabel!
    }
    
    fileprivate var _noteLabel: UILabel?
}
