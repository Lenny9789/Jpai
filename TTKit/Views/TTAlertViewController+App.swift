import UIKit

/// 普通Alert入参
struct SimpleAlert {
    var title: String?
    var subtitle: NSAttributedString?
    var message: String?
    var radio: String?
    var actions: [AlertActionItem]
}

/// 对话框按钮
struct AlertActionItem {
    public enum ColorType {
        case cancel                         //取消样式（白色）
        case confirm                        //确认样式（蓝色）
        case custom(_ textColor: TTColor)   //自定义
    }
    
    var title: String?          //按钮标题
    var image: UIImage?         //按钮图片
    var titleColor: ColorType?  //颜色类型
    var isEnable: Bool?         //按钮是否可点击
}

/// 对话框操作结果
struct AlertResult {
    var index: Int              //按钮点击位置索引
    var isRadioSelected: Bool?  //是否选择了单选框，如果有单选框的话
}


/// 弹框便捷方法
///
extension TTAlertViewController {
    
    /// 显示简单对话框
    @discardableResult
    class func showSimpleAlert(_ params: SimpleAlert,
                               dismissClosure: @escaping (AlertResult?) -> Void) -> TTAlertViewController {
        
        let alert = TTAlertViewController(title: params.title,
                                          subtitle: params.subtitle,
                                          message: params.message,
                                          radio: params.radio,
                                          preferredStyle: .alert,
                                          headerView: nil,
                                          middleView: nil,
                                          footerView: nil,
                                          receiveTouchViewTag: nil) { (reason) in
            if reason != .onActionTap {
                dismissClosure(nil)
            }
        }
        
        alert.backgroundStyle = .plain
        alert.containerMaxWidth = 270
        alert.containerColor = .themeColor(ThemeGuide.Colors.theme_popBg)
        alert.titleColor = .themeColor(ThemeGuide.Colors.theme_title)
        alert.subtitleColor = .themeColor(ThemeGuide.Colors.theme_title)
        alert.messageColor = .themeColor(ThemeGuide.Colors.theme_hexPopBody)
        alert.radioColor = .themeColor(ThemeGuide.Colors.theme_assist)
//        alert.radioNormalImage = ThemeGuide.Icons.Common.radiobox_normal
//        alert.radioSelectedImage = ThemeGuide.Icons.Common.radiobox_selected
        alert.shouldDismissOnBackgroundTap = false
        
        for (index, action) in params.actions.enumerated() {
            
            var textColor_: TTColor?
            switch action.titleColor {
            case .cancel:
                textColor_ = .themeColor(ThemeGuide.Colors.theme_title)
            case .confirm:
                textColor_ = .color(ThemeGuide.Colors.primary)
            case .custom(let textColor):
                textColor_ = textColor
            default:
                break
            }
            
            var space:CGFloat = 0.0
            if action.image != nil {
                space = 20.0
            }
            
            let actionCancel = TTAlertAction(title: action.title,
                                             image: action.image,
                                             style: .Default,
                                             layoutStyle: .image_Text(align: .centering(space: space)),
                                             textFont: UIFont.fontMedium(fontSize: 17),
                                             textColor: textColor_,
                                             disableTextColor: .themeColor(ThemeGuide.Colors.theme_assist),
                                             backgroundColor: .themeColor(ThemeGuide.Colors.theme_popBg),
                                             borderColor: .themeCGColor(ThemeGuide.Colors.theme_separatorLayer),
                                             borderWidth: 1,
                                             cornerRadius: nil) { (action) in
                
                dismissClosure(AlertResult(index: index, isRadioSelected: action.respIsRadioSelected))
            }
            alert.addAction(actionCancel)
        }
        alert.showAlert()
        return alert
    }
    
    /// 显示简单底部弹窗
    class func showSimpleActionList(_ actions: [AlertActionItem],
                                    dismissClosure: @escaping (AlertResult?) -> Void) {
        
        let alert = TTAlertViewController(title: nil,
                                          subtitle: nil,
                                          message: nil,
                                          radio: nil,
                                          preferredStyle: .actionSheet,
                                          headerView: nil,
                                          middleView: nil,
                                          footerView: nil,
                                          receiveTouchViewTag: nil) { (reason) in
            if reason != .onActionTap {
                dismissClosure(nil)
            }
        }
        
        alert.backgroundStyle = .plain
        alert.containerCornerRadius = 10
        alert.containerColor = .themeColor(ThemeGuide.Colors.theme_popBg)
        alert.actionsAxis = .vertical
        
        for (index, action) in actions.enumerated() {
            
            var textColor_: TTColor?
            switch action.titleColor {
            case .cancel:
                textColor_ = .themeColor(ThemeGuide.Colors.theme_title)
            case .confirm:
                textColor_ = .color(ThemeGuide.Colors.primary)
            case .custom(let textColor):
                textColor_ = textColor
            default:
                break
            }
            
            let actionCancel = TTAlertAction(title: action.title,
                                             image: action.image,
                                             style: .Default,
                                             layoutStyle: .text_Image(align: .spaceBetween(padding: 20)),
                                             textFont: UIFont.fontMedium(fontSize: 16),
                                             textColor: textColor_,
                                             disableTextColor: .themeColor(ThemeGuide.Colors.theme_assist),
                                             backgroundColor: .themeColor(ThemeGuide.Colors.theme_popBg),
                                             borderColor: .themeCGColor(ThemeGuide.Colors.theme_separatorLayer),
                                             borderWidth: 1,
                                             cornerRadius: nil,
                                             height: 44) { (action) in
                
                dismissClosure(AlertResult(index: index, isRadioSelected: action.respIsRadioSelected))
            }
            alert.addAction(actionCancel)
        }
        
        alert.showAlert()
    }
    
