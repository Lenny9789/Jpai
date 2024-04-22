import UIKit
import ZFPlayer

/// 数据源
protocol PlayerToolViewDataSource: AnyObject {
    /// 返回当前播放器
    func playerToolView(playerFor toolView: PlayerToolView) -> ZFPlayerController?
}

/// 代理
protocol PlayerToolViewDelegate: AnyObject {
    /// 播放/暂停按钮点击
    func playerToolView(playOrPauseTappedAt toolView: PlayerToolView)
    /// 滑块滑动开始
    func playerToolView(sliderTouchBegan toolView: PlayerToolView)
    /// 滑块滑动中
    func playerToolView(sliderValueChanging toolView: PlayerToolView, value: Float, forward: Bool)
    /// 滑块滑动结束
    func playerToolView(sliderValueChanged toolView: PlayerToolView, value: Float)
}


/// 播放器控制工具栏
class PlayerToolView: UIView {
    
    weak var dataSource: PlayerToolViewDataSource?
    weak var delegate: PlayerToolViewDelegate?
    
    var danmuType: DanmuType = DanmuType(rawValue: Defaults[\.danmuMode])!
    
    /// 视图交互控制
    enum Interaction {
        // 所有控件可操作
        case normal
        // 所有子控件不响应手势
        case allUserInteractionDisable
        // 仅`playOrPauseBtn`控件响应手势
        case onlyPlayOrPauseUserInteractionEnable
    }
    var userInteraction: Interaction = .normal {
        didSet  {
            switch userInteraction {
                // 并且所有控件可操作
            case .normal:
                self.playOrPauseBtn.isEnabled = true
                self.slider.isUserInteractionEnabled = true
                self.slider.sliderBtn.isEnabled = true
                self.fullScreenBtn.isEnabled = true
                
                // 所有子控件不响应手势
            case .allUserInteractionDisable:
                self.playOrPauseBtn.isEnabled = false
                self.slider.isUserInteractionEnabled = false
                self.slider.sliderBtn.isEnabled = false
                self.fullScreenBtn.isEnabled = false
                
                // 仅`playOrPauseBtn`控件响应手势
            case .onlyPlayOrPauseUserInteractionEnable:
                self.playOrPauseBtn.isEnabled = true
                self.slider.isUserInteractionEnabled = false
                self.slider.sliderBtn.isEnabled = false
                self.fullScreenBtn.isEnabled = false
            }
        }
    }
    
    private var curTimeStr = "00:00"
    private var totalTimeStr = "00:00"

    private var disposeBag = DisposeBag()

    static var viewTag: Int {
        return 11111
    }
    
