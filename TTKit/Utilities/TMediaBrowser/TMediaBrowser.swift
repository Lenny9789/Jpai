import UIKit
import Lantern
import ZFPlayer

/// 展示实体类型
enum TBrowseEntity {
    /// 本地图片
    case localImage(UIImage)
    /// 网络图片url
    case webImageUrl(URL)
    /// 视频url
    case videoUrl(URL)
    
    var isVideo: Bool {
        switch self {
        case .localImage(_): return false
        case .webImageUrl(_): return false
        case .videoUrl(_): return true
        }
    }
}

/// 通用 图片 / 视频 浏览器
///
class TMediaBrowser: Lantern {
    
    // MARK: - Properties
    /// 回调
    var dismissClosure: TTVoidBlock?

    /// 数据源
    var dataSource: [TBrowseEntity] = []

    /// 播放器
    var playerMgr: PlayerControlMgr?
    var isResetPlayUrl: Bool = true
    var lastPlayIndex: Int?
    
    /// toolbar样式
    var toolbarStyle: TMediaBrowserToolbar.Style = .picture {
        didSet {
            self.toolbar.style = self.toolbarStyle
            self.toolbar.isHidden = (self.toolbarStyle == .picture)
        }
    }
    
    /// 视图Appear时的时间戳
    var appearTimeStamp: TimeInterval?
    
    // MARK: - Views
    lazy var navBar: TMediaBrowserNavbar = {
        let view = TMediaBrowserNavbar()
        view.eventBlock = { [weak self] event in
            guard let `self` = self else { return }
            switch event {
            case .backTapped:
                self.dismiss()
            }
        }
        return view
    }()
    
    lazy var toolbar: TMediaBrowserToolbar = {
        let view = TMediaBrowserToolbar()
        return view
    }()
    
    var disposeBag = DisposeBag()

    // MARK: - Lifecycle
    deinit {
        debugPrint("deinit - \(self.classForCoder)")
    }
    
    override func dismiss() {
        setStatusBar(hidden: false)
        pageIndicator?.removeFromSuperview()
        dismiss(animated: false)
        dismissClosure?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(navBar)
        view.addSubview(toolbar)

        navBar.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: TMediaBrowserNavbar.viewHeight())
        toolbar.frame = CGRect(x: 0, y: self.view.bounds.size.height - TMediaBrowserToolbar.viewHeight(), width: self.view.bounds.size.width, height: TMediaBrowserToolbar.viewHeight())
        
        //应用将要进入前台
        UIApplication.rx.willEnterForeground
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                guard let playerMgr = self.playerMgr, let player = playerMgr.player else { return }
                
