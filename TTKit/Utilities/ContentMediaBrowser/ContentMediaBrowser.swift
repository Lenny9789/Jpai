import UIKit
import Lantern
import ZFPlayer

/// 作品 图片 / 视频 浏览器
///
class ContentMediaBrowser: Lantern {
    
    /// 操作cell类型
    enum OperateCellType {
        case none
        /// 图片
        case image(cell: ContentBrowserImageCell?)
        /// 视频
        case video(cell: ContentBrowserVideoCell?)
    }
    
    // MARK: - Properties
    /// 回调
    var dismissClosure: TTVoidBlock? //关闭回调
//    var contentEvtHandler: DefaultContentHandler?

    /// 数据源
    var dataSource: [TBrowseEntity] = []

    weak var parentModel: ChatViewModel!
    var worksVideoFreeDuration: Int!
    var worksImageFreeCount: Int!
    var parentView: UIView?
    var parentIndexPath: IndexPath?

    /// 播放器
    var playerMgr: PlayerControlMgr?
    var isResetPlayUrl: Bool = true
    var lastPlayIndex: Int?
    
    var lastIsStatusBarHidden: Bool = false
    //var isEnterFullScreenPlayer: Bool = false
    var isPlayingWhenDisappear: Bool = false
    var isVideoPlayEnable: Bool = true
    var isCreatePlayerMgrInCurrent: Bool = false
    var isCreatedPlayer: Bool = false

    let mediaBrowserAnimator = ContentMediaBrowserAnimator()

    /// 当前视图标识
    let sourceIdentity = tt_compactUUID
    
    var curCellType: OperateCellType = .none

    /// 播放时长
    var playDuration: Int = 0
    
    /// toolbar样式
    var toolbarStyle: ContentBrowserToolbar.Style = .picture {
        didSet {
//            self.toolbar.style = self.toolbarStyle
//            self.toolbar.frame = CGRect(x: 0,
//                                        y: self.view.bounds.size.height - ContentBrowserToolbar.viewHeight(style: self.toolbarStyle),
//                                        width: self.view.bounds.size.width,
//                                        height: ContentBrowserToolbar.viewHeight(style: self.toolbarStyle))
        }
    }
    
    /// 视图Appear时的时间戳
    var appearTimeStamp: TimeInterval?
    
    // MARK: - Views
    lazy var navBar: ContentBrowserNavbar = {
        let view = ContentBrowserNavbar()
        view.eventBlock = { [weak self] event in
            guard let `self` = self else { return }
            switch event {
            case .backTapped:
                self.dismiss()
            case .buyTapped:
                    break
//                self.showPayPopup()
            case .avatarTapped:
                    break
//                self.contentEvtHandler?.coordinateToUserHome(userId: self.parentModel.author.userId, rootViewController: self)
            }
        }
        return view
    }()
    
    
    
    var disposeBag = DisposeBag()

    // MARK: - Lifecycle
    deinit {
        debugPrint("deinit - \(self.classForCoder)")
    }
    
    override func dismiss() {
        if self.playDuration > 0 {
//            self.worksVideoPlayFinished(duration: self.playDuration)
        }
        setStatusBar(hidden: false)
        pageIndicator?.removeFromSuperview()
        dismiss(animated: false)
        dismissClosure?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(navBar)

        navBar.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: ContentBrowserNavbar.viewHeight())
        
        lastIsStatusBarHidden = UIApplication.shared.isStatusBarHidden
        
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
//                            self.toolbar.removeToolViewFromSelf()
                        } else {
                            playerMgr.controlView.removeToolViewFromSelf()
//                            self.toolbar.addToolViewToSelf()
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
            rotationEnable = (entity.isVideo && self.isVideoPlayEnable)
        }
