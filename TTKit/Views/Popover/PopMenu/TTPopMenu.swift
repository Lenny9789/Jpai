import UIKit
#if canImport(SwiftTheme)
import SwiftTheme
#endif

/// 弹出菜单便捷构造
///
extension TTPopMenu {
    
    public class func showForSender(sender: UIView,
                                    with menuArray: [TTMenuObjectType],
                                    popOverPosition: TTPopOverPosition = .automatic,
                                    config: TTPopMenuConfiguration? = nil,
                                    selectedIndex: Int? = nil,
                                    done: ((NSInteger)->())?,
                                    cancel: (()->())? = nil) {
        TTPopMenu.shared.showForSender(sender: sender, or: nil, with: menuArray, popOverPosition: popOverPosition, config: config, selectedIndex: selectedIndex, done: done, cancel: cancel)
    }

    public class func showForEvent(event: UIEvent,
                                   with menuArray: [TTMenuObjectType],
                                   popOverPosition: TTPopOverPosition = .automatic,
                                   config: TTPopMenuConfiguration? = nil,
                                   selectedIndex: Int? = nil,
                                   done: ((NSInteger)->())?,
                                   cancel: (()->())? = nil) {
        TTPopMenu.shared.showForSender(sender: event.allTouches?.first?.view!, or: nil, with: menuArray, popOverPosition: popOverPosition, config: config, selectedIndex: selectedIndex, done: done, cancel: cancel)
    }

    public class func showFromSenderFrame(senderFrame: CGRect,
                                          with menuArray: [TTMenuObjectType],
                                          popOverPosition: TTPopOverPosition = .automatic,
                                          config: TTPopMenuConfiguration? = nil,
                                          selectedIndex: Int? = nil,
                                          done: ((NSInteger)->())?,
                                          cancel: (()->())? = nil) {
        TTPopMenu.shared.showForSender(sender: nil, or: senderFrame, with: menuArray, popOverPosition: popOverPosition, config: config, selectedIndex: selectedIndex, done: done, cancel: cancel)
    }
}


/// 菜单类型
public enum TTMenuObjectType {
    /// 图片
    case icon(UIImage)
    /// 文本
    case text(String, specifyColor: TTColor? = nil)
    /// 图片前+文本后
    case icon_text(icon: UIImage, text: String, specifyColor: TTColor? = nil)
    /// 文本前+图片后
    case text_icon(text: String, icon: UIImage, specifyColor: TTColor? = nil)
}

/// 菜单Item对齐类型
public enum TTMenuItemDistribution {
    /// 首部对齐
    case leading
    /// 中间对齐
    case center
    /// 尾部对齐
    case trailing
    /// 两端对齐
    case spaceBetween
}

/// 箭头方向
fileprivate enum TTPopMenuArrowDirection {
    /// 向上
    case up
    /// 向下
    case down
}

/// 弹框位置
public enum TTPopOverPosition {
    /// 自动
    case automatic
    /// 总是在Sender上面
    case alwaysAboveSender
    /// 总是在Sender下面
    case alwaysUnderSender
}


/// 弹出菜单
///
public class TTPopMenu: NSObject, TTPopMenuViewDelegate {
    
    var sender: UIView?
    var senderFrame: CGRect?
    var menuArray: [TTMenuObjectType]!
    var done: ((Int)->())?
    var cancel: (()->())?
    var configuration = TTPopMenuConfiguration()
    var selectedIndex: Int?
    var popOverPosition: TTPopOverPosition = .automatic
    
