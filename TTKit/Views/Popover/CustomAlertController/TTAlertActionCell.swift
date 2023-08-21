import UIKit

public protocol TTAlertActionCellDelegate: AnyObject {
    func alertActionCell(_ cell: TTAlertActionCell, didClickAction action: TTAlertAction?)
}

public class TTAlertActionCell: UITableViewCell {
    
    // MARK: - 颜色配置
    internal static var _DefaultActionColor: UIColor = UIColor(hex: "#29C64D") //绿色
    @objc public static var DefaultActionColor: UIColor  {
        set {
            _DefaultActionColor = newValue
        }
        get {
            return _DefaultActionColor
        }
    }
    
    internal static var _DefaultActionTextColor: UIColor = UIColor.white
    @objc public static var DefaultActionTextColor: UIColor  {
        set {
            _DefaultActionTextColor = newValue
        }
        get {
            return _DefaultActionTextColor
        }
    }
    
    internal static var _DestructiveActionColor: UIColor = UIColor(hex: "#FF4B4B") //红色
    @objc public static var DestructiveActionColor: UIColor  {
        set {
            _DestructiveActionColor = newValue
        }
        get {
            return _DestructiveActionColor
        }
    }
    
    internal static var _DestructiveActionTextColor: UIColor = UIColor.white
    @objc public static var DestructiveActionTextColor: UIColor  {
        set {
            _DestructiveActionTextColor = newValue
        }
        get {
            return _DestructiveActionTextColor
        }
    }
    
    internal static var _CancelActionColor: UIColor = UIColor.gray.withAlphaComponent(0.3)
    @objc public static var CancelActionColor: UIColor  {
        set {
            _CancelActionColor = newValue
        }
        get {
            return _CancelActionColor
        }
    }
    
    internal static var _CancelActionTextColor: UIColor = UIColor.gray
    @objc public static var CancelActionTextColor: UIColor  {
        set {
            _CancelActionTextColor = newValue
        }
        get {
            return _CancelActionTextColor
        }
    }
    
    // MARK: - Variables
    public weak var delegate: TTAlertActionCellDelegate?
    
    internal var actionList = [TTAlertAction]()
    internal var buttonList = [UIButton]()

    // MARK: - Initialization Method
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Layout Methods
    public override func layoutSubviews() {
        super.layoutIfNeeded()
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }
    
