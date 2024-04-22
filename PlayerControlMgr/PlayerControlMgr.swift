import Foundation
import UIKit
import ZFPlayer

enum PlayerControlEvent {
case EnterFullScreeen(Bool)
case BackButtonTapped
case ReloadButtonTapped
case SelectQuality(LiveQuality)
case QualityButtonTapped
case SettingsButtonTapped
case ChangeBarrageMode(DanmuType)
case DanmuFontChange(LiveDanmuSettingsView.DanmuFont)
case DanmuAlphaDidChange(Float)
}
/// 播放器管理
class PlayerControlMgr {
    
    let rx_PlayerControlEvent = PublishSubject<PlayerControlEvent>()
    // 播放场景
    enum PlayScene {
        // 普通播放
        case normal(containerView: UIView)
        // 列表播放
        case scrollView(scrollView: UIScrollView, containerViewTag: Int)
    }
    
    var player: ZFPlayerController?
    
    var scrollViewDidEndScrollingCallback: ((IndexPath)->())?

    private var disposeBag = DisposeBag()

    lazy var controlView: PlayerControlView = {
        let view = PlayerControlView()
        view.rx_PlayerControlEvent.bind(to: rx_PlayerControlEvent)
            .disposed(by: disposeBag)
        return view
    }()
    
    private var containerView: UIView!
    private var isFullScreen: Bool = false {
        didSet {
            controlView.isFullScreen = isFullScreen
        }
    }
    
    init() {
        //应用将要进入前台
        UIApplication.rx.willEnterForeground
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                guard let player = self.player else { return }
                // 如果当前视图不可见，暂停播放视频
                if player.currentPlayerManager.playState == .playStatePlaying {
                    self.controlView.isManuallyPausing = true
                    player.currentPlayerManager.pause()
                }
            })
            .disposed(by: disposeBag)
        
        //应用将要进入后台台
        UIApplication.rx.willResignActive
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                if let player = self.player, player.isFullScreen {
                    debugPrint("进入后台，播放器切回竖屏！")
                    player.enterFullScreen(false, animated: false)
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// 创建播放器
    func createPlayer(scene: PlayScene) {
        let playerManager = ZFIJKPlayerManager()
        playerManager.shouldAutoPlay = true
        
        var player: ZFPlayerController
        switch scene {
        case .normal(let containerView):
            self.containerView = containerView
            player = ZFPlayerController.player(
                withPlayerManager: playerManager,
                containerView: containerView)
            
        case .scrollView(let scrollView, let containerViewTag):
            player = ZFPlayerController.player(
                with: scrollView,
                playerManager: playerManager,
                containerViewTag: containerViewTag)
        }
        player.controlView = controlView
        //player.playerDisapperaPercent = 0.8
        //player.playerApperaPercent = 0.5
        player.isWWANAutoPlay = true
        
        player.allowOrentitaionRotation = false
        player.pauseWhenAppResignActive = false //设置退到后台继续播放
        player.playerDidToEnd = { asset in
            asset.replay()
        }
        player.zf_scrollViewDidEndScrollingCallback = { [weak self] indexPath in
            self?.scrollViewDidEndScrollingCallback?(indexPath)
        }
        self.player = player
    }
    
    /// 设置底部提示进度条
    func setupControlBottomProgress(_ bottomProgress: ZFSliderView) {
        controlView.bottomProgress = bottomProgress
    }
    
    /// 配置列表支持视频播放
    func addPlayerViewToCell() {
        player?.addPlayerViewToCell()
    }
    
    /// 添加播放视图
    func addPlayerView(toContainerView: UIView) {
        player?.addPlayerView(toContainerView: toContainerView)
    }
    
    /// 设置播放的URL
    func setAssetURL(_ assetURL: URL) {
        debugPrint("待播放URL: \(assetURL)")
        player?.assetURL = assetURL
    }
    
    /// 开始播放视频
    func playTheIndex() {
        player?.playTheIndex(0)
    }
    
    /// 播放列表视频
    func playTheIndexPath(_ indexPath: IndexPath, assetURL: URL) {
        debugPrint("待播放URL: \(assetURL)")
        player?.playTheIndexPath(indexPath, assetURL: assetURL)
    }
    
    /// 是否设置了列表播放资源
    func hasPlayingIndexPath() -> Bool {
        return player?.playingIndexPath != nil
    }
    
    /// 获取正在播放的IndexPath
    func playingIndexPath() -> IndexPath? {
        return player?.playingIndexPath
    }
    
    /// 停止播放当前cell
    func stopCurrentPlayingCell() {
        player?.stopCurrentPlayingCell()
    }
    
    /// 停止播放当前view
    func stopCurrentPlayingView() {
        player?.stopCurrentPlayingView()
    }
    
    /// 是否正在播放
    func isPlaying() -> Bool {
        return player?.currentPlayerManager.isPlaying ?? false
    }
    
    /// 播放
    func play() {
        player?.currentPlayerManager.play()
    }
    
    /// 暂停
    func pause() {
        controlView.isManuallyPausing = true
        player?.currentPlayerManager.pause()
    }
    
    /// 停止
    func stop() {
        player?.currentPlayerManager.stop()
    }
    
    /// 暂停/恢复视频播放
    func togglePlayerControl(isPlay: Bool) {
        if isPlay {
            // 恢复播放视频
            if !isPlaying() {
                play()
            }
        } else {
            // 暂停播放视频
            if isPlaying() {
                controlView.isManuallyPausing = true
                pause()
            }
        }
    }
    
    func reload() {
        controlView.qualityView.makeReloadEvent()
    }
}

extension PlayerControlMgr {
    
    func setPlayer(title: String?) {
        controlView.topView.titleLabel.text = title
    }
    
    func setPlayer(quality: String) {
        controlView.toolView.videoQualityBtn
            .setTitle(quality, for: .normal)
    }
    
    func setPlayerForPlayback() {
        controlView.toolView.showPlaybackToolView()
    }
    
    public func updateScreen(full: Bool) {
        isFullScreen = full
    }
    
    func resetContainer() {
        player?.addPlayerView(toContainerView: containerView)
    }
    
    func qualityView(show: Bool) {
        controlView.displayQualityView(show: show)
    }
    
    func settingsView(show: Bool) {
        controlView.displaySettingsView(show: show)
    }
}