                if self.pageIndex >= 0 && self.pageIndex < self.dataSource.count {
                    let entity = self.dataSource[self.pageIndex]
                    if entity.isVideo {
                        if player.isFullScreen {
                            playerMgr.controlView.addToolViewToSelf()
                            self.toolbar.removeToolViewFromSelf()
                        } else {
                            playerMgr.controlView.removeToolViewFromSelf()
                            self.toolbar.addToolViewToSelf()
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("Controller生命周期：-viewWillAppear")

        // 隐藏状态栏
        UIApplication.shared.setStatusBarHidden(true, with: .fade)
        
        appearTimeStamp = Date().timeIntervalSince1970
        
        var rotationEnable = true
        if pageIndex >= 0 && pageIndex < self.dataSource.count {
            let entity = self.dataSource[pageIndex]
            rotationEnable = entity.isVideo
        }
//        kAppDelegate.allowOrientationRotation = rotationEnable
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
                
        super.viewWillDisappear(animated)
        debugPrint("Controller生命周期：-viewWillDisappear")

        tt_lastClassName = ttClassName

        // 恢复状态栏
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
        
//        kAppDelegate.allowOrientationRotation = false
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    // MARK: - Decoration View
    private func toggleDecorationViewHidden() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let `self` = self else { return }
            if self.navBar.y != -TMediaBrowserToolbar.viewHeight() {
                self.navBar.y = -TMediaBrowserToolbar.viewHeight()
                self.toolbar.y = self.view.bounds.size.height
            } else {
                self.navBar.y = 0
                self.toolbar.y = self.view.bounds.size.height - TMediaBrowserToolbar.viewHeight()
            }
        }
    }
    
    private var shouldRestoreDecorationViewPosition = false
    private func checkHideDecorationView() {
        self.shouldRestoreDecorationViewPosition = false
        if self.navBar.y != -TMediaBrowserToolbar.viewHeight() {
            self.shouldRestoreDecorationViewPosition = true
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let `self` = self else { return }
                self.navBar.y = -TMediaBrowserToolbar.viewHeight()
                self.toolbar.y = self.view.bounds.size.height
            }
        }
    }
    private func checkShowDecorationView() {
        if shouldRestoreDecorationViewPosition {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let `self` = self else { return }
                self.navBar.y = 0
                self.toolbar.y = self.view.bounds.size.height - TMediaBrowserToolbar.viewHeight()
            }
        }
    }
    
    private func setupToolView() {
        if let playerMgr = self.playerMgr {
            self.toolbar.toolView = playerMgr.controlView.toolView
            self.toolbar.style = self.toolbarStyle
            playerMgr.controlView.viewWillChangeBlock = { [weak self] isFullScreen in
                guard let `self` = self else { return }
                if self.pageIndex >= 0 && self.pageIndex < self.dataSource.count {
                    let entity = self.dataSource[self.pageIndex]
                    if entity.isVideo {
                        if isFullScreen {
                            self.toolbar.removeToolViewFromSelf()
                        } else {
                            self.toolbar.addToolViewToSelf()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Show Browser
    func showBrowser(with entities: Array<TBrowseEntity>,
                     index: Int?,
                     projectiveView: UIImageView?,
                     playerMgr: PlayerControlMgr?,
                     isResetPlayUrl: Bool,
                     showPageIndicator: Bool = false,
                     onDismiss: TTVoidBlock?) {
        guard entities.count > 0 else {
            debugPrint("entities数据源为空")
            return
        }
        
        lastPlayIndex = index
        self.playerMgr = playerMgr
        self.isResetPlayUrl = isResetPlayUrl
        dismissClosure = onDismiss
        
        self.setupToolView()
        
        /// 数据源
        dataSource.append(contentsOf: entities)

        /// 实时提供图片总量
        self.numberOfItems = { [weak self] in
            guard let `self` = self else { return 0 }
            return self.dataSource.count
        }
        
        self.cellClassAtIndex = { [weak self] index in
            guard let `self` = self else { return TMediaImageCell.self }
            let entity = self.dataSource[index]
            if entity.isVideo {
                return TMediaVideoCell.self
            } else {
                return TMediaImageCell.self
            }
        }
        
        /// 刷新项视图
        self.reloadCellAtIndex = { [weak self] context in
            guard let `self` = self else { return }
            debugPrint("加载列表Cell！")
            let entity = self.dataSource[context.index]
            switch entity {
            case .localImage(let image):
                debugPrint("加载本地图片Cell")
                let lanternCell = context.cell as? TMediaImageCell
                lanternCell?.imageView.image = image
                lanternCell?.tapClosure = { [weak self] in
                    self?.toggleDecorationViewHidden()
                }
                lanternCell?.panBeginClosure = { [weak self] in
                    self?.checkHideDecorationView()
                }
                lanternCell?.panEndClosure = { [weak self] in
                    self?.checkShowDecorationView()
                }
                self.playerMgr?.stop()
                
            case .webImageUrl(let url):
                debugPrint("加载网络图片Cell")
                let lanternCell = context.cell as? TMediaImageCell
                    lanternCell?.imageView.setImage(
                        withURL: url,
                        placeholderImage: nil
                    )
                lanternCell?.tapClosure = { [weak self] in
                    self?.toggleDecorationViewHidden()
                }
                lanternCell?.panBeginClosure = { [weak self] in
                    self?.checkHideDecorationView()
                }
                lanternCell?.panEndClosure = { [weak self] in
                    self?.checkShowDecorationView()
                }
                self.playerMgr?.stop()
                
            case .videoUrl(let url):
                debugPrint("加载视频Cell")
                let lanternCell = context.cell as? TMediaVideoCell
                if context.index != context.currentIndex {
                    return
                }
                
                lanternCell?.relayoutViewsInDelay() { [weak self] in
                    guard let `self` = self else { return }
                    debugPrint("视频播放-Browser开始")
                    if self.playerMgr == nil {
                        self.playerMgr = PlayerControlMgr()
                        self.playerMgr?.createPlayer(scene: .normal(containerView: lanternCell!.videoPlayView))
                        self.setupToolView()
                    }
                    self.playerMgr?.addPlayerView(toContainerView: lanternCell!.videoPlayView)
                    
                    var needSetPlayURL = false
                    if self.isResetPlayUrl {
                        self.isResetPlayUrl = false
                        needSetPlayURL = true
                    }
                    if context.index != self.lastPlayIndex {
                        needSetPlayURL = true
                    }
                    
                    if needSetPlayURL {
                        debugPrint("视频播放-设置URL准备播放")
                        self.playerMgr?.setAssetURL(url)
                        self.playerMgr?.playTheIndex()
                    } else {
                        debugPrint("视频播放-开始播放")
                        self.playerMgr?.play()
                    }
                    self.lastPlayIndex = context.index
                }
                
                // 获取视频首帧图信息
                lanternCell?.loadVideoCropPicture(
                    with: url,
                    isShowPicture: false,
                    isShowLoading: true)
                {
                }
                
                lanternCell?.tapClosure = { [weak self] in
                    self?.toggleDecorationViewHidden()
                }
                lanternCell?.panBeginClosure = { [weak self] in
                    self?.checkHideDecorationView()
                }
                lanternCell?.panEndClosure = { [weak self] in
                    self?.checkShowDecorationView()
                }
            }
        }

        self.cellWillAppear = { [weak self] cell, index in
            guard let `self` = self else { return }
            let entity = self.dataSource[index]
            if entity.isVideo {
                debugPrint("视频播放-Browser恢复")
                self.playerMgr?.togglePlayerControl(isPlay: true)
                self.playerMgr?.controlView.updatePlayOrPauseButtonState()
            }
            self.toolbarStyle = entity.isVideo ? .video : .picture
//            kAppDelegate.allowOrientationRotation = entity.isVideo
        }
        
        self.cellWillDisappear = { [weak self] cell, index in
            guard let `self` = self else { return }
            let entity = self.dataSource[index]
            if entity.isVideo {
                debugPrint("视频播放-Browser暂停")
                self.playerMgr?.togglePlayerControl(isPlay: false)
            }
        }

        // 转场动画，更丝滑的Zoom动画
        if let projectiveView = projectiveView {
            self.transitionAnimator = LanternSmoothZoomAnimator(transitionViewAndFrame: { (index, destinationView) -> LanternSmoothZoomAnimator.TransitionViewAndFrame? in
                let image = projectiveView.image
                let transitionView = UIImageView(image: image)
                transitionView.contentMode = projectiveView.contentMode
                transitionView.clipsToBounds = true
                let thumbnailFrame = projectiveView.convert(projectiveView.bounds, to: destinationView)
                return (transitionView, thumbnailFrame)
            })
        }

        /// 指定打开图片浏览器时定位到哪一页
        if let index = index {
            self.pageIndex = index
        }
        
        if showPageIndicator {
            // UIPageIndicator样式的页码指示器
            self.pageIndicator = LanternDefaultPageIndicator()
        }

        /// 显示图片浏览器
        self.show()
    }
    
}
