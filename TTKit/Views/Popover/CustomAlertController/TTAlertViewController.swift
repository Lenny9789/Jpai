import UIKit

/// 中间弹框、底部弹框、顶部弹框
///
open class TTAlertViewController: UIViewController    {
    
    // MARK: - Declarations
    /// 弹窗关闭回调
    public typealias TTAlertViewControllerDismissBlock = (_ dismissReason: TTAlertControllerDismissReason) -> ()
    
    /// 弹窗关闭方式
    @objc public enum TTAlertControllerDismissReason : Int {
        case none = 0
        case onActionTap
        case onBackgroundTap
        case onInteractiveTransition
    }
    
    /// 弹窗样式
    @objc public enum TTAlertControllerStyle : Int {
        case alert = 0
        case actionSheet
        case notification
    }
    
    /// 按钮排列方向
    @objc public enum TTAlertActionsAxis : Int {
        case horizontal = 0
        case vertical = 1
    }
    
    /// 遮罩层样式
    @objc public enum TTAlertControllerBackgroundStyle : Int {
        case plain = 0
        case blur
    }
    
    
    // MARK: - 可供外部定制修改的属性
    // 遮罩层样式
    @objc public var backgroundStyle = TTAlertControllerBackgroundStyle.plain    {
        didSet  {
            if isViewLoaded {
                // 设置背景
                if backgroundStyle == .blur {
                    // 设置模糊背景
                    backgroundBlurView?.alpha = 1.0
                }
                else {
                    // 显示纯背景
                    backgroundBlurView?.alpha = 0.0
                }
            }
        }
    }
    /// 遮罩层颜色
    @objc public var backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.5) {
        didSet  {
            if isViewLoaded {
                backgroundColorView?.backgroundColor = backgroundColor
            }
        }
    }
    
    /// 弹窗大小限制
    @objc public var containerEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
    /// 弹窗最大宽度
    @objc public var containerMaxWidth: CGFloat = 500
    /// 弹窗圆角
    @objc public var containerCornerRadius: CGFloat = 14 {
        didSet  {
            if isViewLoaded {
                containerView?.layer.cornerRadius = containerCornerRadius
            }
        }
    }
    /// 弹窗背景色
    public var containerColor: TTColor = .color(UIColor(hex: "#FFFFFF")) {
        didSet  {
            if isViewLoaded {
                switch containerColor {
                case .color(let color):
                    containerView?.backgroundColor = color
                    tableView?.backgroundColor = color
                    
                #if canImport(SwiftTheme)
                case .themeColor(let themeColor):
                    containerView?.theme_backgroundColor = themeColor
                    tableView?.theme_backgroundColor = themeColor
                #endif
                }
            }
        }
    }
    
    /// 标题 字体
    public var titleFont: UIFont = UIFont.fontMedium(fontSize: 17)
    /// 标题 颜色
    public var titleColor: TTColor = .color(UIColor(hex: "#333333"))
    /// 副标题 字体
    public var subtitleFont: UIFont = UIFont.fontMedium(fontSize: 15)
    /// 副标题 颜色
    public var subtitleColor: TTColor = .color(UIColor(hex: "#333333"))
    /// 正文 字体
    public var messageFont: UIFont = UIFont.fontRegular(fontSize: 17)
    /// 正文 颜色
    public var messageColor: TTColor = .color(UIColor(hex: "#333333"))
    /// 单选框 字体
    public var radioFont: UIFont = UIFont.fontRegular(fontSize: 14)
    /// 单选框 颜色
    public var radioColor: TTColor = .color(UIColor(hex: "#999999"))
    /// 单选框 未选中状态图片
    public var radioNormalImage: UIImage?
    /// 单选框 选中状态图片
    public var radioSelectedImage: UIImage?
    /// 文本 周围间距
    public var textEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 22, left: 30, bottom: 35, right: 30)
    /// 副标题 顶部间距
    public var subtitleTopSpace: CGFloat = 30
    /// 正文 顶部间距
    public var messageTopSpace: CGFloat = 30
    /// 单选框 顶部间距
    public var radioTopSpace: CGFloat = 15
    /// 单选框是否被选中
    public var isRadioSelected: Bool = false

    /// 按钮排列方向
    @objc public var actionsAxis: TTAlertActionsAxis = .horizontal
    /// 按钮列表周围间距
    @objc public var actionsContainerEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    /// 按钮之间的间距
    @objc public var actionSpace: CGFloat = 0
    /// 按钮高度
    @objc public var actionHeight: CGFloat = 44
    /// 是否可点击按钮关闭弹窗
    public var shouldDismissOnActionItem: Bool = true
    
    /// 是否可点击外侧背景关闭弹窗
    @objc public var shouldDismissOnBackgroundTap: Bool = true  {
        didSet  {
            interactiveTransitionDelegate?.enableInteractiveTransition = shouldDismissOnBackgroundTap
        }
    }
    
    /// 需要接受手势处理的视图Tag
    public var receiveTouchViewTag: NSNumber?
    
    /// 弹窗样式
    public internal(set) var preferredStyle = TTAlertControllerStyle(rawValue: 0)    {
        didSet  {
            DispatchQueue.main.async {
                if self.preferredStyle == .notification {
                    if #available(iOS 11.0, *) {
                        self.mainViewTopConstraint?.constant = 0
                        self.mainViewBottomConstraint?.constant = self.view.safeAreaInsets.bottom
                        
                        if self.containerEdgeInsets.top == 0 {
                            self.containerViewTopConstraint?.constant = 0
                        } else {
                            self.containerViewTopConstraint?.constant = self.view.safeAreaInsets.top + self.containerEdgeInsets.top
                        }
                    }
                    
                    self.containerViewTopConstraint?.isActive = true
                    self.containerViewBottomConstraint?.isActive = false
                    self.containerViewCenterYConstraint?.isActive = false
                    self.containerViewLeadingConstraint?.constant = self.containerEdgeInsets.left
                    self.containerViewTrailingConstraint?.constant = abs(self.containerEdgeInsets.right)
                    
                    self.tableViewWidthConstraint?.constant = self.containerMaxWidth
                    self.tableViewLeadingConstraint?.priority = UILayoutPriority(rawValue: 751)
                    self.tableViewTrailingConstraint?.priority = UILayoutPriority(rawValue: 751)
                    
                    if #available(iOS 11.0, *) {
                        // NOTE: 对于 iOS 11，我们不需要调整状态栏，因为SafeAreaLayoutGuide会自动管理它
                    } else {
                        // 对于 iOS 8、9 和 10，tableView顶部留出状态栏的高度空间
                        if let tableView = self.tableView   {
                            let statusbarHeight : CGFloat = self.topLayoutGuide.length
                            tableView.contentInset = UIEdgeInsets.init(top: statusbarHeight, left: tableView.contentInset.left, bottom: tableView.contentInset.bottom, right: tableView.contentInset.right)
                            tableView.scrollIndicatorInsets = tableView.contentInset
                        }
                    }
                }
                else if self.preferredStyle == .alert   {
                    if #available(iOS 11.0, *) {
                        self.mainViewTopConstraint?.constant = self.view.safeAreaInsets.top
                        self.mainViewBottomConstraint?.constant = self.view.safeAreaInsets.bottom
                    }
                    
                    self.containerViewTopConstraint?.isActive = false
                    self.containerViewBottomConstraint?.isActive = false
                    self.containerViewCenterYConstraint?.isActive = true
                    self.containerViewLeadingConstraint?.constant = self.containerEdgeInsets.left
                    self.containerViewTrailingConstraint?.constant = abs(self.containerEdgeInsets.right)
                    
                    self.tableViewWidthConstraint?.constant = self.containerMaxWidth
                    self.tableViewLeadingConstraint?.priority = UILayoutPriority(rawValue: 751)
                    self.tableViewTrailingConstraint?.priority = UILayoutPriority(rawValue: 751)
                }
                else if self.preferredStyle == .actionSheet {
                    if #available(iOS 11.0, *) {
                        self.mainViewTopConstraint?.constant = self.view.safeAreaInsets.top
                        self.mainViewBottomConstraint?.constant = self.view.safeAreaInsets.bottom
                    }
                    
                    self.containerViewTopConstraint?.isActive = false
                    self.containerViewBottomConstraint?.isActive = true
                    self.containerViewCenterYConstraint?.isActive = false
                    self.containerViewLeadingConstraint?.constant = self.containerEdgeInsets.left
                    self.containerViewTrailingConstraint?.constant = abs(self.containerEdgeInsets.right)
                    
                    self.tableViewWidthConstraint?.constant = self.containerMaxWidth
                    self.tableViewLeadingConstraint?.priority = UILayoutPriority(rawValue: 751)
                    self.tableViewTrailingConstraint?.priority = UILayoutPriority(rawValue: 751)
                }
                
                // Layout Full View
                self.view.layoutIfNeeded()
                
                // 需要reloadData tableView，否则tableView的宽度未能正确更新，导致列表cell`TTAlertTextCell`中`titleLabel`高度莫名其妙被挤压
                self.tableView?.reloadData()
            }
        }
    }
        
    /// Header
    internal var _headerView : UIView?
    @objc public var headerView: UIView?  {
        set {
            self.setHeaderView(newValue, shouldUpdateContainerFrame: true, withAnimation: true)
        }
        get {
            return _headerView
        }
    }
    
    /// Middle view
    internal var _middleView : UIView?
    @objc public var middleView: UIView?  {
        set {
            self.setMiddleView(newValue, shouldUpdateContainerFrame: true, withAnimation: true)
        }
        get {
            return _middleView
        }
    }
    
    /// Footer
    internal var _footerView : UIView?
    @objc public var footerView: UIView?  {
        set {
            self.setFooterView(newValue, shouldUpdateContainerFrame: true, withAnimation: true)
        }
        get {
            return _footerView
        }
    }
    
    
    // MARK: Private / Internal
    /// 背景颜色视图
    internal var backgroundColorView: UIView?
    /// 背景模糊视图
    internal var backgroundBlurView: UIVisualEffectView?
    /// 内容容器视图
    internal var containerView: UIView?
    /// 内容展示视图
    open var tableView: UITableView?
    
    /// title
    internal var titleString: String?
    /// subtitle
    internal var subtitleString: NSAttributedString?
    /// message
    internal var messageString: String?
    /// radio
    internal var radioString: String?
    /// 按钮列表
    internal var actionList = [TTAlertAction]()
    /// 关闭回调
    internal var dismissHandler: TTAlertViewControllerDismissBlock?
    /// 键盘高度
    internal var keyboardHeight: CGFloat = 0.0   {
        didSet  {
            if keyboardHeight != oldValue {
                var safeAreaBottomInset : CGFloat = 0.0
                if #available(iOS 11.0, *) {
                    safeAreaBottomInset = view.safeAreaInsets.bottom
                }
                
                // 更新主视图底部约束
                mainViewBottomConstraint?.constant = max(keyboardHeight, safeAreaBottomInset)
            }
        }
    }
    
    // 视图控制器交互式代理
    internal var transitionDelegate : UIViewControllerTransitioningDelegate?
    internal var interactiveTransitionDelegate : TTAlertBaseInteractiveTransition?
    
    /// 视图约束
    internal var mainViewTopConstraint: NSLayoutConstraint?
    internal var mainViewBottomConstraint: NSLayoutConstraint?
    internal var containerViewTopConstraint: NSLayoutConstraint?
    internal var containerViewBottomConstraint: NSLayoutConstraint?
    internal var containerViewLeadingConstraint: NSLayoutConstraint?
    internal var containerViewTrailingConstraint: NSLayoutConstraint?
    internal var containerViewCenterYConstraint: NSLayoutConstraint?
    internal var tableViewLeadingConstraint: NSLayoutConstraint?
    internal var tableViewTrailingConstraint: NSLayoutConstraint?
    internal var tableViewWidthConstraint: NSLayoutConstraint?
    internal var tableViewHeightConstraint: NSLayoutConstraint?

    
    // MARK: - Dealloc
    deinit {
        // Remove KVO
        tableView?.removeObserver(self, forKeyPath: "contentSize")
        
        // Remove Dismiss Handler
        dismissHandler = nil
        
        debugPrintS("🟠🟠🟠🟠🟠🟠🟠🟠🟠 \(ttClassName) 已经释放了 🟠🟠🟠🟠🟠🟠🟠🟠🟠")
    }
    
    // MARK: - Initialization Methods
    @objc public class func alertController(title: String?,
                                            message: String?,
                                            preferredStyle: TTAlertControllerStyle,
                                            didDismissAlertHandler dismiss: TTAlertViewControllerDismissBlock?) -> TTAlertViewController {
        return TTAlertViewController.alertController(title: title,
                                                     subtitle: nil,
                                                     message: message,
                                                     radio: nil,
                                                     preferredStyle: preferredStyle,
                                                     headerView: nil,
                                                     middleView: nil,
                                                     footerView: nil,
                                                     receiveTouchViewTag: nil,
                                                     didDismissAlertHandler: dismiss)
    }
    
    @objc public class func alertController(title: String?,
                                            subtitle: NSAttributedString?,
                                            message: String?,
                                            radio: String?,
                                            preferredStyle: TTAlertControllerStyle,
                                            headerView: UIView?,
                                            middleView: UIView?,
                                            footerView: UIView?,
                                            receiveTouchViewTag: NSNumber?,
                                            didDismissAlertHandler dismiss: TTAlertViewControllerDismissBlock?) -> TTAlertViewController {
        return TTAlertViewController.init(title: title,
                                          subtitle: subtitle,
                                          message: message,
                                          radio: radio,
                                          preferredStyle: preferredStyle,
                                          headerView: headerView,
                                          middleView: middleView,
                                          footerView: footerView,
                                          receiveTouchViewTag: receiveTouchViewTag,
                                          didDismissAlertHandler: dismiss)
    }
    
    @objc public convenience init(title: String?,
                                  message: String?,
                                  preferredStyle: TTAlertControllerStyle,
                                  didDismissAlertHandler dismiss: TTAlertViewControllerDismissBlock?) {
        self.init(title: title,
                  subtitle: nil,
                  message: message,
                  radio: nil,
                  preferredStyle: preferredStyle,
                  headerView: nil,
                  middleView: nil,
                  footerView: nil,
                  receiveTouchViewTag: nil,
                  didDismissAlertHandler: dismiss)
    }
    
    @objc public convenience init(title: String?,
                                  subtitle: NSAttributedString?,
                                  message: String?,
                                  radio: String?,
                                  preferredStyle: TTAlertControllerStyle,
                                  headerView: UIView?,
                                  middleView: UIView?,
                                  footerView: UIView?,
                                  receiveTouchViewTag: NSNumber?,
                                  didDismissAlertHandler dismiss: TTAlertViewControllerDismissBlock?) {
        self.init()
        
        initViews()

        self.preferredStyle = preferredStyle
        
        let backgroundStyleValue = backgroundStyle
        backgroundStyle = backgroundStyleValue
        
        let backgroundColorValue = backgroundColor
        backgroundColor = backgroundColorValue
        
        titleString = title
        subtitleString = subtitle
        messageString = message
        radioString = radio

        setHeaderView(headerView, shouldUpdateContainerFrame: false, withAnimation: false)
        setMiddleView(middleView, shouldUpdateContainerFrame: false, withAnimation: false)
        setFooterView(footerView, shouldUpdateContainerFrame: false, withAnimation: false)
        
        self.receiveTouchViewTag = receiveTouchViewTag
        
        dismissHandler = dismiss
        
        // 预加载视图
        if #available(iOS 9.0, *) {
            loadViewIfNeeded()
        } else {
            view.backgroundColor = UIColor.clear
        }
        
        // 自定义弹出动画
        modalPresentationStyle = .custom
        if self.preferredStyle == .notification {
            interactiveTransitionDelegate = TTAlertNotificationInteractiveTransition(modalViewController: self,
                                                                                     swipeGestureView: containerView,
                                                                                     contentScrollView: tableView)
            transitioningDelegate = interactiveTransitionDelegate
        }
        else if self.preferredStyle == .alert   {
            transitionDelegate = TTAlertPopupTransition()
            transitioningDelegate = transitionDelegate
        }
        else if self.preferredStyle == .actionSheet {
            interactiveTransitionDelegate =  TTAlertActionSheetInteractiveTransition(modalViewController: self,
                                                                                     swipeGestureView: containerView,
                                                                                     contentScrollView: tableView)
            transitioningDelegate = interactiveTransitionDelegate
        }
        interactiveTransitionDelegate?.delegate = self
        
        // 更新背景点击
        let shouldDismissOnBackgroundTapValue = shouldDismissOnBackgroundTap
        shouldDismissOnBackgroundTap = shouldDismissOnBackgroundTapValue
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        loadVariables()
        loadDisplayContent()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        interactiveTransitionDelegate?.contentScrollView = tableView
        
        // 更新UI
        updateUI(withAnimation: false)
    }
    
    ///.  View Rotation / Size Change Method
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // 此处在屏幕旋转前执行
        coordinator.animate(alongsideTransition: {(_ context: UIViewControllerTransitionCoordinatorContext) -> Void in
            // 此处在旋转期间执行
            self.updateUI(withAnimation: false)
        }, completion: {(_ context: UIViewControllerTransitionCoordinatorContext) -> Void in
            // 此处在旋转完成后执行
        })
    }
    
    // MARK: - Helper Methods
    /// 创建视图
    internal func initViews() {
        backgroundColorView = UIView()
        
        let blurEffect: UIBlurEffect = UIBlurEffect(style: .dark)
        backgroundBlurView = UIVisualEffectView(effect: blurEffect)
        
        let mainView = UIView()
        
        containerView = UIView()
        containerView!.clipsToBounds = true

        tableView = UITableView(frame: .zero, style: .plain)
        tableView!.separatorStyle = .none
        tableView!.dataSource = self
        tableView!.delegate = self
        
        view.addSubview(backgroundColorView!)
        view.addSubview(backgroundBlurView!)
        view.addSubview(mainView)
        mainView.addSubview(containerView!)
        containerView!.addSubview(tableView!)
        
        backgroundColorView!.translatesAutoresizingMaskIntoConstraints = false
        backgroundBlurView!.translatesAutoresizingMaskIntoConstraints = false
        mainView.translatesAutoresizingMaskIntoConstraints = false
        containerView!.translatesAutoresizingMaskIntoConstraints = false
        tableView!.translatesAutoresizingMaskIntoConstraints = false
        
        //================================================================

        /// backgroundColorView -> View
        let backgroundColorViewTop = NSLayoutConstraint.init(item: backgroundColorView!, attribute: .top, relatedBy: .equal, toItem: view!, attribute: .top, multiplier: 1.0, constant: 0)
        let backgroundColorViewBottom = NSLayoutConstraint.init(item: view!, attribute: .bottom, relatedBy: .equal, toItem: backgroundColorView!, attribute: .bottom, multiplier: 1.0, constant: 0)
        let backgroundColorViewLeading = NSLayoutConstraint.init(item: backgroundColorView!, attribute: .leading, relatedBy: .equal, toItem: view!, attribute: .leading, multiplier: 1.0, constant: 0)
        let backgroundColorViewTrailing = NSLayoutConstraint.init(item: view!, attribute: .trailing, relatedBy: .equal, toItem: backgroundColorView!, attribute: .trailing, multiplier: 1.0, constant: 0)

        NSLayoutConstraint.activate([
            backgroundColorViewTop,
            backgroundColorViewBottom,
            backgroundColorViewLeading,
            backgroundColorViewTrailing
        ])
        
        //================================================================
        
        /// backgroundBlurView -> View
        let backgroundBlurViewTop = NSLayoutConstraint.init(item: backgroundBlurView!, attribute: .top, relatedBy: .equal, toItem: view!, attribute: .top, multiplier: 1.0, constant: 0)
        let backgroundBlurViewBottom = NSLayoutConstraint.init(item: view!, attribute: .bottom, relatedBy: .equal, toItem: backgroundBlurView!, attribute: .bottom, multiplier: 1.0, constant: 0)
        let backgroundBlurViewLeading = NSLayoutConstraint.init(item: backgroundBlurView!, attribute: .leading, relatedBy: .equal, toItem: view!, attribute: .leading, multiplier: 1.0, constant: 0)
        let backgroundBlurViewTrailing = NSLayoutConstraint.init(item: view!, attribute: .trailing, relatedBy: .equal, toItem: backgroundBlurView!, attribute: .trailing, multiplier: 1.0, constant: 0)

        NSLayoutConstraint.activate([
            backgroundBlurViewTop,
            backgroundBlurViewBottom,
            backgroundBlurViewLeading,
            backgroundBlurViewTrailing
        ])
        
        //================================================================

        /// mainView -> View
        let mainViewTop = NSLayoutConstraint.init(item: mainView, attribute: .top, relatedBy: .equal, toItem: view!, attribute: .top, multiplier: 1.0, constant: 0)
        let mainViewBottom = NSLayoutConstraint.init(item: view!, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let mainViewLeading = NSLayoutConstraint.init(item: mainView, attribute: .leading, relatedBy: .equal, toItem: view!, attribute: .leading, multiplier: 1.0, constant: 0)
        let mainViewTrailing = NSLayoutConstraint.init(item: view!, attribute: .trailing, relatedBy: .equal, toItem: mainView, attribute: .trailing, multiplier: 1.0, constant: 0)

        NSLayoutConstraint.activate([
            mainViewTop,
            mainViewBottom,
            mainViewLeading,
            mainViewTrailing
        ])
        
        self.mainViewTopConstraint = mainViewTop
        self.mainViewBottomConstraint = mainViewBottom

        //------------------------------------
        
        /// containerView -> mainView
        let containerViewTop = NSLayoutConstraint.init(item: containerView!, attribute: .top, relatedBy: .equal, toItem: mainView, attribute: .top, multiplier: 1.0, constant: containerEdgeInsets.top)
        let containerViewTopGreaterThan = NSLayoutConstraint.init(item: containerView!, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: mainView, attribute: .top, multiplier: 1.0, constant: 30)
        let containerViewBottom = NSLayoutConstraint.init(item: mainView, attribute: .bottom, relatedBy: .equal, toItem: containerView!, attribute: .bottom, multiplier: 1.0, constant: abs(containerEdgeInsets.bottom))
        let containerViewBottomGreaterThan = NSLayoutConstraint.init(item: mainView, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: containerView!, attribute: .bottom, multiplier: 1.0, constant: 30)
        let containerViewLeading = NSLayoutConstraint.init(item: containerView!, attribute: .leading, relatedBy: .equal, toItem: mainView, attribute: .leading, multiplier: 1.0, constant: containerEdgeInsets.left)
        let containerViewTrailing = NSLayoutConstraint.init(item: mainView, attribute: .trailing, relatedBy: .equal, toItem: containerView!, attribute: .trailing, multiplier: 1.0, constant: abs(containerEdgeInsets.right))
        let containerViewCenterX = NSLayoutConstraint.init(item: containerView!, attribute: .centerX, relatedBy: .equal, toItem: mainView, attribute: .centerX, multiplier: 1.0, constant: 0)
        let containerViewCenterY = NSLayoutConstraint.init(item: containerView!, attribute: .centerY, relatedBy: .equal, toItem: mainView, attribute: .centerY, multiplier: 1.0, constant: 0)
        ///
        containerViewTopGreaterThan.priority = UILayoutPriority(rawValue: 991)
        containerViewBottomGreaterThan.priority = UILayoutPriority(rawValue: 990)
        containerViewLeading.priority = UILayoutPriority(rawValue: 750)
        containerViewTrailing.priority = UILayoutPriority(rawValue: 750)
        
        NSLayoutConstraint.activate([
            containerViewTop,
            containerViewTopGreaterThan,
            containerViewBottom,
            containerViewBottomGreaterThan,
            containerViewLeading,
            containerViewTrailing,
            containerViewCenterX,
            containerViewCenterY
        ])
        
        self.containerViewTopConstraint = containerViewTop
        self.containerViewBottomConstraint = containerViewBottom
        self.containerViewLeadingConstraint = containerViewLeading
        self.containerViewTrailingConstraint = containerViewTrailing
        self.containerViewCenterYConstraint = containerViewCenterY

        //------------------------------------

        /// tableView -> containerView
        let tableViewTop = NSLayoutConstraint.init(item: tableView!, attribute: .top, relatedBy: .equal, toItem: containerView!, attribute: .top, multiplier: 1.0, constant: 0)
        let tableViewBottom = NSLayoutConstraint.init(item: containerView!, attribute: .bottom, relatedBy: .equal, toItem: tableView!, attribute: .bottom, multiplier: 1.0, constant: 0)
        let tableViewLeading = NSLayoutConstraint.init(item: tableView!, attribute: .leading, relatedBy: .equal, toItem: containerView!, attribute: .leading, multiplier: 1.0, constant: 0)
        let tableViewTrailing = NSLayoutConstraint.init(item: containerView!, attribute: .trailing, relatedBy: .equal, toItem: tableView!, attribute: .trailing, multiplier: 1.0, constant: 0)
        let tableViewCenterX = NSLayoutConstraint.init(item: tableView!, attribute: .centerX, relatedBy: .equal, toItem: containerView!, attribute: .centerX, multiplier: 1.0, constant: 0)
        /// tableView Self
        let tableViewWidthLessThan = NSLayoutConstraint.init(item: tableView!, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: containerMaxWidth)
        let tableViewHeight = NSLayoutConstraint.init(item: tableView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 200)
        ///
        tableViewLeading.priority = UILayoutPriority(rawValue: 751)
        tableViewTrailing.priority = UILayoutPriority(rawValue: 751)
        tableViewHeight.priority = UILayoutPriority(rawValue: 900)

        NSLayoutConstraint.activate([
            tableViewTop,
            tableViewBottom,
            tableViewLeading,
            tableViewTrailing,
            tableViewCenterX,
            tableViewWidthLessThan,
            tableViewHeight
        ])
        
        self.tableViewLeadingConstraint = tableViewLeading
        self.tableViewTrailingConstraint = tableViewTrailing
        self.tableViewWidthConstraint = tableViewWidthLessThan
        self.tableViewHeightConstraint = tableViewHeight
    }
    
    // MARK: - View Life Cycle Methods
    internal func loadVariables() {
        // 监听键盘事件
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // 监听UITextField & UITextView通知
        NotificationCenter.default.addObserver(self, selector: #selector(textViewOrTextFieldDidBeginEditing(_:)), name: UITextField.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewOrTextFieldDidBeginEditing(_:)), name: UITextView.textDidBeginEditingNotification, object: nil)
        
        tableView?.register(TTAlertTextCell.self, forCellReuseIdentifier: NSStringFromClass(TTAlertTextCell.self))
        tableView?.register(TTAlertCustomCell.self, forCellReuseIdentifier: NSStringFromClass(TTAlertCustomCell.self))
        tableView?.register(TTAlertActionCell.self, forCellReuseIdentifier: NSStringFromClass(TTAlertActionCell.self))

        // 监听contentSize
        tableView?.addObserver(self, forKeyPath: "contentSize", options: [.new, .old, .prior], context: nil)
    }
    
    internal func loadDisplayContent() {
        // 重新加载
        let backgroundColorValue = backgroundColor
        backgroundColor = backgroundColorValue
        
        let containerColorValue = containerColor
        switch containerColorValue {
        case .color(let color):
            containerView?.backgroundColor = color
        #if canImport(SwiftTheme)
        case .themeColor(let themeColor):
            containerView?.theme_backgroundColor = themeColor
        #endif
        }
        
        containerView?.layer.cornerRadius = containerCornerRadius
        
        let preferredStyleValue = preferredStyle
        preferredStyle = preferredStyleValue
        
        // 在视图中添加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewDidTap))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    /// 添加按钮
    @objc public func addAction(_ action: TTAlertAction?) {
        if let action = action {
            // 每个弹窗最多只有一个取消按钮
            if action.style == .Cancel {
                for existingAction: TTAlertAction in actionList {
                    assert(existingAction.style != .Cancel, "ERROR : TTAlertViewController can only have one action with a style of TTAlertActionStyle.Cancel")
                }
            }
            actionList.append(action)
        }
        else {
            debugPrint("WARNING >>> TTAlertViewController received nil action to add. It must not be nil.")
        }
    }
    
    /// 显示弹窗
    @objc public func showAlert(_ controller: UIViewController? = nil, _ present: Bool = true) {
        let vc = controller ?? TTRouter.shared.currentViewController()
        if present {
            vc?.present(self, animated: true, completion: nil)
        } else {
            vc?.showDetailViewController(self, sender: nil)
        }
    }
    
    /// 关闭弹窗
    @objc public func dismissAlert(withAnimation animate: Bool, completion: (() -> Void)?) {
        dismissAlert(withAnimation: animate, dismissReason: .none, completion: completion)
    }
    
    /// 背景点击关闭弹窗
    internal func dismissAlertOnBackgroundTap(withAnimation animate: Bool, dismissReason: TTAlertControllerDismissReason, completion: (() -> Void)?) {
        
        dismissAlert(withAnimation: animate, dismissReason: dismissReason, completion: {() -> Void in
            // 模拟取消按钮
            for existingAction: TTAlertAction in self.actionList {
                if existingAction.style == .Cancel {
                    if let actionHandler = existingAction.handler {
                        actionHandler(existingAction)
                    }
                }
            }
            completion?()
        })
    }
    
    /// 关闭弹窗
    internal func dismissAlert(withAnimation animate: Bool,
                               dismissReason: TTAlertControllerDismissReason,
                               completion: (() -> Void)?) {
        let afterDismiss = {
            if let completion = completion {
                completion()
            }
            if let dismissHandler = self.dismissHandler {
                dismissHandler(dismissReason)
            }
        }
        
        if dismissReason != .onInteractiveTransition  {
            self.dismiss(animated: animate, completion: {() -> Void in
                afterDismiss()
            })
        } else {
            afterDismiss()
        }
    }
    
    /// 设置Header
    internal func setHeaderView(_ headerView: UIView?, shouldUpdateContainerFrame: Bool, withAnimation animate: Bool) {
        _headerView = headerView
        if let tableView = tableView    {
            tableView.tableHeaderView = self.headerView
            if shouldUpdateContainerFrame {
                updateContainerViewFrame(withAnimation: animate)
            }
        }
    }
    
    /// 设置Middle view
    internal func setMiddleView(_ middleView: UIView?, shouldUpdateContainerFrame: Bool, withAnimation animate: Bool) {
        _middleView = middleView
        if let _ = tableView    {
            if shouldUpdateContainerFrame {
                updateContainerViewFrame(withAnimation: animate)
            }
        }
    }
    
    /// 设置Footer
    internal func setFooterView(_ footerView: UIView?, shouldUpdateContainerFrame: Bool, withAnimation animate: Bool) {
        _footerView = footerView
        if let tableView = tableView    {
            tableView.tableFooterView = self.footerView
            if shouldUpdateContainerFrame {
                updateContainerViewFrame(withAnimation: animate)
            }
        }
    }
    
    /// 更新UI
    internal func updateUI(withAnimation shouldAnimate: Bool) {
        // 刷新样式
        let currentPreferredStyle = preferredStyle
        preferredStyle = currentPreferredStyle
        
        setHeaderView(headerView, shouldUpdateContainerFrame: false, withAnimation: false)
        setMiddleView(middleView, shouldUpdateContainerFrame: false, withAnimation: false)
        setFooterView(footerView, shouldUpdateContainerFrame: false, withAnimation: false)
        tableView?.reloadData()
        
        // 更新背景样式
        let currentBackgroundStyle = backgroundStyle
        backgroundStyle = currentBackgroundStyle
        
        // 更新 Container View Frame
        updateContainerViewFrame(withAnimation: shouldAnimate)
    }
    
    internal func updateContainerViewFrame(withAnimation shouldAnimate: Bool) {
        mainQueueExecuting {
            if shouldAnimate {
                UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction], animations: {[weak self] () -> Void in

                    // 更新 Container View Frame
                    self?.updateContainerViewFrame()

                    // Relayout
                    self?.view.layoutIfNeeded()

                }, completion: { _ in })
            }
            else {
                // 更新 Container View Frame
                self.updateContainerViewFrame()
            }
        }
    }
    
    internal func updateContainerViewFrame() {
        if let tableView = self.tableView   {
            // 更新TableView高度
            var tableContentHeight = tableView.contentInset.top + tableView.contentSize.height + tableView.contentInset.bottom
            if #available(iOS 11.0, *), preferredStyle == .notification {
                if self.containerEdgeInsets.top == 0 {
                    tableContentHeight = kSafeAreaTopHeight() + tableContentHeight
                }
            }
            tableViewHeightConstraint?.constant = tableContentHeight
            
            // 启用/禁用反弹效果
            if let containerView = containerView, tableView.contentSize.height <= containerView.frame.size.height + self.containerEdgeInsets.top {
                tableView.bounces = false
            }
            else {
                tableView.bounces = true
            }
        }
    }
    
    // MARK: - 手势处理
    @objc internal func viewDidTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            let tapLocation: CGPoint = gestureRecognizer.location(in: gestureRecognizer.view)
            let tapView = gestureRecognizer.view?.hitTest(tapLocation, with: nil)
            if let tapView = tapView,
                let containerView = containerView,
                tapView.isDescendant(of: containerView)
            {
                // 关闭键盘
                view.endEditing(true)
            }
            else if shouldDismissOnBackgroundTap {
                // 关闭弹窗
                dismissAlertOnBackgroundTap(withAnimation: true, dismissReason: .onBackgroundTap, completion: nil)
            }
        }
    }
    
    // 键盘显示通知
    @objc internal func keyboardWillShow(_ notification: Notification) {
        let info: [AnyHashable: Any]? = notification.userInfo
        if let info = info  {
            if let kbRect = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                if let viewRect = self.view.window?.convert(self.view.frame, from: self.view)   {
                    let intersectRect: CGRect = kbRect.intersection(viewRect)
                    if intersectRect.size.height > 0.0 {
                        
                        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.beginFromCurrentState, .curveEaseOut, .allowUserInteraction], animations: { [weak self] in
                            // Update Keyboard Height
                            self?.keyboardHeight = intersectRect.size.height
                            self?.view.layoutIfNeeded()
                        }, completion: { _ in })
                    }
                }
            }
        }
    }
    
    // 键盘隐藏通知
    @objc internal func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.beginFromCurrentState, .curveEaseOut, .allowUserInteraction], animations: {[weak self] () -> Void in
            // Update Keyboard Height
            self?.keyboardHeight = 0.0
            self?.view.layoutIfNeeded()
        }, completion: { _ in })
    }
    
    // 文本开始编辑通知
    @objc internal func textViewOrTextFieldDidBeginEditing(_ notification: Notification) {
        if let notificationObject = notification.object, (notificationObject is UITextField || notificationObject is UITextView) {
            
            DispatchQueue.main.async    {
                let view: UIView? = (notificationObject as? UIView)
                if let view = view  {
                    
                    // Keyboard becomes visible
                    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.beginFromCurrentState, .curveEaseOut, .allowUserInteraction], animations: {[weak self] () -> Void in
                        // Get Location Of View inside Table View
                        let visibleRect: CGRect? = self?.tableView?.convert(view.frame, from: view.superview)
                        // Scroll To Visible Rect
                        self?.tableView?.scrollRectToVisible(visibleRect!, animated: false)
                    }, completion: { _ in })
                }
            }
        }
    }
    
    // KVO - contentSize
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "contentSize") {
            updateContainerViewFrame(withAnimation: false)
        }
    }
}


