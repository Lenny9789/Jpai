import UIKit

/// 弹出菜单
///
extension TTPopMenu {

    class func showPopMenu(sender: UIView,
                           with menuArray: [TTMenuObjectType],
                           onSelected: ((NSInteger)->())?) {
        
        let config = TTPopMenuConfiguration()
        config.menuWidth = 196
        config.menuRowHeight = 44
        config.cornerRadius = 5
        config.menuMargin = 16
        config.menuArrowShow = false
        config.backgroundTintColor = .themeCGColor(ThemeGuide.Colors.theme_popBgCG)
        config.borderColor = .themeCGColor(ThemeGuide.Colors.theme_popBgCG)
        config.menuSeparatorColor = .themeColor(ThemeGuide.Colors.theme_separator)
        config.menuSeparatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        config.globalShadow = true
        config.contentDistribution = .spaceBetween
        config.cellMargin = 16
        config.menuIconSize = 20
        config.textFont = UIFont.fontMedium(fontSize: 16)
        config.textColor = .themeColor(ThemeGuide.Colors.theme_title)
        
        self.showForSender(sender: sender,
                           with: menuArray,
                           popOverPosition: .automatic,
                           config: config,
                           selectedIndex: nil,
                           done: { (selectedIndex) in
                               onSelected?(selectedIndex)
                           },
                           cancel: {
                               debugPrint("取消")
                           })
    }
}
