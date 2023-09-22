import UIKit
import RxSwift
import RxCocoa
import AudioToolbox
import AVFoundation
import Photos


/// 聊天底部工具栏
///
class ChatToolBar: UIView {
    
    weak var viewModel: ChatViewModel!
    weak var controller: UIViewController?

    /// 视图高度改变通知
    let rx_heightDidChanged = PublishSubject<(height: CGFloat, duration: TimeInterval)>()
    var searchMembers: ((String)->())?
    var hideMembers: (()->())?
    var atLocation: Int = -1

    /// 视图初始化高度
    var viewInitHeight: CGFloat {
        var height: CGFloat = 0
        height += (textInputTop + textInputBottom)
        height += textInputInitHeight
        return height
    }
    
    /// 保存变化之前的高度
    private var lastViewHeight: CGFloat!
    
    /// 输入框最大行数
    var textInputMaxLines:NSInteger?
    {
        didSet{
            textInputMaxHeight = ceil((self.inputTextView.font?.lineHeight)! *
                                      CGFloat(textInputMaxLines! + 1) +
                                      self.inputTextView.textContainerInset.top +
                                      self.inputTextView.textContainerInset.bottom)
        }
    }
    /// 输入框最大高度
    private var textInputMaxHeight: CGFloat?
    /// 输入框最都输入字符数
    private let textInputMaxWords: Int = 160
    /// 文本输入框初始化高度
    private let textInputInitHeight: CGFloat = 36
    /// 文本输入框顶部间距
    private let textInputTop: CGFloat = 10
    /// 文本输入框底部间距
    private let textInputBottom: CGFloat = 10
    /// 工具栏底部偏移高度
    private var toolbarBottomOffset: CGFloat = 0
    /// DisposeBag
    private var disposeBag = DisposeBag()

    // MARK: - Views
    /// 分割线
    lazy var lineView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = ThemeGuide.Colors.separator
        return view
    }()
    
    /// 录音或输入切换
    lazy var micOrInputButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(ThemeGuide.Icons.Chat.chatroom_toolbar_micro, for: .normal)
        button.setBackgroundImage(ThemeGuide.Icons.Chat.chatroom_toolbar_text, for: .selected)
        return button
    }()
    
    /// 输入框
    lazy var inputTextView: TTPlaceHolderTextView = {
        let textView = TTPlaceHolderTextView()
        textView.delegate = self
        textView.setLayerCorner(radius: textInputInitHeight/2)
        textView.textInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        textView.placeHolderInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        textView.placeHolderLabel.font = UIFont.fontMedium(fontSize: 14)
        textView.placeHolderLabel.textColor = ThemeGuide.Colors.assist
        textView.theme_backgroundColor = ThemeGuide.Colors.theme_backgroundHigh
        textView.theme_textColor = ThemeGuide.Colors.theme_title
        textView.font = UIFont.fontMedium(fontSize: 14)
        textView.scrollRangeToVisible(NSRange.init(location: 0, length: 0))
        textView.isEditable = true
        return textView
    }()
    
    /// 录音
    lazy var recordButton: UIButton = {
        let button = UIButton()
        button.setLayerCorner(radius: textInputInitHeight/2)
        button.titleLabel?.font = UIFont.fontMedium(fontSize: 14)
        button.theme_backgroundColor = ThemeGuide.Colors.theme_backgroundHigh
        button.theme_setTitleColor(ThemeGuide.Colors.theme_title, forState: .normal)
        button.setTitle(.localized_longPressRecording, for: UIControl.State.normal)
        return button
    }()
    
    /// 更多或发送
    lazy var moreOrSendButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(ThemeGuide.Icons.Chat.chatroom_toolbar_more, for: .normal)
        button.setBackgroundImage(ThemeGuide.Icons.Chat.chatroom_toolbar_send, for: .selected)
        return button
    }()
    
    // MARK: - Lifecycle
    convenience init(frame: CGRect, viewModel: ChatViewModel) {
        self.init(frame: frame)
        
        self.viewModel = viewModel

        lastViewHeight = viewInitHeight

        self.textInputMaxLines = 5
        
        setupUI()
        setupBindings()
    }
    
    /// 手动设置输入文本
    func setText(text: String?) {
        if let text = text {
            self.inputTextView.text = text.limitLength(of: self.textInputMaxWords)
        } else {
            self.inputTextView.text = ""
        }
        
        self.layoutIfNeeded()
        self.relayoutInputView(duration: 0) //开始默认为0，是为了在界面刚显示时调用setText(_)，不显示动画
    }
    
    func setAtText(text: String) {
        if atLocation != -1 {
            var inputText = self.inputTextView.text ?? ""
            let preText = String(inputText.prefix(atLocation))
            if preText.isEmpty {
                inputText = preText + text + " "
            } else {
                inputText = preText + " " + text + " "
            }
            self.inputTextView.text = inputText
            
            self.layoutIfNeeded()
            self.relayoutInputView(duration: 0) //开始默认为0，是为了在界面刚显示时调用setText(_)，不显示动画
        }
    }
    
    /// 更新视图高度
    private func relayoutInputView(duration: TimeInterval) {
        let textInputHeight = ceil(self.inputTextView.sizeThatFits(CGSize(width: self.inputTextView.width,
                                                                          height: CGFloat(MAXFLOAT))).height)
        let isScrollEnabled = (textInputHeight > textInputMaxHeight!) && textInputMaxHeight! > CGFloat(0)
        let inputViewHeight = isScrollEnabled ? (textInputMaxHeight! + 5) : (textInputHeight)
        let inputViewCurHeight = self.micOrInputButton.isSelected ? textInputInitHeight : inputViewHeight
        
        self.inputTextView.isScrollEnabled = isScrollEnabled
        
        var viewHeight: CGFloat = 0
        viewHeight += (textInputTop + textInputBottom)
        viewHeight += inputViewCurHeight

        if viewHeight != lastViewHeight {
            lastViewHeight = viewHeight
            
            rx_heightDidChanged.onNext((viewHeight, duration))
        }
    }
}