//        kAppDelegate.allowOrientationRotation = rotationEnable

        if let playerMgr = self.playerMgr {
            if isPlayingWhenDisappear {
                playerMgr.togglePlayerControl(isPlay: true)
            }
            
            playerMgr.player?.isLockedScreen = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        super.viewWillDisappear(animated)
        debugPrint("Controller生命周期：-viewWillDisappear")

        tt_lastClassName = ttClassName

//        kAppDelegate.allowOrientationRotation = false

        // 恢复状态栏
        UIApplication.shared.setStatusBarHidden(lastIsStatusBarHidden, with: .fade)
        
        if let playerMgr = self.playerMgr {
            debugPrint("视频播放-viewWillDisappear暂停")
            self.isPlayingWhenDisappear = playerMgr.isPlaying()
            playerMgr.togglePlayerControl(isPlay: false)
        }
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
            if self.navBar.y != 0 {
                self.navBar.y = 0
//                self.toolbar.y = self.view.bounds.size.height - ContentBrowserToolbar.viewHeight(style: self.toolbarStyle)
            } else {
                self.navBar.y = -ContentBrowserNavbar.viewHeight()-20
//                self.toolbar.y = self.view.bounds.size.height
            }
        }
    }
    
    private var shouldRestoreDecorationViewPosition = false
    private func checkHideDecorationView() {
        self.shouldRestoreDecorationViewPosition = false
        if self.navBar.y != -ContentBrowserNavbar.viewHeight() {
            self.shouldRestoreDecorationViewPosition = true
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let `self` = self else { return }
                self.navBar.y = -ContentBrowserNavbar.viewHeight()
//                self.toolbar.y = self.view.bounds.size.height
            }
        }
    }
    private func checkShowDecorationView() {
        if shouldRestoreDecorationViewPosition {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let `self` = self else { return }
                self.navBar.y = 0
//                self.toolbar.y = self.view.bounds.size.height - ContentBrowserToolbar.viewHeight(style: self.toolbarStyle)
            }
        }
    }
    
    // MARK: - DataSource
    private func addRemainingPictures() {
//        if self.parentModel.hasPics, let pics = self.parentModel.works.pics { //图片资源
//            for (index, pic) in pics.enumerated() {
//                if index > self.worksImageFreeCount {
//                    if let URL = URL(string: checkImageFullUrl(pic)) {
//                        dataSource.append(.webImageUrl(URL))
//                    }
//                }
//            }
//        }
    }
    
    private func setupToolView() {
        if let playerMgr = self.playerMgr {
//            self.toolbar.toolView = playerMgr.controlView.toolView
//            self.toolbar.style = self.toolbarStyle
            playerMgr.controlView.viewWillChangeBlock = { [weak self] isFullScreen in
                guard let `self` = self else { return }
                if self.pageIndex >= 0 && self.pageIndex < self.dataSource.count {
                    let entity = self.dataSource[self.pageIndex]
                    if entity.isVideo {
                        if isFullScreen {
//                            self.toolbar.removeToolViewFromSelf()
                        } else {
//                            self.toolbar.addToolViewToSelf()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Show Browser
    func showBrowser(with model: CommunityWorksModel,
                     mainView: UIView?,
                     isPicture: Bool,
                     index: Int?,
                     projectiveView: UIImageView?,
                     isResetPlayUrl: Bool,
                     onDismissClosure: TTVoidBlock?) {
        self.parentModel = model
        self.parentView = mainView
//        self.parentIndexPath = indexPath
        self.lastPlayIndex = index
        self.isResetPlayUrl = isResetPlayUrl
        self.dismissClosure = onDismissClosure
        
//        contentEvtHandler = DefaultContentHandler(entry: .browser)
//        contentEvtHandler?.dataSource = self
//        contentEvtHandler?.delegate = self
        
        ///检查创建播放器管理
        if self.playerMgr == nil {
            self.playerMgr = PlayerControlMgr()
        }
        self.isCreatePlayerMgrInCurrent = (playerMgr == nil)
        self.setupToolView()
        self.playerMgr?.controlView.playbackProgressCallback = { [weak self] (currentTime, totalTime) in
            guard let `self` = self else { return }

            self.playDuration += 1
            if self.playDuration > totalTime {
                self.playDuration = totalTime
            }
            
        }
        self.playerMgr?.controlView.playResultBlock = { [weak self] (result) in
            guard let `self` = self else { return }
            if result {
//                self.worksVideoPlaySuccessed()
            }
        }
        
        if model.img_urls.count > 0 {
            let pics = model.img_urls.components(separatedBy: ",") //图片资源
            for (index, pic) in pics.enumerated() {
                if let URL = URL(string: pic) {
                    dataSource.append(.webImageUrl(URL))
                }
            }
        }

        /// 实时提供图片总量
        self.numberOfItems = { [weak self] in
            guard let `self` = self else { return 0 }
            return self.dataSource.count
        }

        self.cellClassAtIndex = { [weak self] index in
            guard let `self` = self else { return ContentBrowserImageCell.self }
            let entity = self.dataSource[index]
            if entity.isVideo {
                return ContentBrowserVideoCell.self
            } else {
                return ContentBrowserImageCell.self
            }
        }
        
        /// 刷新项视图
        self.reloadCellAtIndex = { [weak self]  context in
            guard let `self` = self else { return }
            debugPrint("加载列表Cell！")
            let entity = self.dataSource[context.index]
            switch entity {
            case .localImage(let image):
                debugPrint("加载本地图片Cell")
                let lanternCell = context.cell as? ContentBrowserImageCell
                self.curCellType = .image(cell: lanternCell)

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
                let lanternCell = context.cell as? ContentBrowserImageCell
                self.curCellType = .image(cell: lanternCell)

                lanternCell?.imageView.setImage(
                    withURL: url,
                    placeholderImage: R.image.home_header_bg()
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
                let lanternCell = context.cell as? ContentBrowserVideoCell
                self.curCellType = .video(cell: lanternCell)
                
                lanternCell?.relayoutViewsInDelay() { [weak self] in
                    guard let `self` = self else { return }
                    if self.isVideoPlayEnable {
                        debugPrint("视频播放-Browser开始")
                        if self.isCreatePlayerMgrInCurrent {
                            if !self.isCreatedPlayer {
                                self.isCreatedPlayer = true
                                self.playerMgr?.createPlayer(scene: .normal(containerView: lanternCell!.videoPlayView))
                            }
                        }
//                        self.contentEvtHandler?.playerMgr = self.playerMgr
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
                            self.playerMgr?.setAssetURL(url)
                            self.playerMgr?.playTheIndex()
                            debugPrint("视频播放-设置URL准备播放")
                        } else {
                            self.playerMgr?.play()
                            debugPrint("视频播放-开始播放")
                        }
                        self.lastPlayIndex = context.index
                    }
                }
                
//                guard let parentModel = self.parentModel else {
//                    return
//                }
//                if let snapshotUrl = parentModel.works.video?.snapshotUrl,
//                    let snapshotUrl_ = URL(string: checkImageFullUrl(snapshotUrl)) {
//                    // 加载网络视频封面图
//                    lanternCell?.loadWebCoverUrl(url: snapshotUrl_) { }
//                }
                
                // 获取视频首帧图信息
                lanternCell?.loadVideoCropPicture(
                    with: url,
                    isShowPicture: false,
                    isShowLoading: false)
                {
                }
                
//                if parentModel.canSee == .trueValue {
//                    self.isVideoPlayEnable = true
//                    lanternCell?.blurView.isHidden = true
//                    self.toolbar.toolView?.userInteraction = .normal
//                } else {
//                    if worksVideoFreeDuration > 0 {
//                        self.isVideoPlayEnable = true
//                        lanternCell?.blurView.isHidden = true
//                        self.toolbar.toolView?.userInteraction = .onlyPlayOrPauseUserInteractionEnable
//                    } else if self.worksVideoFreeDuration == 0 {
//                        self.isVideoPlayEnable = false
//                        lanternCell?.blurView.isHidden = false
//                        self.toolbar.toolView?.userInteraction = .allUserInteractionDisable
//                    } else {
//                        self.isVideoPlayEnable = true
//                        lanternCell?.blurView.isHidden = true
//                        self.toolbar.toolView?.userInteraction = .normal
//                    }
//                }

                lanternCell?.tapClosure = { [weak self] in
                    self?.toggleDecorationViewHidden()
                }
                lanternCell?.panBeginClosure = { [weak self] in
                    self?.checkHideDecorationView()
                }
                lanternCell?.panEndClosure = { [weak self] in
                    self?.checkShowDecorationView()
                }
//                lanternCell?.payClosure = { [weak self] in
//                    self?.showPayPopup()
//                }
            }
        }

        self.cellWillAppear = { [weak self] cell, index in
            guard let `self` = self else { return }
            debugPrint("cell生命周期：-cellWillAppear")
            let entity = self.dataSource[index]
            if entity.isVideo {
                debugPrint("视频播放-Browser恢复")
                self.playerMgr?.togglePlayerControl(isPlay: true)
                self.playerMgr?.controlView.updatePlayOrPauseButtonState()
            }
            self.toolbarStyle = entity.isVideo ? .video : .picture
//            kAppDelegate.allowOrientationRotation = (entity.isVideo && self.isVideoPlayEnable)
        }
        
        self.cellWillDisappear = { [weak self] cell, index in
            debugPrint("cell生命周期：-cellWillDisappear")
            guard let `self` = self else { return }
            let entity = self.dataSource[index]
            if entity.isVideo {
                debugPrint("视频播放-Browser暂停")
                self.playerMgr?.togglePlayerControl(isPlay: false)
            }
        }
        
        /// 指定打开图片浏览器时定位到哪一页
        if let index = index {
            self.pageIndex = index
        }
        
        // 转场动画，更丝滑的Zoom动画
        if let projectiveView = projectiveView {
            mediaBrowserAnimator.transitionImage = projectiveView.image
            mediaBrowserAnimator.firstVCImageFrame = projectiveView.convert(
                projectiveView.bounds,
                to: UIApplication.shared.windows[0]
            )
        }
        show()
//        let toVC = AppNavigationController(rootVC: self)
//        toVC.modalPresentationStyle = .custom
//        toVC.modalPresentationCapturesStatusBarAppearance = false
//        toVC.transitioningDelegate = mediaBrowserAnimator
//        let from = TTRouter.shared.currentViewController()
//        from?.present(toVC, animated: true, completion: nil)
    }
    
    
    
}

// MARK: - DefaultContentHandlerDataSource
//extension ContentMediaBrowser: DefaultContentHandlerDataSource {
//
//    /// 当前视图标识
//    func contentHandler(sourceIdentityFor handler: DefaultContentHandler) -> String? {
//        return self.sourceIdentity
//    }
//
//}

// MARK: - DefaultContentHandlerDelegate
//extension ContentMediaBrowser: DefaultContentHandlerDelegate {
//
//    /// 作品媒体浏览器支付成功
//    func contentHandler(browserPaymentSuccessfulFor handler: DefaultContentHandler) {
//        debugPrint("支付成功通知!")
//        switch self.curCellType {
//        case .image(let cell):
//            // 隐藏遮罩视图
//            cell?.blurView.isHidden = true
//            // 添加新的数据源
//            self.lastNumberOfItems = self.worksImageFreeCount
//            self.addRemainingPictures()
//            self.reloadData()
//
//        case .video(let cell):
//            self.navBar.updateCountdownAndBuy(value: .hidden)
//            self.isVideoPlayEnable = true
//            if self.playerMgr == nil {
//                // 刷新
//                self.reloadData()
//            } else {
//                // 继续播放
//                self.playerMgr?.play()
//                // 页面状态变化
//                cell?.blurView.isHidden = true
//                self.toolbar.toolView?.userInteraction = .normal
//            }
//
//        default:
//            break
//        }
//    }
//
//    /// 作品媒体浏览器评论成功
//    func contentHandler(browserCommentSuccessfulFor handler: DefaultContentHandler) {
//        self.toolbar.footerView.updateComment(count: self.parentModel.commentCount)
//    }
//
//}