// MARK: - UITableViewDataSource & TTAlertActionCellDelegate
extension TTAlertViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if let titleString = self.titleString, !titleString.isEmpty {
                return 1
            }
            if let messageString = self.messageString, !messageString.isEmpty  {
                return 1
            }
            
        case 1:
            if self.middleView != nil {
                return 1
            }
            
        case 2:
            if self.actionList.count > 0 {
                return 1
            }
            
        default:
            break
        }
        
        return 0
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(TTAlertTextCell.self))
            let titleSubtitleCell : TTAlertTextCell? = cell as? TTAlertTextCell
            
            titleSubtitleCell?.delegate = self
            titleSubtitleCell?.setTitle(titleString,
                                        titleFont: titleFont,
                                        titleColor: titleColor,
                                        subtitle: subtitleString,
                                        subtitleFont: subtitleFont,
                                        subtitleColor: subtitleColor,
                                        message: messageString,
                                        messageFont: messageFont,
                                        messageColor: messageColor,
                                        radioText: radioString,
                                        radioFont: radioFont,
                                        radioColor: radioColor,
                                        radioNormalImage: radioNormalImage,
                                        radioSelectedImage: radioSelectedImage,
                                        isRadioSelected: isRadioSelected,
                                        textEdgeInsets: textEdgeInsets,
                                        subtitleTop: subtitleTopSpace,
                                        messageTop: messageTopSpace,
                                        radioTop: radioTopSpace,
                                        actionsCount: self.actionList.count)
            
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(TTAlertCustomCell.self))
            let customCell : TTAlertCustomCell? = cell as? TTAlertCustomCell
            if let middleView = self.middleView {
                customCell?.setCustomView(middleView)
            }
            
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(TTAlertActionCell.self))
            let actionCell : TTAlertActionCell? = cell as? TTAlertActionCell
            
            actionCell?.delegate = self
            actionCell?.setActionList(self.actionList, actionsAxis: self.actionsAxis, actionsEdgeInsets: self.actionsContainerEdgeInsets, actionSpace: self.actionSpace)

        default:
            break
        }
        
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension TTAlertViewController: UIGestureRecognizerDelegate  {
   
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchView = touch.view,
           let receiveTouchViewTag = self.receiveTouchViewTag,
           touchView.isAnySuperViewTagEqual(to: NSInteger(truncating: receiveTouchViewTag)) {
            return false
        }
        return true
    }
}