// MARK: - UI Setup
extension ChatToolBar {
    
    private func setupUI() {
        theme_backgroundColor = ThemeGuide.Colors.theme_foreground

        let micSize: CGFloat = ThemeGuide.Icons.Chat.chatroom_toolbar_micro.size.height
        let inputLeft: CGFloat = 46
        
        addSubview(lineView)
        addSubview(micOrInputButton)
        addSubview(inputTextView)
        addSubview(recordButton)
        addSubview(moreOrSendButton)
        lineView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
        micOrInputButton.snp.makeConstraints { (make) in
            make.left.equalTo((inputLeft-micSize)/2)
            make.bottom.equalTo(-(textInputInitHeight-micSize)/2-textInputBottom)
            make.size.equalTo(micSize)
        }
        inputTextView.snp.makeConstraints { (make) in
            make.left.equalTo(inputLeft)
            make.right.equalTo(-inputLeft)
            make.top.equalTo(textInputTop)
            make.bottom.equalTo(-textInputBottom)
        }
        recordButton.snp.makeConstraints { (make) in
            make.left.equalTo(inputTextView)
            make.right.equalTo(inputTextView)
            make.top.equalTo(inputTextView)
            make.height.equalTo(textInputInitHeight)
        }
        moreOrSendButton.snp.makeConstraints { (make) in
            make.right.equalTo(-(inputLeft-micSize)/2)
            make.centerY.equalTo(micOrInputButton)
            make.size.equalTo(micSize)
        }
        
        recordButton.isHidden = true
    }
}

// MARK: - Binds
extension ChatToolBar {
    