    fileprivate lazy var backgroundView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        if let adapter = self.configuration.globalShadowAdapter {
            adapter(view)
        } else {
            if self.configuration.globalShadow {
                view.backgroundColor = UIColor.black.withAlphaComponent(self.configuration.shadowAlpha)
            }
        }
        view.addGestureRecognizer(self.tapGesture)
        return view
    }()
    
    fileprivate lazy var popOverMenuView: TTPopMenuView = {
        let menu = TTPopMenuView(frame: CGRect.zero)
        menu.alpha = 0
        self.backgroundView.addSubview(menu)
        return menu
    }()
    
    fileprivate var isOnScreen: Bool = false {
        didSet {
            if isOnScreen {
                self.addOrientationChangeNotification()
            } else {
                self.removeOrientationChangeNotification()
            }
        }
    }
    
    fileprivate lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onBackgroudViewTapped(gesture:)))
        gesture.delegate = self
        return gesture
    }()
    
    class var shared: TTPopMenu {
        struct Manager {
            static let instance = TTPopMenu()
        }
        return Manager.instance
    }
    
    public func showForSender(sender: UIView?,
                              or senderFrame: CGRect?,
                              with menuArray: [TTMenuObjectType]!,
                              popOverPosition: TTPopOverPosition = .automatic,
                              config: TTPopMenuConfiguration? = nil,
                              selectedIndex: Int? = nil,
                              done: ((Int)->())?,
                              cancel: (()->())? = nil) {
        if sender == nil && senderFrame == nil {
            return
        }
        if menuArray.count == 0 {
            return
        }
        
        self.sender = sender
        self.senderFrame = senderFrame
        self.menuArray = menuArray
        self.popOverPosition = popOverPosition
        self.configuration = config ?? TTPopMenuConfiguration()
        self.selectedIndex = selectedIndex
        self.done = done
        self.cancel = cancel
        
        UIApplication.shared.keyWindow?.addSubview(self.backgroundView)
        self.adjustPositionForPopOverMenu()
    }
    
    public func dismiss() {
        self.doneActionWithSelectedIndex(selectedIndex: -1)
    }
    
    fileprivate func adjustPositionForPopOverMenu() {
        self.backgroundView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        
        self.setupPopOverMenu()
        
        self.showIfNeeded()
    }
    
    fileprivate func setupPopOverMenu() {
        popOverMenuView.delegate = self
        popOverMenuView.transform = CGAffineTransform(scaleX: 1, y: 1)
        
        self.configurePopMenuFrame()
        
        popOverMenuView.showWithAnglePoint(point: menuArrowPoint,
                                           frame: popMenuFrame,
                                           menuArray: menuArray,
                                           config: configuration,
                                           selectedIndex: selectedIndex,
                                           arrowDirection: arrowDirection,
                                           delegate: self)
        
        popOverMenuView.setAnchorPoint(anchorPoint: self.getAnchorPointForPopMenu())
    }
    
    fileprivate func getAnchorPointForPopMenu() -> CGPoint {
        var anchorPoint = CGPoint(x: menuArrowPoint.x/popMenuFrame.size.width, y: 0)
        if arrowDirection == .down {
            anchorPoint = CGPoint(x: menuArrowPoint.x/popMenuFrame.size.width, y: 1)
        }
        return anchorPoint
    }
    
    fileprivate var senderRect: CGRect = CGRect.zero
    fileprivate var popMenuOriginX: CGFloat = 0
    fileprivate var popMenuFrame: CGRect = CGRect.zero
    fileprivate var menuArrowPoint: CGPoint = CGPoint.zero
    fileprivate var arrowDirection: TTPopMenuArrowDirection = .up
    fileprivate var popMenuHeight: CGFloat {
        var height = configuration.menuRowHeight * CGFloat(self.menuArray.count)
        if configuration.menuArrowShow {
            height += configuration.menuArrowHeight
        }
        return height
    }
    
    fileprivate func configurePopMenuFrame() {
        self.configureSenderRect()
        self.configureMenuArrowPoint()
        self.configurePopMenuOriginX()

        var safeAreaInset = UIEdgeInsets.zero
        if #available(iOS 11.0, *) {
            safeAreaInset = UIApplication.shared.keyWindow?.safeAreaInsets ?? UIEdgeInsets.zero
        }
        
        if arrowDirection == .up {
            popMenuFrame = CGRect(x: popMenuOriginX, y: (senderRect.origin.y + senderRect.size.height), width: configuration.menuWidth, height: popMenuHeight)
            if (popMenuFrame.origin.y + popMenuFrame.size.height > kScreenHeight - safeAreaInset.bottom) {
                popMenuFrame = CGRect(x: popMenuOriginX, y: (senderRect.origin.y + senderRect.size.height), width: configuration.menuWidth, height: kScreenHeight - popMenuFrame.origin.y - configuration.menuMargin - safeAreaInset.bottom)
            }
        } else {
            popMenuFrame = CGRect(x: popMenuOriginX, y: (senderRect.origin.y - popMenuHeight), width: configuration.menuWidth, height: popMenuHeight)
            if popMenuFrame.origin.y  < safeAreaInset.top {
                popMenuFrame = CGRect(x: popMenuOriginX, y: configuration.menuMargin + safeAreaInset.top, width: configuration.menuWidth, height: senderRect.origin.y - configuration.menuMargin - safeAreaInset.top)
            }
        }
    }
    
    fileprivate func configureSenderRect() {
        if let sender = self.sender {
            if let superView = sender.superview {
                senderRect = superView.convert(sender.frame, to: backgroundView)
            }
        } else if let frame = senderFrame {
            senderRect = frame
        }
        senderRect.origin.y = min(kScreenHeight, senderRect.origin.y)
        
        if popOverPosition == .alwaysAboveSender {
            arrowDirection = .down
        } else if popOverPosition == .alwaysUnderSender {
            arrowDirection = .up
        } else {
            if senderRect.origin.y + senderRect.size.height/2 < kScreenHeight/2 {
                arrowDirection = .up
            } else {
                arrowDirection = .down
            }
        }
    }
    
    fileprivate func configureMenuArrowPoint() {
        var point: CGPoint = CGPoint(x: senderRect.origin.x + (senderRect.size.width)/2, y: 0)
        let menuCenterX: CGFloat = configuration.menuWidth/2 + configuration.menuMargin
        if senderRect.origin.y + senderRect.size.height/2 < kScreenHeight/2 {
            point.y = 0
        } else {
            point.y = popMenuHeight
        }
        if point.x + menuCenterX > kScreenWidth {
            point.x = min(point.x - (kScreenWidth - configuration.menuWidth - configuration.menuMargin), configuration.menuWidth - configuration.menuArrowWidth - configuration.menuMargin)
        } else if point.x - menuCenterX < 0 {
            point.x = max(configuration.cornerRadius + configuration.menuArrowWidth, point.x - configuration.menuMargin)
        } else {
            point.x = configuration.menuWidth/2
        }
        menuArrowPoint = point
    }
    
    fileprivate func configurePopMenuOriginX() {
        var senderXCenter: CGPoint = CGPoint(x: senderRect.origin.x + (senderRect.size.width)/2, y: 0)
        let menuCenterX: CGFloat = configuration.menuWidth/2 + configuration.menuMargin
        var menuX: CGFloat = 0
        if senderXCenter.x + menuCenterX > kScreenWidth {
            senderXCenter.x = min(senderXCenter.x - (kScreenWidth - configuration.menuWidth - configuration.menuMargin), configuration.menuWidth - configuration.menuArrowWidth - configuration.menuMargin)
            menuX = kScreenWidth - configuration.menuWidth - configuration.menuMargin
        } else if senderXCenter.x - menuCenterX < 0 {
            senderXCenter.x = max(configuration.cornerRadius + configuration.menuArrowWidth, senderXCenter.x - configuration.menuMargin)
            menuX = configuration.menuMargin
        } else {
            senderXCenter.x = configuration.menuWidth/2
            menuX = senderRect.origin.x + (senderRect.size.width)/2 - configuration.menuWidth/2
        }
        popMenuOriginX = menuX
    }
    
    @objc fileprivate func onBackgroudViewTapped(gesture: UIGestureRecognizer) {
        self.dismiss()
    }
    
    fileprivate func showIfNeeded() {
        if self.isOnScreen == false {
            self.isOnScreen = true
            popOverMenuView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: configuration.animationDuration, animations: { [weak self] in
                self?.popOverMenuView.alpha = 1
                self?.popOverMenuView.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
    
    fileprivate func doneActionWithSelectedIndex(selectedIndex: NSInteger) {
        if configuration.noDismissalIndexes?.firstIndex(of: selectedIndex) != nil {
            self.done?(selectedIndex)
            return
        }
        
        self.isOnScreen = false
        
        UIView.animate(withDuration: configuration.animationDuration,
                       animations: { [weak self] in
                        self?.popOverMenuView.alpha = 0
                        self?.popOverMenuView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { [weak self] (_) in
            self?.backgroundView.removeFromSuperview()
            if selectedIndex < 0 {
                self?.cancel?()
                self?.cancel = nil
            } else {
                self?.done?(selectedIndex)
                self?.done = nil
            }
        }
    }
    
    // MARK: - TTPopMenuViewDelegate -
    
    func menuItemDidSelect(at index: Int) {
        self.doneActionWithSelectedIndex(selectedIndex: index)
    }
    
}

extension TTPopMenu {
    
    fileprivate func addOrientationChangeNotification() {
        NotificationCenter.default.addObserver(self,selector: #selector(onChangeStatusBarOrientationNotification(notification:)),
                                               name: UIApplication.didChangeStatusBarOrientationNotification,
                                               object: nil)
    }
    
    fileprivate func removeOrientationChangeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func onChangeStatusBarOrientationNotification(notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { [weak self] in
            self?.adjustPositionForPopOverMenu()
        })
    }
    
}

extension TTPopMenu: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: backgroundView)
        let touchClass: String = NSStringFromClass((touch.view?.classForCoder)!) as String
        if touchClass == "UITableViewCellContentView" {
            return false
        } else if CGRect(x: 0, y: 0, width: configuration.menuWidth, height: configuration.menuRowHeight).contains(touchPoint) {
            // 当显示在导航栏按钮项时，有可能在顶部箭头周围没有响应，因此：
            self.doneActionWithSelectedIndex(selectedIndex: 0)
            return false
        }
        return true
    }
    
}



