import UIKit
import ZFPlayer

fileprivate let controlHeight: CGFloat = 48
fileprivate let btmMargin: CGFloat = 34
fileprivate let leftMargin: CGFloat = 16

/// 浏览器Toolbar
class TMediaBrowserToolbar: UIView {
    
    /// 样式
    public enum Style {
        case picture
        case video
    }
    
    var style: Style = .picture {
        didSet {
            switch style {
            case .picture:
                removeToolViewFromSelf()
            case .video:
                addToolViewToSelf()
            }
        }
    }
    
    // 播放器工具栏（外部引用）
    weak var toolView: PlayerToolView?
    
    // `toolView`是否加入了当前视图
    var isToolViewAddedTo: Bool {
        var exist = false
        for (_, subview) in self.allSubviews().enumerated() {
            if subview.tag == PlayerToolView.viewTag {
                exist = true
                break
            }
        }
        return exist
    }
    
    deinit {
        debugPrint("deinit - \(self.classForCoder)")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .init(white: 0, alpha: 0.5)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if self.isToolViewAddedTo {
            toolView?.frame = CGRect(x: leftMargin, y: self.bounds.size.height-kSafeAreaBottomHeight()-btmMargin-controlHeight, width: self.bounds.size.width-leftMargin*2, height: controlHeight)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func viewHeight() -> CGFloat {
        var height: CGFloat = 0
        height += controlHeight
        height += btmMargin
        height += kSafeAreaBottomHeight()
        return height
    }
    
    public func addToolViewToSelf() {
        if !self.isToolViewAddedTo {
            if let toolView = self.toolView {
                self.addSubview(toolView)
                
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        }
    }
    
    public func removeToolViewFromSelf() {
        if self.isToolViewAddedTo {
            toolView?.removeFromSuperview()
        }
    }
}