    lazy var playOrPauseBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(R.image.live_player_play(), for: .normal)
        button.setImage(R.image.live_player_pause(), for: .selected)
        button.isSelected = true
        return button
    }()
    
    lazy var reloadBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(R.image.live_player_reload(), for: .normal)
        button.setImage(R.image.live_player_reload_big(), for: .selected)
        return button
    }()
    
    lazy var slider: ZFSliderView = {
        let slider = ZFSliderView()
        slider.delegate = self
        slider.minimumTrackTintColor = kMainColor
        slider.maximumTrackTintColor = kSecondaryText2Color
        slider.setThumbImage(R.image.live_tool_slider(), for: .normal)
//        slider.bufferTrackTintColor = .white
//        slider.setThumbImage(R.image.memorial_toolbar_play(), for: .normal)
//        slider.setThumbImage(R.image.memorial_toolbar_play(), for: .disabled)
        slider.sliderHeight = 2
        slider.isHidden = true
        return slider
    }()
    
    lazy var curTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .fontMedium(fontSize: 12)
        label.textColor = .white
        label.text = "\(curTimeStr)/\(totalTimeStr)"
        label.isHidden = true
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .fontMedium(fontSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        label.text = totalTimeStr
        label.isHidden = true
        return label
    }()
    
    lazy var danmuBtn: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(
            R.image.live_tool_danmu_half_s(),
            for: .normal
        )
        return button
    }()
    
    lazy var settingsBtn: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(
            R.image.live_tool_settings_s(),
            for: .normal
        )
        button.setBackgroundImage(
            R.image.live_tool_settings_l(),
            for: .selected
        )
        return button
    }()
    
    lazy var videoQualityBtn: UIButton = {
        let button = UIButton()
        button.layerBorderColor = .white
        button.layerBorderWidth = 2
        button.titleLabel?.font = .fontMedium(fontSize: 10)
        button.setTitle("标清", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.isHidden = false
        return button
    }()
    
    lazy var fullScreenBtn: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(
            R.image.live_player_full(),
            for: .normal
        )
        button.setBackgroundImage(
            R.image.live_player_full_back(),
            for: .selected
        )
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(playOrPauseBtn)
        addSubview(reloadBtn)
        addSubview(slider)
        addSubview(curTimeLabel)
        addSubview(timeLabel)
        addSubview(videoQualityBtn)
        addSubview(fullScreenBtn)
        addSubview(settingsBtn)
        addSubview(danmuBtn)
        
        playOrPauseBtn.whc_Left(0)
            .whc_CenterY(0)
            .whc_WidthAuto()
            .whc_HeightAuto()
        reloadBtn.whc_Left(14, toView: playOrPauseBtn)
            .whc_CenterY(0)
            .whc_WidthAuto()
            .whc_HeightAuto()
        slider.whc_Left(10, toView: reloadBtn)
            .whc_Right(10, toView: timeLabel)
            .whc_CenterY(0)
            .whc_Height(18)
        timeLabel.whc_Right(10, toView: videoQualityBtn)
            .whc_CenterY(0)
            .whc_WidthAuto()
            .whc_HeightAuto()
        fullScreenBtn.whc_Right(0)
            .whc_CenterY(0)
            .whc_WidthAuto()
            .whc_HeightAuto()
        videoQualityBtn.whc_Right(14, toView: fullScreenBtn)
            .whc_CenterY(0)
            .whc_Width(34)
            .whc_Height(18)
            .setLayerCorner(radius: 9, corners: .allCorners)
        settingsBtn.whc_Right(14, toView: videoQualityBtn)
            .whc_CenterY(0)
            .whc_WidthAuto()
            .whc_HeightAuto()
        danmuBtn.whc_Right(14, toView: settingsBtn)
            .whc_CenterY(0)
            .whc_WidthAuto()
            .whc_HeightAuto()
        
        // 播放/暂停按钮点击
        playOrPauseBtn.rx.tap.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            self.delegate?.playerToolView(playOrPauseTappedAt: self)
        }.disposed(by: disposeBag)
        
        danmuBtn.rx.tap.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            switch danmuType {
            case .None:
                danmuType = .Gorgeous
            case .Simplify:
                danmuType = .None
            case .Gorgeous:
                danmuType = .Simplify
            }
            
            updateDanmuStatus(type: danmuType, isFullScreen: kAppDelegate.isFullScreen)
        }.disposed(by: disposeBag)
        
        settingsBtn.rx.tap.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            
        }.disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isFullScreen: Bool = false {
        didSet {
            if isFullScreen {
                videoQualityBtn.whc_Width(45)
                    .whc_Height(24)
                    .setLayerCorner(radius: 12, corners: .allCorners)
                videoQualityBtn.titleLabel?.font = .fontMedium(fontSize: 13)
                playOrPauseBtn.setImage(R.image.live_player_play_big(), for: .normal)
                playOrPauseBtn.setImage(R.image.live_player_pause_big(), for: .selected)
            } else {
                videoQualityBtn.whc_Width(34)
                    .whc_Height(18)
                    .setLayerCorner(radius: 9, corners: .allCorners)
                videoQualityBtn.titleLabel?.font = .fontMedium(fontSize: 10)
                playOrPauseBtn.setImage(R.image.live_player_play(), for: .normal)
                playOrPauseBtn.setImage(R.image.live_player_pause(), for: .selected)
            }
            reloadBtn.isSelected = isFullScreen
            settingsBtn.isSelected = isFullScreen
            fullScreenBtn.isSelected = isFullScreen
            updateDanmuStatus(type: danmuType, isFullScreen: isFullScreen)
        }
    }
    
    public func resetView() {
        playOrPauseBtn.isSelected = true
        slider.value = 0
        slider.bufferValue = 0
        curTimeStr = "00:00"
        totalTimeStr = "00:00"
        curTimeLabel.text = curTimeStr
        timeLabel.text = totalTimeStr
    }
}

// -MARK: -- Status Set
extension PlayerToolView {
    
