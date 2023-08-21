import UIKit

open class TTAlertAction: NSObject, NSCopying {
    
    // MARK: - Declarations
    public typealias TTAlertActionHandlerBlock = (_ action: TTAlertAction) -> ()
    
    public enum TTAlertActionStyle: Int {
        case Default = 0
        case Cancel
        case Destructive
    }
    
    // MARK: - Variables
    /// 按钮标题
    public var title: String?
    /// 按钮图片
    public var image: UIImage?
    /// 按钮样式
    public var style: TTAlertActionStyle = .Default
    /// 对齐样式
    public var layoutStyle: TTReLayoutButton.LayoutStyle = .image_Text(align: .centering(space: 20))
    /// 按钮字体
    public var textFont: UIFont?
    /// 按钮颜色
    public var textColor: TTColor?
    /// 按钮禁用颜色
    public var disableTextColor: TTColor?
    /// 按钮背景色
    public var backgroundColor: TTColor?
    /// 按钮边框颜色
    public var borderColor: TTCGColor?
    /// 按钮边框宽度
    public var borderWidth: CGFloat?
    /// 按钮圆角
    public var cornerRadius: CGFloat?
    /// 按钮高度
    public var height: CGFloat = 44
    /// 是否启用状态
    public var isEnabled: Bool = true
    /// 弹框内的单选框是否被选中（关闭返回时有效）
    public var respIsRadioSelected: Bool = false
    /// 按钮点击回调
    public var handler: TTAlertActionHandlerBlock?
    
    // MARK: - Initialization Method
    public class func action(title: String?,
                             image: UIImage?,
                             style: TTAlertActionStyle,
                             layoutStyle: TTReLayoutButton.LayoutStyle,
                             textFont: UIFont?,
                             textColor: TTColor?,
                             disableTextColor: TTColor?,
                             backgroundColor: TTColor?,
                             borderColor: TTCGColor?,
                             borderWidth: CGFloat?,
                             cornerRadius: CGFloat?,
                             height: CGFloat = 44,
                             isEnabled: Bool = true,
                             handler: TTAlertActionHandlerBlock?) -> TTAlertAction  {
        
        return TTAlertAction.init(title: title,
                                  image: image,
                                  style: style,
                                  layoutStyle: layoutStyle,
                                  textFont: textFont,
                                  textColor: textColor,
                                  disableTextColor: disableTextColor,
                                  backgroundColor: backgroundColor,
                                  borderColor: borderColor,
                                  borderWidth: borderWidth,
                                  cornerRadius: cornerRadius,
                                  height: height,
                                  isEnabled: isEnabled,
                                  handler: handler)
    }
    
    public convenience init(title: String?,
                            image: UIImage?,
                            style: TTAlertActionStyle,
                            layoutStyle: TTReLayoutButton.LayoutStyle,
                            textFont: UIFont?,
                            textColor: TTColor?,
                            disableTextColor: TTColor?,
                            backgroundColor: TTColor?,
                            borderColor: TTCGColor?,
                            borderWidth: CGFloat?,
                            cornerRadius: CGFloat?,
                            height: CGFloat = 44,
                            isEnabled: Bool = true,
                            handler: TTAlertActionHandlerBlock?) {
        
        // Create New Instance Of Alert Controller
        self.init()
        
        // Set Alert Properties
        self.title = title
        self.image = image
        self.style = style
        self.layoutStyle = layoutStyle
        self.textFont = textFont
        self.textColor = textColor
        self.disableTextColor = disableTextColor
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.height = height
        self.isEnabled = isEnabled
        self.handler = handler
    }
    
    
    // MARK: - NSCopying
    public func copy(with zone: NSZone? = nil) -> Any {
        return TTAlertAction.init(title: title,
                                  image: image,
                                  style: style,
                                  layoutStyle: layoutStyle,
                                  textFont: textFont,
                                  textColor: textColor,
                                  disableTextColor: disableTextColor,
                                  backgroundColor: backgroundColor,
                                  borderColor: borderColor,
                                  borderWidth: borderWidth,
                                  cornerRadius: cornerRadius,
                                  height: height,
                                  isEnabled: isEnabled,
                                  handler: handler)
    }
    
    // MARK: - Dealloc
    deinit {
        // Remove Action Handler
        handler = nil
    }
}