    class func showSimpleActionList(_ actions: [AlertActionItem],
                                    layout: TTReLayoutButton.LayoutStyle,
                                    dismissClosure: @escaping (AlertResult?) -> Void) {
        
        let alert = TTAlertViewController(title: nil,
                                          subtitle: nil,
                                          message: nil,
                                          radio: nil,
                                          preferredStyle: .actionSheet,
                                          headerView: nil,
                                          middleView: nil,
                                          footerView: nil,
                                          receiveTouchViewTag: nil) { (reason) in
            if reason != .onActionTap {
                dismissClosure(nil)
            }
        }
        
        alert.backgroundStyle = .plain
        alert.containerCornerRadius = 10
        alert.containerColor = .themeColor(ThemeGuide.Colors.theme_popBg)
        alert.actionsAxis = .vertical
        
        for (index, action) in actions.enumerated() {
            
            var textColor_: TTColor?
            switch action.titleColor {
            case .cancel:
                textColor_ = .themeColor(ThemeGuide.Colors.theme_title)
            case .confirm:
                textColor_ = .color(ThemeGuide.Colors.primary)
            case .custom(let textColor):
                textColor_ = textColor
            default:
                break
            }
            
            let actionCancel = TTAlertAction(title: action.title,
                                             image: action.image,
                                             style: .Default,
                                             layoutStyle: layout,
                                             textFont: UIFont.fontMedium(fontSize: 16),
                                             textColor: textColor_,
                                             disableTextColor: .themeColor(ThemeGuide.Colors.theme_assist),
                                             backgroundColor: .themeColor(ThemeGuide.Colors.theme_popBg),
                                             borderColor: .themeCGColor(ThemeGuide.Colors.theme_separatorLayer),
                                             borderWidth: 1,
                                             cornerRadius: nil,
                                             height: 44) { (action) in
                
                dismissClosure(AlertResult(index: index, isRadioSelected: action.respIsRadioSelected))
            }
            alert.addAction(actionCancel)
        }
        
        alert.showAlert()
    }
    
    /// 显示简单顶部通知
    class func showSimpleNotification(_ message: String) {
        
        let alert = TTAlertViewController(title: nil,
                                          subtitle: nil,
                                          message: message,
                                          radio: nil,
                                          preferredStyle: .notification,
                                          headerView: nil,
                                          middleView: nil,
                                          footerView: nil,
                                          receiveTouchViewTag: nil,
                                          didDismissAlertHandler: nil)
        
        alert.backgroundStyle = .plain
        alert.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        alert.containerCornerRadius = 16
        alert.containerColor = .themeColor(ThemeGuide.Colors.theme_popBg)
        alert.messageColor = .themeColor(ThemeGuide.Colors.theme_title)
        alert.textEdgeInsets = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
        
        alert.showAlert()
        
        delayExecuting(1.5) {
            alert.dismissAlert(withAnimation: true, completion: nil)
        }
    }
    
    /// 弹框默认配置按钮
    class var defaultAlertActions: [AlertActionItem] {
        return [
            AlertActionItem(title: .localized_cancel, image: nil, titleColor: .cancel, isEnable: true),
            AlertActionItem(title: .localized_confirm, image: nil, titleColor: .confirm, isEnable: true)
        ]
    }
}

/// 自定义弹框
extension TTAlertViewController {
    
    /// 显示自定义弹窗
    @discardableResult
    class func showCustomPopup(_ customView: UIView,
                               style: TTAlertControllerStyle,
                               width: CGFloat = kScreenWidth - 32,
                               receiveTouchViewTag: Int? = nil,
                               dismissClosure: TTVoidBlock? = nil) -> TTAlertViewController {
        
        let viewTagNumber = receiveTouchViewTag != nil ? NSNumber(integerLiteral: receiveTouchViewTag!) : nil
        
        let alert = TTAlertViewController(title: nil,
                                          subtitle: nil,
                                          message: nil,
                                          radio: nil,
                                          preferredStyle: style,
                                          headerView: nil,
                                          middleView: customView,
                                          footerView: nil,
                                          receiveTouchViewTag: viewTagNumber) { (reason) in
            dismissClosure?()
        }
        
        alert.backgroundStyle = .plain
        alert.containerMaxWidth = width
        alert.containerCornerRadius = 16
        alert.containerColor = .themeColor(ThemeGuide.Colors.theme_popBg)

        alert.showAlert()
        
        return alert
    }
}
