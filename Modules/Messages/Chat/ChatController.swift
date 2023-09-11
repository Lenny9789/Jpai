
import UIKit
import ZLPhotoBrowser
import AVFoundation

class ChatController: BaseViewController {

    var viewModel = ChatViewModel()
    
    init(model: ChatViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = model
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var mainNavView: ChatTopNavView = {
        let view = ChatTopNavView()
        return view
    }()
    
    lazy var mainTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.dataSource = self
        view.delegate = self
        view.estimatedRowHeight = 0
        view.tableFooterView = UIView()
        view.contentInsetAdjustmentBehavior = .never
        view.register(
            ChatTextMessageCell.self,
            forCellReuseIdentifier: ChatTextMessageCell.description()
        )
        view.register(
            ChatSystemMessageCell.self,
            forCellReuseIdentifier: ChatSystemMessageCell.description()
        )
        view.register(
            ChatImageViewCell.self,
            forCellReuseIdentifier: ChatImageViewCell.description()
        )
        view.register(
            ChatVoiceMesssageCell.self,
            forCellReuseIdentifier: ChatVoiceMesssageCell.description()
        )
        view.register(
            ChatVideoMessageCell.self,
            forCellReuseIdentifier: ChatVideoMessageCell.description()
        )
        
        return view
    }()
    
    lazy var bottomInputView: ChatBottomInputTool = {
        let view = ChatBottomInputTool()
        view.setContentHuggingPriority(.required, for: .vertical)
        return view
    }()
    
    lazy var recordingView: RecorderView = {
        let view = RecorderView()
        return view
    }()
    
    lazy var bottomFuncView: ChatBottomFuncTool = {
        let view = ChatBottomFuncTool()
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupBindings()
        bindKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.makeConversationMessageReaded()
    }
    private func setupViews() {
        gk_navigationBar.isHidden = true
        
        view.backgroundColor = .init(white: 1, alpha: 0.95)
        
        view.addSubview(mainNavView)
        mainNavView.whc_Top(0)
            .whc_Left(0)
            .whc_Right(0)
            .whc_Height(kStatusAndNavBarHeight)
        
        
        view.addSubview(mainTableView)
        mainTableView.whc_Top(0, toView: mainNavView)
            .whc_Left(0)
            .whc_Right(0)
            .whc_Bottom(49, true)
        
        view.addSubview(bottomInputView)
        bottomInputView.whc_Left(0)
            .whc_Right(0)
            .whc_Height(ChatBottomInputTool.height)
            .whc_Bottom(0)
        
        view.addSubview(recordingView)
        recordingView.whc_Top(0, toView: bottomInputView)
            .whc_Right(0)
            .whc_Left(0)
            .whc_Height(45 + kSafeAreaBottomHeight())
        
    }
    
    private func setupBindings() {
        mainNavView.titleLabel.text = viewModel.conversation.showName
        
        mainTableView.headerRefresh { [weak self] in
            guard let `self` = self else { return }
            self.viewModel.fetchMoreList() { success in
                self.mainTableView.headerEndRefreshing()
                guard success else {
                    return
                }
                self.mainTableView.reloadData()
            }
        }
        
        MessageManager.shared.newMsgReceivedSubject.subscribe { [weak self] event in
            guard let `self` = self else { return }
            guard let message = event.element else { return }
            
            OIMManager.manager.getOneConversation(
                withSessionType: message.sessionType,
                sourceID: message.sessionType == .C2C ? message.sendID! : message.groupID!
            ) { conversation in
                guard let conversation = conversation else { return }
                if conversation.conversationID == self.viewModel.conversation.conversationID {
                    self.viewModel.fetchMessages { [weak self] success in
                        guard let `self` = self else { return }
                        guard success else { return }
                        DispatchQueue.main.async {
                            self.mainTableView.reloadData()
                            self.mainTableView.scrollToBottom()
                        }
                    }
                }
            }
        }.disposed(by: disposeBag)
        
        mainNavView.backButton.rx.tap.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        viewModel.fetchMessages { [weak self] success in
            guard let `self` = self else { return }
            guard success else { return }
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
                self.mainTableView.scrollToBottom(animated: false)
            }
        }
        
