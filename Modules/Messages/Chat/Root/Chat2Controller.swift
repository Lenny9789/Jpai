
import UIKit
import ZLPhotoBrowser
import AVFoundation

class Chat2Controller: BaseViewController {

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
        view.register(
            ChatMessageCardCell.self,
            forCellReuseIdentifier: ChatMessageCardCell.description()
        )
        view.register(
            ChatMergeCell.self,
            forCellReuseIdentifier: ChatMergeCell.description()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        viewModel.makeConversationMessageReaded()
        
        
    }
    private func setupViews() {
        gk_navigationBar.isHidden = true
        
        
        view.backgroundColor = .viewBackgroundColor
        
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
            .whc_Height(45 + kSafeAreaBottomHeight)
        
        view.layoutIfNeeded()
    }
    
    private func fetchMessages() {
        viewModel.fetchMessages { [weak self] success in
            guard let `self` = self else { return }
            guard success else { return }
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
                if self.mainTableView.contentSize.height > self.mainTableView.height {
                    self.mainTableView.scrollToBottom(animated: false)
                }
            }
        }
    }
    private func setupBindings() {
        mainNavView.titleLabel.text = viewModel.conversation.showName
        
        fetchMessages()
        
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
                    self.fetchMessages()
                }
            }
        }.disposed(by: disposeBag)
        
        MessageManager.shared.didSendMessageSuccess.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            self.fetchMessages()
        }.disposed(by: disposeBag)
        
        MessageManager.shared.c2cReadReceiptReceived.subscribe { [weak self] event in
            guard let `self` = self else { return }
            guard let receipts = event.element else { return }
            
            self.viewModel.makeMessageReaded(by: receipts) {
                self.mainTableView.reloadData()
            }
            
        }.disposed(by: disposeBag)
        
        mainNavView.backButton.rx.tap.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        mainNavView.menuButon.rx.tap.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            
            switch self.viewModel.conversation.conversationType {
            case .undefine, .notification:
                break
            case .C2C:
                let viewModel = SingleChatSettingViewModel(conversation: self.viewModel.conversation.toConversationInfo())
                let vc = ChatSettingsController(viewModel: viewModel)
                self.navigationController?.pushViewController(vc, animated: true)
            case .group, .superGroup:
                let vc = GroupChatSettingTableViewController(conversation: self.viewModel.conversation.toConversationInfo(), style: .grouped)
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }.disposed(by: disposeBag)
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
                    if self.mainTableView.contentSize.height > self.mainTableView.height {
                        self.mainTableView.scrollToBottom(animated: false)
                    }
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
                    if self.mainTableView.contentSize.height > self.mainTableView.height {
                        self.mainTableView.scrollToBottom(animated: false)
                    }
                }
            }
        }
        
        mainNavView.callButon.rx.tap.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            
            self.startRTCAction()
        }.disposed(by: disposeBag)
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
        controller.selectImageBlock = { [weak self] results, isOrigin in
            guard let `self` = self else { return }
            guard let asset = results.first?.asset else { return }
            
            self.viewModel.showLoader()
            self.viewModel.sendMedia(asset) { success in
                self.viewModel.hideLoader()
                guard success else { return }
                
                DispatchQueue.main.async {
                    self.mainTableView.reloadData()
                    if self.mainTableView.contentSize.height > self.mainTableView.height {
                        self.mainTableView.scrollToBottom(animated: false)
                    }
                }
            }
        }
        controller.showPhotoLibrary(sender: self)
    }
    
    /// rtc
    func startRTCAction() {
        let uuid = UUID()
        
        let toUserId = viewModel.conversation.userID ?? ""
        let toUserName = viewModel.conversation.showName ?? ""
        let isAudio = false
        let toUserAvatar = viewModel.conversation.faceURL ?? ""
        
        func enterChannal(data: JSON, room: String) {
            var userData = data["user_data"].dictionaryObject ?? [:]
            userData["user"] = toUserId
            userData["room"] = room
            userData["call"] = false
            userData["avatar"] = kUserLoginModel["Avatar"].stringValue
            userData["username"] = kUserLoginModel["UserName"].stringValue
            userData["audio"] = isAudio
            userData["oppositeUserId"] = kUserLoginModel["Id"].stringValue
            userData["type"] = "call"
            userData["label"] = "a89dal3239213l12304"
            let str = try? userData.jsonString(using: .utf8, options: .init(rawValue: 0))
//            let message = OIMMessageInfo.createCustomMessage(str ?? "", extension: "{}", description: "[通话]")
//            let off = OIMOfflinePushInfo()
//            off.title = "您收到一个通话"
//            off.desc = ""
//            off.iOSBadgeCount = true
//            OIMManager.manager.sendMessage(message, recvID: toUserId, groupID: "", offlinePushInfo: off) { [weak self] message in
//                guard let `self` = self else { return }
//                debugPrintS(message)
//
//            } onProgress: { progres in
//                debugPrint("progres:\(progres)")
//            } onFailure: { code, msg in
//                debugPrintS("code:\(code), error:\(msg ?? "")")
//            }
            OIMManager.manager.typingStatusUpdate(toUserId, msgTip: str ?? "") { _ in }
            
            var thisData = data["this_data"].dictionaryObject ?? [:]
            thisData["user"] = kUserLoginModel["Id"].stringValue
            thisData["room"] = room
            thisData["call"] = true
            thisData["avatar"] = toUserAvatar
            thisData["username"] = toUserName
            thisData["audio"] = isAudio
            thisData["oppositeUserId"] = toUserId
            let str2 = try? userData.jsonString(using: .utf8, options: .init(rawValue: 0))
            let controller = RTCController()
            controller.isCaller = true
            controller.rtcData = JSON(thisData)
            self.navigationController?.pushViewController(controller)
        }
        
        let param: Param = ["user": toUserId, "room": uuid, "thisUser": kUserLoginModel["Id"].intValue]
        APIService.shared.fetchRTCData(param: param) { [weak self] result in
            guard let `self` = self else { return }
            debugPrint(result)
            switch result {
            case .success(let model):
                debugPrintS(model)
                enterChannal(data: model, room: uuid.uuidString)
                
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
}


extension Chat2Controller: UITableViewDelegate, UITableViewDataSource {
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
            
        case .card:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ChatMessageCardCell.description(),
                for: indexPath
            ) as! ChatMessageCardCell
            
            cell.fillWith(element)
            cell_back = cell
            
        case .merge:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ChatMergeCell.description(),
                for: indexPath
            ) as! ChatMergeCell
            
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

extension Chat2Controller: ChatCellDelegate {
    
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
            
        case .avatarTapped:
            guard let cell = curView as? ChatMessageCell else { return }
            let control = UserDetailTableViewController(
                userId: cell.curMessage.sendID ?? "",
                groupId: cell.curMessage.groupID ?? ""
            )
            navigationController?.pushViewController(control, animated: true)
            
        case .cardTapped:
            guard let cardCell = curView as? ChatMessageCardCell else { return }
            guard let card = cardCell.curMessage.cardElem else { return }
            let control = UserDetailTableViewController(
                userId: card.userID,
                groupId: nil,
                userDetailFor: .card
            )
            navigationController?.pushViewController(control, animated: true)
            
        case .mergeTapped:
            guard let mergeCell = curView as? ChatMergeCell else { return }
            guard let merge = mergeCell.curMessage.mergeElem else { return }
            
            let model = ChatRecordsViewModel()
            model.mergeElem = merge
            let control = ChatRecordsController(model: model)
            navigationController?.pushViewController(control, animated: true)
            
            
            
            
        default:
            break
        }
    }
}
