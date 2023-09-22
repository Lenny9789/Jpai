
import UIKit

class ChatRecordsController: BaseViewController {

    var viewModel = ChatRecordsViewModel()
    
    init(model: ChatRecordsViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = model
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        viewModel.makeConversationMessageReaded()
        navigationController?.isNavigationBarHidden = false
        
    }
    private func setupViews() {
        gk_interactivePopDisabled = true
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "聊天记录"
        navigationController?.navigationBar.tintColor = .systemRed
        navigationItem.backButtonTitle = ""
        
        view.backgroundColor = .viewBackgroundColor
        
        view.addSubview(mainTableView)
        mainTableView.whc_Top(kStatusAndNavBarHeight)
            .whc_Left(0)
            .whc_Right(0)
            .whc_Bottom(0, true)
        
        view.layoutIfNeeded()
    }
    
    private func setupBindings() {
        
        mainTableView.rx.contentOffset.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            self.view.endEditing(true)
        }.disposed(by: disposeBag)
    }
    
}


extension ChatRecordsController: UITableViewDelegate, UITableViewDataSource {
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

extension ChatRecordsController: ChatCellDelegate {
    
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
//            self.recordingView.playVoice(URL(string: voice.sourceUrl)!) {
//                voiceCell.updateVoiceAnimate(false)
//            }
//            voiceCell.updateVoiceAnimate(true)
            
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
            
            //        case .mergeTapped:
            
            
        default:
            break
        }
    }
}
