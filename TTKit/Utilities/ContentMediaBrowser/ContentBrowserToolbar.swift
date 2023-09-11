import UIKit
import ZFPlayer

fileprivate let controlHeight: CGFloat = 48
fileprivate let footerHeight: CGFloat = 49
fileprivate let btmMargin: CGFloat = 34
fileprivate let leftMargin: CGFloat = 16

/// 浏览器Toolbar
class ContentBrowserToolbar: UIView {
    
    /// 样式
    public enum Style {
        case picture
        case video
    }
    
    /// 动作事件
    public enum ActionEvent {
        case commentTapped
        case likeTapped
        case forwardTapped
        case shareTapped
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
    
    var eventBlock: ((ActionEvent)->())?
    var disposeBag = DisposeBag()

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
        backgroundColor = .init(white: 1, alpha: 0.5)

        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func viewHeight(style: Style) -> CGFloat {
        switch style {
        case .picture:
            var height: CGFloat = 0
            height += footerHeight
            height += btmMargin
            height += kSafeAreaBottomHeight()
            return height
        case .video:
            var height: CGFloat = 0
            height += controlHeight
            height += footerHeight
            height += btmMargin
            height += kSafeAreaBottomHeight()
            return height
        }
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