// MARK: - TTAlertTextCellDelegate
extension TTAlertViewController: TTAlertTextCellDelegate  {
    
    public func alertTextCell(_ cell: TTAlertTextCell, didClickRadio isSelected: Bool) {
        isRadioSelected = isSelected
    }
}

// MARK: - TTAlertActionCellDelegate
extension TTAlertViewController: TTAlertActionCellDelegate  {
    
    public func alertActionCell(_ cell: TTAlertActionCell, didClickAction action: TTAlertAction?) {
        func handleAction() {
            if let action = action, let actionHandler = action.handler {
                action.respIsRadioSelected = self.isRadioSelected
                actionHandler(action)
            }
        }
        if shouldDismissOnActionItem {
            dismissAlert(withAnimation: true, dismissReason: .onActionTap, completion: { () -> Void in
                handleAction()
            })
        } else {
            handleAction()
        }
    }
}

// MARK: - TTAlertInteractiveTransitionDelegate
extension TTAlertViewController: TTAlertInteractiveTransitionDelegate  {
    
    public func alertViewControllerTransitionDidFinish(_ transition: TTAlertBaseInteractiveTransition) {
        // 模拟背景点击
        dismissAlertOnBackgroundTap(withAnimation: true, dismissReason: .onInteractiveTransition, completion: { [weak self] in
            self?.interactiveTransitionDelegate = nil
        })
    }
}