        mainTableView.rx.contentOffset.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            self.view.endEditing(true)
        }.disposed(by: disposeBag)
        
        bottomInputView.addButton.rx.tap.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            self.view.endEditing(true)
            
            self.fetchAlbumResource()
        }.disposed(by: disposeBag)
        bottomInputView.voiceButton.rx.tap.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            
            if self.recordingView.isHidden {
                self.bottomInputView.whc_RemoveAttrs(.bottom)
                    .whc_Height(49)
                    .whc_Bottom(100)
                self.recordingView.fetchRecordingPermission()
            }else {
                self.bottomInputView.whc_RemoveAttrs(.bottom)
                    .whc_Height(ChatBottomInputTool.height)
                    .whc_Bottom(0)
            }
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.recordingView.isHidden = !self.recordingView.isHidden
            }
        }.disposed(by: disposeBag)
        
        bottomInputView.didReturnTapped = { [weak self] text in
            guard let `self` = self else { return }
            self.view.endEditing(true)
            guard text.count > 0 else {
                return
            }
            self.viewModel.sendTextMessage(text) { success in
                guard success else { return }
                self.bottomInputView.textInputView.text = ""
                self.mainTableView.reloadData()
                DispatchQueue.main.async {
                    self.mainTableView.scrollToBottom()
                }
            }
        }
        recordingView.sendRecordVoice = { [weak self] url in
            guard let `self` = self else { return }
            self.bottomInputView.voiceButton.sendActions(for: .touchUpInside)
            self.viewModel.sendVoice(url) { success in
                guard success else { return }
                
                self.mainTableView.reloadData()
                DispatchQueue.main.async {
                    self.mainTableView.scrollToBottom()
                }
            }
        }
    }
    
    private func bindKeyboard() {
        /// 键盘高度变化 -> 更新工具栏位置
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillChangeFrameNotification)
            .subscribe(onNext: { [weak self] (notification) in
                guard let `self` = self else { return }
                /// 获取动画执行的时间
                let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
                /// 获取键盘最终Y值
                let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
                let y = endFrame.origin.y
                /// 计算工具栏距离底部的间距
                let margin = kScreenHeight - y
                
                /// 更新约束
                if (y < kScreenHeight) {
                    self.bottomInputView
                        .whc_Left(0)
                        .whc_Right(0)
                        .whc_Height(49)
                        .whc_Bottom(margin)
                } else {
                    self.bottomInputView
                        .whc_Left(0)
                        .whc_Right(0)
                        .whc_Height(ChatBottomInputTool.height)
                        .whc_Bottom(0)
                }
                /// 执行动画
                //                if self.viewModel.showAnimateWhenKeyboardChangeFrame {
                UIView.animate(withDuration: duration) {
                    self.view.layoutIfNeeded()
                }
                //                }
            })
            .disposed(by: disposeBag)
    }
    
    ///获取相册获取图片视频
    func fetchAlbumResource() {
        
        let config = ZLPhotoConfiguration.default()
        config.allowMixSelect = false
        config.allowSelectVideo = true
        config.allowSelectImage = true
        config.maxSelectCount = 1
        let controller = ZLPhotoPreviewSheet()
        controller.selectImageBlock = { [weak self] images, phAssets, isOrigin in
            guard let `self` = self else { return }
            guard let asset = phAssets.first else { return }
            
            self.viewModel.showLoader()
            self.viewModel.sendMedia(asset) { success in
                self.viewModel.hideLoader()
                guard success else { return }
                
                DispatchQueue.main.async {
                    self.mainTableView.reloadData()
                    self.mainTableView.scrollToBottom()
                }
            }
        }
        controller.showPhotoLibrary(sender: self)
    }
}


extension ChatController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell_back: ChatBaseCell?
        let element = viewModel.messages[indexPath.row]
        debugPrintS(element.contentType.rawValue)
        
        switch element.contentType {
        case .friendAppApproved:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ChatSystemMessageCell.description(),
                for: indexPath
            ) as! ChatSystemMessageCell
            
            cell.fillWith(element)
            cell_back = cell
            
        case .text:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ChatTextMessageCell.description(),
                for: indexPath
            ) as! ChatTextMessageCell
            
            cell.fillWith(element)
            cell_back = cell
            
        case .custom:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ChatTextMessageCell.description(),
                for: indexPath
            ) as! ChatTextMessageCell
            
            cell.fillWith(element)
            cell_back = cell
            
        case .image:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ChatImageViewCell.description(),
                for: indexPath
            ) as! ChatImageViewCell
            
            cell.fillWith(element)
            cell_back = cell
            
        case .audio:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ChatVoiceMesssageCell.description(),
                for: indexPath
            ) as! ChatVoiceMesssageCell
            
            cell.fillWith(element)
            cell_back = cell
            
        case .video:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ChatVideoMessageCell.description(),
                for: indexPath
            ) as! ChatVideoMessageCell
            
            cell.fillWith(element)
            cell_back = cell
            
        default:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ChatSystemMessageCell.description(),
                for: indexPath
            ) as! ChatSystemMessageCell
            
            cell.fillWith(element)
            cell_back = cell
        }
        
        cell_back?.setDelegator(delegate: self)
        return cell_back!
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = viewModel.cellHeightCache["\(indexPath.section)-\(indexPath.row)"] {
            return height
        }
        let height = ChatBaseCell.cellHeight(viewModel.messages[indexPath.row])
        viewModel.cellHeightCache["\(indexPath.section)-\(indexPath.row)"] = height
        
        return height
    }
    
}

extension ChatController: ChatCellDelegate {
    
    func cellAction(_ curView: ChatBaseCell, event: ChatBaseCell.Event) {
        switch event {
        case .pictureTapped:
            guard let imageCell = curView as? ChatImageViewCell else { return }
            guard let pic = imageCell.curMessage.pictureElem else { return }
            let url = pic.sourcePicture?.url
            var entities: [TBrowseEntity] = []
            if let link = URL(string: url) {
                entities.append(.webImageUrl(link))
            }
            let projView = imageCell.thumbImageView
            
            TMediaBrowser().showBrowser(
                with: entities,
                index: 0,
                projectiveView: projView,
                playerMgr: nil,
                isResetPlayUrl: true,
                onDismiss: nil
            )
            
        case .videoTapped:
            guard let videoCell = curView as? ChatVideoMessageCell else { return }
            guard let video = videoCell.curMessage.videoElem else { return }
            let url = video.videoUrl
            var entities: [TBrowseEntity] = []
            if let link = URL(string: url) {
                entities.append(.videoUrl(link))
            }
            let projView = videoCell.thumbImageView
            
            TMediaBrowser().showBrowser(
                with: entities,
                index: 0,
                projectiveView: projView,
                playerMgr: nil,
                isResetPlayUrl: true,
                onDismiss: nil
            )
            
        case .voiceTapped:
            guard let voiceCell = curView as? ChatVoiceMesssageCell else { return }
            guard let voice = voiceCell.curMessage.soundElem else { return }
            debugPrint(voice.sourceUrl ?? "")
            self.recordingView.playVoice(URL(string: voice.sourceUrl)!) {
                voiceCell.updateVoiceAnimate(false)
            }
            voiceCell.updateVoiceAnimate(true)
            
        default:
            break
        }
    }
}
