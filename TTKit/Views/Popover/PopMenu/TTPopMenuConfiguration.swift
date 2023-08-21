import UIKit

/// 弹出菜单配置
public class TTPopMenuConfiguration: NSObject {

    // MARK: - 基本样式
    /// 宽度
    public var menuWidth: CGFloat = 120.0
    /// 行高
    public var menuRowHeight: CGFloat = 40.0
    /// 圆角
    public var cornerRadius: CGFloat = 4.0
    /// 弹框距屏幕四周的间距
    public var menuMargin: CGFloat = 4.0
    /// Arrow宽
    public var menuArrowWidth: CGFloat = 8.0
    /// Arrow高
    public var menuArrowHeight: CGFloat = 10.0
    /// 是否显示三角
    public var menuArrowShow = true
    
    /// 背景色
    public var backgroundTintColor: TTCGColor = .cgColor(UIColor(hex: "#505050").cgColor)
    /// 边线颜色
    public var borderColor: TTCGColor = .cgColor(UIColor(hex: "#505050").cgColor)
    /// 边线宽度
    public var borderWidth: CGFloat = 0.5
    /// 分割线颜色
    public var menuSeparatorColor: TTColor = .color(UIColor.lightGray)
    /// 分割线间距
    public var menuSeparatorInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
    
    /// 动画时间
    public var animationDuration: TimeInterval = 0.2
    
    
    // MARK: - 弹框背景/阴影
    //V1: 使用弹框预定的设置
    /// 是否显示弹框背景色
    public var globalShadow = false
    /// 弹框背景色alpha
    public var shadowAlpha: CGFloat = 0.5
    /// 是否显示弹框周围阴影
    public var localShadow = false
    //V2: 使用者自定义设置（优先级比V1高）
    /// 弹框背景色自定义适配器
    public var globalShadowAdapter: ((_ backgroundView: UIView) -> Void)?
    /// 弹框周围阴影自定义适配器
    public var localShadowAdapter: ((_ backgroundLayer: CAShapeLayer) -> Void)?
    
    
    // MARK: - Cell配置
    /// 内容子视图排列方式
    public var contentDistribution = TTMenuItemDistribution.leading
    /// Cell间距
    public var cellMargin: CGFloat = 6.0
    /// Icon、文字之间的间隔
    public var iconTextSpace: CGFloat = 10
    /// cell点击样式
    public var cellSelectionStyle = UITableViewCell.SelectionStyle.none
    
    /// Icon大小
    public var menuIconSize: CGFloat = 18.0
    /// 是否忽略Icon原色
    public var ignoreImageOriginalColor = false
    
    /// 文字字体
    public var textFont: UIFont = UIFont.fontRegular(fontSize: 14)
    /// 文字颜色
    public var textColor: TTColor = .color(UIColor.white)
    
    /// 选中文字颜色
    public var selectedTextColor: TTColor = .color(UIColor.darkText)
    /// 选中Cell背景色
    public var selectedCellBackgroundColor: TTColor = .color(UIColor.red)
    
    /// 在选择时不会关闭的索引
    public var noDismissalIndexes: [Int]?
}