    func showPlaybackToolView() {
        playOrPauseBtn.isHidden = true
        reloadBtn.isHidden = true
        danmuBtn.isHidden = true
        settingsBtn.isHidden = true
        videoQualityBtn.isHidden = true
        
        curTimeLabel.isHidden = false
        slider.isHidden = false
        timeLabel.isHidden = false
        
        curTimeLabel.whc_ResetConstraints()
            .whc_Left(0)
            .whc_CenterY(0)
            .whc_Width(50)
            .whc_Height(15)
        timeLabel.whc_ResetConstraints()
            .whc_Right(10, toView: fullScreenBtn)
            .whc_CenterY(0)
            .whc_Width(50)
            .whc_Height(15)
        
        slider.whc_ResetConstraints()
            .whc_CenterY(0)
            .whc_Left(5, toView: curTimeLabel)
            .whc_Right(5, toView: timeLabel)
    }
    
    func updateDanmuStatus(type: DanmuType, isFullScreen: Bool) {
        var bgImage: UIImage?
        switch type {
        case .None:
            bgImage = isFullScreen ?
            R.image.live_tool_danmu_dis_l() : R.image.live_tool_danmu_dis_s()
        case .Simplify:
            bgImage = isFullScreen ?
            R.image.live_tool_danmu_half_l() : R.image.live_tool_danmu_half_s()
        case .Gorgeous:
            bgImage = isFullScreen ?
            R.image.live_tool_danmu_full_l() : R.image.live_tool_danmu_full_s()
        }
        danmuBtn.setBackgroundImage(bgImage, for: .normal)
    }
}
// -MARK: -- Slider
extension PlayerToolView {
    public func updateTime(currentTime: String, totalTime: String) {
        curTimeStr = currentTime
        totalTimeStr = totalTime
        curTimeLabel.text = curTimeStr
        timeLabel.text = totalTimeStr
    }
    
    
    /// 调节播放进度slider和当前时间更新
    public func sliderValueChanged(value: Float, currentTimeString timeString: String) {
        curTimeStr = timeString
        curTimeLabel.text = curTimeStr
        timeLabel.text = totalTimeStr
        
        slider.value = value
        slider.isdragging = true
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.slider.sliderBtn.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
    }
    
    /// 滑杆结束滑动
    public func sliderChangeEnded() {
        slider.isdragging = false
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.slider.sliderBtn.transform = CGAffineTransform.identity
        }
    }
}
//MARK: - ZFSliderViewDelegate
extension PlayerToolView: ZFSliderViewDelegate {
    
    func sliderTouchBegan(_ value: Float) {
        guard let _ = self.dataSource?.playerToolView(playerFor: self) else { return }
        self.slider.isdragging = true
        self.delegate?.playerToolView(sliderTouchBegan: self)
    }
    
    func sliderValueChanged(_ value: Float) {
        guard let player = self.dataSource?.playerToolView(playerFor: self) else { return }
        if player.totalTime == 0 {
            self.slider.value = 0
            return
        }
        self.slider.isdragging = true

        let totalTime = player.totalTime
        let currentTime = totalTime*Double(value)
        self.updateTime(
            currentTime: ZFUtilities.convertTimeSecond(Int(currentTime)),
            totalTime: ZFUtilities.convertTimeSecond(Int(totalTime)))
        
        self.delegate?.playerToolView(sliderValueChanging: self, value: value, forward: self.slider.isForward)
    }
    
    func sliderTouchEnded(_ value: Float) {
        guard let player = self.dataSource?.playerToolView(playerFor: self) else { return }
        if player.totalTime > 0 {
            self.slider.isdragging = true
            self.delegate?.playerToolView(sliderValueChanging: self, value: value, forward: self.slider.isForward)
            player.seek(toTime: player.totalTime*Double(value), completionHandler: { [weak self] finished in
                guard let `self` = self else { return }
                debugPrint("seek完成")
                self.slider.isdragging = false
                if finished {
                    player.currentPlayerManager.play()
                    debugPrint("seek到 \(value) 位置")
                    self.delegate?.playerToolView(sliderValueChanged: self, value: value)
                }
            })
        } else {
            self.slider.isdragging = false
            self.slider.value = 0
        }
    }
    
    func sliderTapped(_ value: Float) {
        guard let player = self.dataSource?.playerToolView(playerFor: self) else { return }
        if player.totalTime > 0 {
            self.slider.isdragging = true
            player.seek(toTime: player.totalTime*Double(value)) {  [weak self] finished in
                guard let `self` = self else { return }
                debugPrint("seek完成")
                self.slider.isdragging = false
                if finished {
                    player.currentPlayerManager.play()
                    debugPrint("seek到 \(value) 位置")
                }
            }
        } else {
            self.slider.isdragging = false
            self.slider.value = 0
        }
    }
    
}