    public func setActionList(_ actions: [TTAlertAction],
                              actionsAxis: TTAlertViewController.TTAlertActionsAxis,
                              actionsEdgeInsets: UIEdgeInsets,
                              actionSpace: CGFloat) {
        self.actionList = actions
                
        for (_, item) in contentView.subviews.enumerated() {
            if item is UIButton {
                item.removeFromSuperview()
            }
        }
        buttonList.removeAll()

        var lastView: UIView?
        for (index, action) in actions.enumerated() {
            let actionButton = TTReLayoutButton(style: action.layoutStyle)
            actionButton.tag = index
            actionButton.addTarget(self, action: #selector(actionButtonClicked), for: .touchUpInside)
            actionButton.translatesAutoresizingMaskIntoConstraints = false
            actionButton.clipsToBounds = true
            contentView.addSubview(actionButton)
            
            buttonList.append(actionButton)
            
            if let title = action.title, let image = action.image {
                actionButton.setTitle(title, for: .normal)
                actionButton.setImage(image, for: .normal)
            } else if let title = action.title {
                actionButton.setTitle(title, for: .normal)
            } else if let image = action.image {
                actionButton.setImage(image, for: .normal)
            }
            
            if let textFont = action.textFont {
                actionButton.titleLabel?.font = textFont
            }
            
            
            // 设置按钮样式
            var actionDefTextColor: UIColor
            var actionDefBackgroundColor: UIColor
            switch action.style {
            case .Cancel:
                actionDefTextColor = TTAlertActionCell.CancelActionTextColor
                actionDefBackgroundColor = TTAlertActionCell.CancelActionColor
            case .Destructive:
                actionDefTextColor = TTAlertActionCell.DestructiveActionTextColor
                actionDefBackgroundColor = TTAlertActionCell.DestructiveActionColor
            default:
                actionDefTextColor = TTAlertActionCell.DefaultActionTextColor
                actionDefBackgroundColor = TTAlertActionCell.DefaultActionColor
            }
            
            if let textColor = action.textColor {
                switch textColor {
                case .color(let color):
                    actionButton.setTitleColor(color, for: .normal)
                
                #if canImport(SwiftTheme)
                case .themeColor(let themeColor):
                    actionButton.theme_setTitleColor(themeColor, forState: .normal)
                #endif
                }
            } else {
                actionButton.setTitleColor(actionDefTextColor, for: .normal)
            }
            
            if let disableTextColor = action.disableTextColor {
                switch disableTextColor {
                case .color(let color):
                    actionButton.setTitleColor(color, for: .disabled)
                
                #if canImport(SwiftTheme)
                case .themeColor(let themeColor):
                    actionButton.theme_setTitleColor(themeColor, forState: .disabled)
                #endif
                }
            }
            
            if let backgroundColor = action.backgroundColor {
                switch backgroundColor {
                case .color(let color):
                    actionButton.backgroundColor = color
                    
                #if canImport(SwiftTheme)
                case .themeColor(let themeColor):
                    actionButton.theme_backgroundColor = themeColor
                #endif
                }
            } else {
                actionButton.backgroundColor = actionDefBackgroundColor
            }
            
            if let cornerRadius = action.cornerRadius {
                actionButton.layer.cornerRadius = cornerRadius
            }
            
            actionButton.isEnabled = action.isEnabled
            
            
            // 布局
            switch actionsAxis {
            case .horizontal:
                if let lastView = lastView { //后面的
                    let actionButtonCenterY = NSLayoutConstraint.init(item: actionButton, attribute: .centerY, relatedBy: .equal, toItem: lastView, attribute: .centerY, multiplier: 1.0, constant: 0)
                    actionButtonCenterY.isActive = true
                    
                    let actionButtonBottom = NSLayoutConstraint.init(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: actionButton, attribute: .bottom, multiplier: 1.0, constant: abs(actionsEdgeInsets.bottom))
                    actionButtonBottom.isActive = true
                    
                    let actionButtonLeading = NSLayoutConstraint.init(item: actionButton, attribute: .leading, relatedBy: .equal, toItem: lastView, attribute: .trailing, multiplier: 1.0, constant: actionSpace)
                    actionButtonLeading.isActive = true
                } else { //第一个
                    let actionButtonTop = NSLayoutConstraint.init(item: actionButton, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: actionsEdgeInsets.top)
                    actionButtonTop.isActive = true
                    
                    let actionButtonBottom = NSLayoutConstraint.init(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: actionButton, attribute: .bottom, multiplier: 1.0, constant: abs(actionsEdgeInsets.bottom))
                    actionButtonBottom.isActive = true
                    
                    let actionButtonLeading = NSLayoutConstraint.init(item: actionButton, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: actionsEdgeInsets.left)
                    actionButtonLeading.isActive = true
                }
                
                if (index == actions.count - 1) { //最后一个
                    let actionButtonTrailing = NSLayoutConstraint.init(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: actionButton, attribute: .trailing, multiplier: 1.0, constant: abs(actionsEdgeInsets.right))
                    actionButtonTrailing.isActive = true
                }
                
                if let lastView = lastView {
                    let actionButtonWidth = NSLayoutConstraint.init(item: actionButton, attribute: .width, relatedBy: .equal, toItem: lastView, attribute: .width, multiplier: 1.0, constant: 0)
                    actionButtonWidth.isActive = true
                }
                
                let actionButtonHeight = NSLayoutConstraint.init(item: actionButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: action.height)
                actionButtonHeight.isActive = true
                
            case .vertical:
                let actionButtonLeading = NSLayoutConstraint.init(item: actionButton, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: actionsEdgeInsets.left)
                actionButtonLeading.isActive = true
                
                let actionButtonTrailing = NSLayoutConstraint.init(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: actionButton, attribute: .trailing, multiplier: 1.0, constant: abs(actionsEdgeInsets.right))
                actionButtonTrailing.isActive = true
                
                if let lastView = lastView { //后面的
                    let actionButtonTop = NSLayoutConstraint.init(item: actionButton, attribute: .top, relatedBy: .equal, toItem: lastView, attribute: .bottom, multiplier: 1.0, constant: actionSpace)
                    actionButtonTop.isActive = true
                } else { //第一个
                    let actionButtonTop = NSLayoutConstraint.init(item: actionButton, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: actionsEdgeInsets.top)
                    actionButtonTop.isActive = true
                }
                
                if (index == actions.count - 1) { //最后一个
                    let actionButtonBottom = NSLayoutConstraint.init(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: actionButton, attribute: .bottom, multiplier: 1.0, constant: abs(actionsEdgeInsets.bottom))
                    actionButtonBottom.isActive = true
                }
                
                let actionButtonHeight = NSLayoutConstraint.init(item: actionButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: action.height)
                actionButtonHeight.isActive = true
            }
            
            lastView = actionButton
        }
        
        
        self.layoutIfNeeded()
        
        let addButtonsLine: () -> Void = {
            // 添加分割线
            for (index, actionButton) in self.buttonList.enumerated() {
                let action = self.actionList[index]
                
                if actionSpace > 0 { //添加四个边线
                    if let borderColor = action.borderColor, let borderWidth = action.borderWidth {
                        actionButton.layer.borderWidth = borderWidth
                        switch borderColor {
                        case .cgColor(let cgColor):
                            actionButton.layer.borderColor = cgColor
                            
                        #if canImport(SwiftTheme)
                        case .themeCGColor(let themeCGColor):
                            actionButton.layer.theme_borderColor = themeCGColor
                        #endif
                        }
                    }
                } else {
                    if let borderColor = action.borderColor, let borderWidth = action.borderWidth {
                        if actionsAxis == .horizontal { //按钮水平排列
                            // 添加顶部分割线
                            let topLine = UIBezierPath(rect: CGRect(x: 0, y: 0, width: actionButton.frame.size.width, height: borderWidth))
                            let topLineShape = CAShapeLayer()
                            topLineShape.path = topLine.cgPath
                            
                            switch borderColor {
                            case .cgColor(let cgColor):
                                topLineShape.fillColor = cgColor
                                
                            #if canImport(SwiftTheme)
                            case .themeCGColor(let themeCGColor):
                                topLineShape.theme_fillColor = themeCGColor
                            #endif
                            }
                            
                            actionButton.layer.addSublayer(topLineShape)

                            // 后面的按钮，添加左侧分割线
                            if index != 0 {
                                let leftLine = UIBezierPath(rect: CGRect(x: 0, y: 0, width: borderWidth, height: action.height))
                                let leftLineShape = CAShapeLayer()
                                leftLineShape.path = leftLine.cgPath
                                
                                switch borderColor {
                                case .cgColor(let cgColor):
                                    leftLineShape.fillColor = cgColor

                                #if canImport(SwiftTheme)
                                case .themeCGColor(let themeCGColor):
                                    leftLineShape.theme_fillColor = themeCGColor
                                #endif
                                }
                                
                                actionButton.layer.addSublayer(leftLineShape)
                            }
                        }
                        else { //按钮垂直排列
                            // 后面的按钮，添加顶部分割线
                            if index != 0 {
                                let topLine = UIBezierPath(rect: CGRect(x: 0, y: 0, width: actionButton.frame.size.width, height: borderWidth))
                                let topLineShape = CAShapeLayer()
                                topLineShape.path = topLine.cgPath

                                switch borderColor {
                                case .cgColor(let cgColor):
                                    topLineShape.fillColor = cgColor

                                #if canImport(SwiftTheme)
                                case .themeCGColor(let themeCGColor):
                                    topLineShape.theme_fillColor = themeCGColor
                                #endif
                                }
                                
                                actionButton.layer.addSublayer(topLineShape)
                            }
                        }
                    }
                }
            }
        }

        //延迟执行是为了解决添加线条获取视图宽度时不正确的问题
        delayExecuting(0.1) {
            addButtonsLine()
        }
    }
    
    // MARK: - Button Click Events
    @IBAction internal func actionButtonClicked(_ sender: Any) {
        if let delegate = delegate {
            delegate.alertActionCell(self, didClickAction: self.actionList[(sender as! UIButton).tag])
        }
    }
}