fileprivate protocol TTPopMenuViewDelegate: NSObjectProtocol {
    
    func menuItemDidSelect(at index: Int)
}

fileprivate class TTPopMenuView: UIControl {
    
    fileprivate var menuArray: [TTMenuObjectType]!
    fileprivate var arrowDirection: TTPopMenuArrowDirection = .up
    fileprivate weak var delegate: TTPopMenuViewDelegate?
    fileprivate var configuration = TTPopMenuConfiguration()
    fileprivate var selectedIndex: Int?
    
    lazy var menuTableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        switch self.configuration.menuSeparatorColor {
        case .color(let color):
            tableView.separatorColor = color
        #if canImport(SwiftTheme)
        case .themeColor(let themeColor):
            tableView.theme_separatorColor = themeColor
        #endif
        }
        tableView.layer.cornerRadius = self.configuration.cornerRadius
        tableView.clipsToBounds = true
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
    }()
    
    fileprivate func showWithAnglePoint(point: CGPoint, frame: CGRect, menuArray: [TTMenuObjectType]!, config: TTPopMenuConfiguration? = nil, selectedIndex: Int? = nil, arrowDirection: TTPopMenuArrowDirection, delegate: TTPopMenuViewDelegate?) {
        
        self.frame = frame

        self.menuArray = menuArray
        self.configuration = config ?? TTPopMenuConfiguration()
        self.selectedIndex = selectedIndex
        self.arrowDirection = arrowDirection
        self.delegate = delegate
        
        repositionMenuTableView()
        
        drawBackgroundLayerWithArrowPoint(arrowPoint: point)
    }
    
    fileprivate func repositionMenuTableView() {
        var menuRect: CGRect
        if configuration.menuArrowShow {
            if (arrowDirection == .up) {
                menuRect = CGRect(x: 0, y: configuration.menuArrowHeight, width: frame.size.width, height: frame.size.height - configuration.menuArrowHeight)
            } else {
                menuRect = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height - configuration.menuArrowHeight)
            }
        } else {
            menuRect = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        }
        menuTableView.frame = menuRect
        menuTableView.reloadData()
        if menuTableView.frame.height < configuration.menuRowHeight * CGFloat(menuArray.count) {
            menuTableView.isScrollEnabled = true
        } else {
            menuTableView.isScrollEnabled = false
        }
        addSubview(self.menuTableView)
    }
    
    fileprivate lazy var backgroundLayer: CAShapeLayer = {
        let layer: CAShapeLayer = CAShapeLayer()
        return layer
    }()
    
    
    fileprivate func drawBackgroundLayerWithArrowPoint(arrowPoint: CGPoint) {
        if self.backgroundLayer.superlayer != nil {
            self.backgroundLayer.removeFromSuperlayer()
        }
        
        backgroundLayer.path = getBackgroundPath(arrowPoint: arrowPoint).cgPath
        
        //背景色
        switch configuration.backgroundTintColor {
        case .cgColor(let cgColor):
            backgroundLayer.fillColor = cgColor
        #if canImport(SwiftTheme)
        case .themeCGColor(let themeCGColor):
            backgroundLayer.theme_fillColor = themeCGColor
        #endif
        }
        
        //边线颜色
        switch configuration.borderColor {
        case .cgColor(let cgColor):
            backgroundLayer.strokeColor = cgColor
        #if canImport(SwiftTheme)
        case .themeCGColor(let themeCGColor):
            backgroundLayer.theme_strokeColor = themeCGColor
        #endif
        }
        
        backgroundLayer.lineWidth = configuration.borderWidth
        
        if let adpater = self.configuration.localShadowAdapter {
            adpater(backgroundLayer)
        } else {
            if configuration.localShadow {
                backgroundLayer.shadowColor = UIColor.black.cgColor
                backgroundLayer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                backgroundLayer.shadowRadius = 24.0
                backgroundLayer.shadowOpacity = 0.9
                backgroundLayer.masksToBounds = false
                backgroundLayer.shouldRasterize = true
                backgroundLayer.rasterizationScale = UIScreen.main.scale
            }
        }
        self.layer.insertSublayer(backgroundLayer, at: 0)
    }
    
    func getBackgroundPath(arrowPoint: CGPoint) -> UIBezierPath {
        
        let viewWidth = bounds.size.width
        let viewHeight = bounds.size.height
        
        let radius: CGFloat = configuration.cornerRadius
        
        let path: UIBezierPath = UIBezierPath()
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
        if (arrowDirection == .up){
            if configuration.menuArrowShow {
                path.move(to: CGPoint(x: arrowPoint.x - configuration.menuArrowWidth, y: configuration.menuArrowHeight)) //三角左底点
                path.addLine(to: CGPoint(x: arrowPoint.x, y: 0)) //左斜线
                path.addLine(to: CGPoint(x: arrowPoint.x + configuration.menuArrowWidth, y: configuration.menuArrowHeight)) //右斜线
                path.addLine(to: CGPoint(x:viewWidth - radius, y: configuration.menuArrowHeight)) //右上横线
                path.addArc(withCenter: CGPoint(x: viewWidth - radius, y: configuration.menuArrowHeight + radius),
                            radius: radius,
                            startAngle: .pi / 2 * 3,
                            endAngle: 0,
                            clockwise: true) //右上圆角
                path.addLine(to: CGPoint(x: viewWidth, y: viewHeight - radius)) //右边
                path.addArc(withCenter: CGPoint(x: viewWidth - radius, y: viewHeight - radius),
                            radius: radius,
                            startAngle: 0,
                            endAngle: .pi / 2,
                            clockwise: true) //右下圆角
                path.addLine(to: CGPoint(x: radius, y: viewHeight)) //底边
                path.addArc(withCenter: CGPoint(x: radius, y: viewHeight - radius),
                            radius: radius,
                            startAngle: .pi / 2,
                            endAngle: .pi,
                            clockwise: true) //左下圆角
                path.addLine(to: CGPoint(x: 0, y: configuration.menuArrowHeight + radius)) //左边
                path.addArc(withCenter: CGPoint(x: radius, y: configuration.menuArrowHeight + radius),
                            radius: radius,
                            startAngle: .pi,
                            endAngle: .pi / 2 * 3,
                            clockwise: true) //左上圆角
                path.close()
            } else {
                path.move(to: CGPoint(x: arrowPoint.x, y: 0)) //起点
                path.addLine(to: CGPoint(x:viewWidth - radius, y: 0)) //右上横线
                path.addArc(withCenter: CGPoint(x: viewWidth - radius, y: radius),
                            radius: radius,
                            startAngle: .pi / 2 * 3,
                            endAngle: 0,
                            clockwise: true) //右上圆角
                path.addLine(to: CGPoint(x: viewWidth, y: viewHeight - radius)) //右边
                path.addArc(withCenter: CGPoint(x: viewWidth - radius, y: viewHeight - radius),
                            radius: radius,
                            startAngle: 0,
                            endAngle: .pi / 2,
                            clockwise: true) //右下圆角
                path.addLine(to: CGPoint(x: radius, y: viewHeight)) //底边
                path.addArc(withCenter: CGPoint(x: radius, y: viewHeight - radius),
                            radius: radius,
                            startAngle: .pi / 2,
                            endAngle: .pi,
                            clockwise: true) //左下圆角
                path.addLine(to: CGPoint(x: 0, y: radius)) //左边
                path.addArc(withCenter: CGPoint(x: radius, y: radius),
                            radius: radius,
                            startAngle: .pi,
                            endAngle: .pi / 2 * 3,
                            clockwise: true) //左上圆角
                path.close()
            }
        } else {
            if configuration.menuArrowShow {
                path.move(to: CGPoint(x: arrowPoint.x - configuration.menuArrowWidth, y: viewHeight - configuration.menuArrowHeight)) //三角左底点
                path.addLine(to: CGPoint(x: arrowPoint.x, y: viewHeight)) //左斜线
                path.addLine(to: CGPoint(x: arrowPoint.x + configuration.menuArrowWidth, y: viewHeight - configuration.menuArrowHeight)) //右斜线
                path.addLine(to: CGPoint(x: viewWidth - radius, y: viewHeight - configuration.menuArrowHeight)) //底右线
                path.addArc(withCenter: CGPoint(x: viewWidth - radius, y: viewHeight - configuration.menuArrowHeight - radius),
                            radius: radius,
                            startAngle: .pi / 2,
                            endAngle: 0,
                            clockwise: false) //右下角
                path.addLine(to: CGPoint(x: viewWidth, y: radius)) //右边
                path.addArc(withCenter: CGPoint(x: viewWidth - radius, y: radius),
                            radius: radius,
                            startAngle: 0,
                            endAngle: .pi / 2 * 3,
                            clockwise: false) //右上角
                path.addLine(to: CGPoint(x: radius, y: 0)) //上边
                path.addArc(withCenter: CGPoint(x: radius, y: radius),
                            radius: radius,
                            startAngle: .pi / 2 * 3,
                            endAngle: .pi,
                            clockwise: false) //左上角
                path.addLine(to: CGPoint(x: 0, y: viewHeight - configuration.menuArrowHeight - radius)) //左边
                path.addArc(withCenter: CGPoint(x: radius, y: viewHeight - configuration.menuArrowHeight - radius),
                            radius: radius,
                            startAngle: .pi,
                            endAngle: .pi / 2,
                            clockwise: false) //左下角
                path.close()
            } else {
                path.move(to: CGPoint(x: arrowPoint.x, y: viewHeight)) //起点
                path.addLine(to: CGPoint(x: viewWidth - radius, y: viewHeight)) //底右线
                path.addArc(withCenter: CGPoint(x: viewWidth - radius, y: viewHeight - radius),
                            radius: radius,
                            startAngle: .pi / 2,
                            endAngle: 0,
                            clockwise: false) //右下角
                path.addLine(to: CGPoint(x: viewWidth, y: radius)) //右边
                path.addArc(withCenter: CGPoint(x: viewWidth - radius, y: radius),
                            radius: radius,
                            startAngle: 0,
                            endAngle: .pi / 2 * 3,
                            clockwise: false) //右上角
                path.addLine(to: CGPoint(x: radius, y: 0)) //上边
                path.addArc(withCenter: CGPoint(x: radius, y: radius),
                            radius: radius,
                            startAngle: .pi / 2 * 3,
                            endAngle: .pi,
                            clockwise: false) //左上角
                path.addLine(to: CGPoint(x: 0, y: viewHeight - radius)) //左边
                path.addArc(withCenter: CGPoint(x: radius, y: viewHeight - radius),
                            radius: radius,
                            startAngle: .pi,
                            endAngle: .pi / 2,
                            clockwise: false) //左下角
                path.close()
            }
        }
        return path
    }
    
}

extension TTPopMenuView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return configuration.menuRowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TTPopMenuCell = TTPopMenuCell(style: .default, reuseIdentifier: NSStringFromClass(TTPopMenuCell.self))
        
        var isSelected = false
        if let selectedIndex = self.selectedIndex, selectedIndex == indexPath.row {
            isSelected = true
        }
        
        cell.setupCellWith(menuItem: menuArray[indexPath.row], isSelected: isSelected, configuration: self.configuration)
        if (indexPath.row == menuArray.count-1) {
            cell.separatorInset = UIEdgeInsets.init(top: 0, left: bounds.size.width, bottom: 0, right: 0)
        } else {
            cell.separatorInset = configuration.menuSeparatorInset
        }
        cell.selectionStyle = configuration.cellSelectionStyle;
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.delegate?.menuItemDidSelect(at: indexPath.row)
    }
    
}