    private func setupBindings() {
        /// 监听录音按钮是否可操作
        TRecorderManager.shared.rx_recorderButtonEnabled.subscribe(onNext: { isEnable in
            self.recordButton.isEnabled = isEnable
        })
        .disposed(by: disposeBag)
        
        /// 开始录音
        recordButton.rx.controlEvent([.touchDown])
        .subscribe(onNext: { _ in
            guard let controller = self.controller else { return }
            
            // 震动
            AudioServicesPlaySystemSound(SystemSoundID(1519))

            TRecorderManager.shared.startRecorder(controller: controller) { result in
                switch result {
                case .success:
                    self.recordButton.setTitle(.localized_letGoOver, for: UIControl.State.normal)
                case .fail:
                    debugPrint("开启失败")
                }
            }
        })
        .disposed(by: disposeBag)
        
        /// 录音成功 发送录音 按钮恢复状态
        recordButton.rx.controlEvent([.touchUpInside])
        .subscribe(onNext: { _ in
            
            self.recordButton.setTitle(.localized_longPressRecording, for: UIControl.State.normal)

            TRecorderManager.shared.finishRecorder { result in
                switch result {
                case .success(let path, let fileName, let duration):
                    debugPrint("录音信息:\(path), \(fileName), \(duration)")
                    // 发送语音
                    self.sendAudio(filePath: path, fileName: fileName, duration: duration)
                case .fail:
                    debugPrint("结束失败")
                }
            }
        })
        .disposed(by: disposeBag)
        
        /// 取消录音
        recordButton.rx.controlEvent([.touchUpOutside])
        .subscribe(onNext: { _ in
            
            self.recordButton.setTitle(.localized_longPressRecording, for: UIControl.State.normal)

            TRecorderManager.shared.cancelRecorder()
        })
        .disposed(by: disposeBag)
                
        /// 移出范围 准备取消录音
        recordButton.rx.controlEvent([.touchDragExit])
        .subscribe(onNext: { _ in
            
            self.recordButton.setTitle(.localized_letGoCancel, for: UIControl.State.normal)

            TRecorderManager.shared.readyToCancelRecorder()
        })
        .disposed(by: disposeBag)
        
        /// 移入范围 准备继续录音
        recordButton.rx.controlEvent([.touchDragEnter])
        .subscribe(onNext: { _ in
            
            self.recordButton.setTitle(.localized_letGoOver, for: UIControl.State.normal)

            TRecorderManager.shared.readyToResumeRecorder()
        })
        .disposed(by: disposeBag)
        
        
        /// `录音或键盘`是否选中监听
        let rx_micOrInputSelected = BehaviorSubject<Bool>(value: false)

        /// `输入框`文字监听
        let inputTextViewSequence = (inputTextView.rx.text)
            .orEmpty
            .flatMap{ text -> Observable<String> in
                return Observable.create({ observer -> Disposable in
                    observer.onNext(text.trimmingCharacters(in: .whitespacesAndNewlines))
                    return Disposables.create()
                })
            }
            .map{ $0.count > 0}
            .share(replay: 1)
        
        /// 合并`录音或键盘`及`输入框`
        let moreOrSendSelectEnable = Driver.combineLatest(
            inputTextViewSequence.asDriver(onErrorJustReturn: false),
            rx_micOrInputSelected.asDriver(onErrorJustReturn: false)
        ) { inputText, isMicOrInputSelected in
                inputText &&
                !isMicOrInputSelected
        }
        .distinctUntilChanged()
        
        /// 判断`更多或发送`按钮能否被选中
        moreOrSendSelectEnable
            .drive(onNext: { [weak self] isSelected  in
                self?.moreOrSendButton.isSelected = isSelected
            })
            .disposed(by: disposeBag)
        
        
        /// `录音或键盘`按钮点击
        micOrInputButton.rx.tap
            .subscribe(onNext:{ [weak self] in
                guard let `self` = self else { return }
                self.micOrInputButton.isSelected = !self.micOrInputButton.isSelected
                rx_micOrInputSelected.onNext(self.micOrInputButton.isSelected)
                if self.micOrInputButton.isSelected {
                    self.inputTextView.isHidden = true
                    self.inputTextView.resignFirstResponder()
                    self.recordButton.isHidden = false
                } else {
                    self.inputTextView.isHidden = false
                    self.inputTextView.becomeFirstResponder()
                    self.recordButton.isHidden = true
                }
                
                // 震动
                AudioServicesPlaySystemSound(SystemSoundID(1520))

                self.relayoutInputView(duration: 0.25)
            }).disposed(by: disposeBag)
        
        
        /// `更多或发送`按钮点击
        moreOrSendButton.rx.tap
            .subscribe(onNext:{[weak self] in
                guard let `self` = self else { return }
                if self.moreOrSendButton.isSelected {
                    if let text = self.inputTextView.text, !text.isEmpty {
                        /// 发送消息
                        self.sendText(text: text.trimmingCharacters(in: .whitespacesAndNewlines))
                    }
                } else {
                    self.showPhotoLibrary()
                }
            }).disposed(by: disposeBag)
        
        
        /// 输入框字符长度限制
        self.inputTextView.rx.text.orEmpty
            .subscribe (onNext: { [weak self] in
                guard let `self` = self else { return }
                if $0.utf16.count > self.textInputMaxWords {
                    let selectedRange = self.inputTextView.markedTextRange
                    //没有在拼写状态再判断
                    if selectedRange == nil {
                        //通过字符串截取实现限制字符长度
                        self.inputTextView.text = $0.limitLength(of: self.textInputMaxWords)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        /// 输入框内容变化
        self.inputTextView.rx.didChange
                .subscribe(onNext:{
                    self.relayoutInputView(duration: 0.25)
                })
                .disposed(by: disposeBag)
    }
}

// MARK: - Actions
extension ChatToolBar {
    
    /// 选择媒体
    func showPhotoLibrary() {
        TMediaPicker.shared.showPicker(pickType: .all, maxCount: 1) { [weak self] (pickedType) in
            guard let self = self else { return }
            switch pickedType {
            case .image(let images):
                if let image = images.first {
                    self.sendImage(image: image)
                }
            case .video(let urls):
                if let url = urls.first {
                    self.sendVideo(fileURL: url)
                }
            }
        }
    }
    
    /// 发送文字
    func sendText(text: String) {
        self.viewModel.sendMessage(IMTextMessage(text: text))
        
        /// 清空输入框
        self.setText(text: nil)
    }
    
    /// 发送图片
    func sendImage(image: UIImage) {
        if let jpgData = image.jpeg() {
            let imageName = tt_compactUUID
            let imageMeta = ImageMetaData(
                data: jpgData,
                name: imageName,
                format: "jpeg",
                size: Int(jpgData.count),
                width: Int(image.size.width),
                height: Int(image.size.height)
            )
            let imageMessage = IMImageMessage(imageMeta: imageMeta)
            
            self.viewModel.sendMessage(imageMessage)
        }
    }
    
    /// 发送语音
    func sendAudio(filePath: String, fileName: String, duration: Int) {
        guard let URL = URL(string: filePath) else {
            return
        }
        let size = tt_fileSizeByte(URL)
        let audioMeta = AudioMetaData(
            filePath: filePath,
            name: fileName,
            format: "mp4",
            size: Int(size),
            duration: duration
        )
        let voiceMessage = IMAudioMessage(audioMeta: audioMeta)
        
        self.viewModel.sendMessage(voiceMessage)
    }
    
    /// 发送视频
    func sendVideo(fileURL: URL) {
        let videoName = "\(tt_compactUUID).mp4"
        let snapshotName = "\(tt_compactUUID).png"
        guard let videoURL = try? LocalStorageContext.shared
                .fileURL(place: .systemCaches,
                         module: .media,
                         file: .custom(videoName)
                ),
                let snapshotUrl = try? LocalStorageContext.shared
                .fileURL(place: .systemCaches,
                         module: .media,
                         file: .custom(snapshotName)
                )else {
                    self.viewModel.showToast(.localized_fileDirCreateFailed)
                    return
        }
        do {
            /// 拷贝视频到指定目录
            let ret = try LocalStorageContext.shared.copyFile(atPath: fileURL, toPath: videoURL)
            if !ret {
                self.viewModel.showToast(.localized_fileDirCreationFailed)
                return
            }
        } catch {
            self.viewModel.showToast(error.localizedDescription)
            return
        }
       
        let opts = [AVURLAssetPreferPreciseDurationAndTimingKey : NSNumber.init(value: false)]
        let urlAsset = AVURLAsset(url: videoURL, options: opts)
        let duration: Int = Int(urlAsset.duration.value) / Int(urlAsset.duration.timescale)
        
        let gen = AVAssetImageGenerator.init(asset: urlAsset)
        gen.appliesPreferredTrackTransform = true
        gen.maximumSize = CGSize(width: 192, height:192)
        
        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 10)
        let imageRef = try? gen.copyCGImage(at: time, actualTime: nil)
        guard let imageRef_ = imageRef else { return }
        let image = UIImage.init(cgImage: imageRef_)

        /// 保存视频封面
        let imageData = image.pngData()
        guard let imageData_ = imageData else { return }
        let ret = FileManager.default.createFile(atPath: snapshotUrl.path, contents: imageData_, attributes: nil)
        if !ret {
            self.viewModel.showToast(.localized_videoCoverSavedFailed)
            return
        }
        
        let size = tt_fileSizeByte(videoURL)
        let videoMeta = VideoMetaData(
            url: videoURL,
            filePath: videoURL.path,
            name: videoName,
            format: "mp4",
            size: Int(size),
            width: Int(image.size.width),
            height: Int(image.size.height),
            duration: duration,
            snapshotUrl: snapshotUrl.path,
            snapshotSize: Int(imageData_.count)
        )
        let videoMessage = IMVideoMessage(videoMeta: videoMeta)
        
        self.viewModel.sendMessage(videoMessage)
    }
}

// MARK: - UITextViewDelegate
extension ChatToolBar: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //debugPrint("未变动前内容：\(textView.text!)")
        //debugPrint("当前字符：\(text)")
        //debugPrint("location：\(range.location), length:\(range.length)")

        var curText = textView.text ?? ""
        if text == "" { //删除
            if curText.isNotEmpty {
                curText = String(curText.prefix(curText.count-1))
            }
        } else {
            curText = textView.text + text
        }
        
        if text == "@" {
            atLocation = range.location
        } else if text == "" { //删除
            if atLocation != -1 {
                if atLocation == range.location { //删除到`@`字符
                    atLocation = -1
                    hideMembers?()
                }
            }
        }
        if atLocation != -1 {
            let keywords = String(curText.suffix(curText.count-1-atLocation))
            //debugPrint("keywords: \(keywords)")
            searchMembers?(keywords)
        }
        return true
    }
}
