import UIKit
import ProgressHUD

class MessageController: TTViewController {
    
    let viewModel = MessageViewModel()
    
    lazy var mainNavView: MessageTopNavView = {
        let view = MessageTopNavView()
        return view
    }()
    
    lazy var searchView: MessageSearchView = {
        let view = MessageSearchView()
        return view
    }()
    
    lazy var mainTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.dataSource = self
        view.delegate = self
        view.estimatedRowHeight = 0
        view.tableFooterView = UIView()
        view.contentInsetAdjustmentBehavior = .never
        view.register(
            MessageConversationCell.self,
            forCellReuseIdentifier: MessageConversationCell.description()
        )
        return view
    }()
    
    lazy var menuView: ChatMenuView = {
        let v = ChatMenuView()
        let scanItem = ChatMenuView.MenuItem(
            title: "扫一扫".innerLocalized(),
            icon: UIImage(nameInBundle: "chat_menu_scan_icon")
        ) { [weak self] in
            let vc = ScanViewController()
            vc.scanDidComplete = { [weak self] (result: String) in
                if result.contains(IMController.addFriendPrefix) {
                    let uid = result.replacingOccurrences(of: IMController.addFriendPrefix, with: "")
                    let vc = UserDetailTableViewController(userId: uid, groupId: nil)
                    vc.hidesBottomBarWhenPushed = true
                    self?.navigationController?.pushViewController(vc, animated: true)
                    self?.dismiss(animated: false)
                } else if result.contains(IMController.joinGroupPrefix) {
                    let groupID = result.replacingOccurrences(of: IMController.joinGroupPrefix, with: "")
                    let vc = GroupDetailViewController(groupId: groupID)
                    vc.hidesBottomBarWhenPushed = true
                    self?.navigationController?.pushViewController(vc, animated: true)
                    self?.dismiss(animated: false)
                } else {
                    ProgressHUD.showError(result)
                }
            }
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true, completion: nil)
        }
        
        let addFriendItem = ChatMenuView.MenuItem(
            title: "添加好友".innerLocalized(),
            icon: UIImage(nameInBundle: "chat_menu_add_friend_icon")
        ) { [weak self] in
            let vc = SearchFriendViewController()
            vc.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(vc, animated: true)
            vc.didSelectedItem = { [weak self] id in
                let vc = UserDetailTableViewController(userId: id, groupId: nil)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        let addGroupItem = ChatMenuView.MenuItem(
            title: "添加群聊".innerLocalized(),
            icon: UIImage(nameInBundle: "chat_menu_add_group_icon")
        ) { [weak self] in
            let vc = SearchGroupViewController()
            vc.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(vc, animated: true)
            
            vc.didSelectedItem = { [weak self] id in
                let vc = GroupDetailViewController(groupId: id)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        let createWorkGroupItem = ChatMenuView.MenuItem(
            title: "创建大群".innerLocalized(),
            icon: UIImage(nameInBundle: "chat_menu_create_work_group_icon")
        ) { [weak self] in
            let vc = SelectContactsViewController()
            vc.selectedContact(blocked: [IMController.shared.uid]) { [weak self] (r: [ContactInfo]) in
                guard let sself = self else { return }
                let users = r.map {UserInfo(userID: $0.ID!, nickname: $0.name, faceURL: $0.faceURL)}
                let vc = NewGroupViewController(users: users, groupType: .working)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            vc.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        var items = [scanItem, addFriendItem, addGroupItem, createWorkGroupItem]
        
        v.setItems(items)
        
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupBindings()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchConversitions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    private func setupViews() {
        gk_navigationBar.isHidden = true
        
        navigationController?.navigationBar.tintColor = .systemRed
        navigationItem.backButtonTitle = ""
        
        view.backgroundColor = .viewBackgroundColor
        
        view.addSubview(mainNavView)
        mainNavView.whc_Top(0)
            .whc_Left(0)
            .whc_Right(0)
            .whc_Height(kStatusAndNavBarHeight + 10)
        view.addSubview(searchView)
        searchView.whc_Top(0, toView: mainNavView)
            .whc_Left(0)
            .whc_Right(0)
            .whc_Height(40)
        
        view.addSubview(mainTableView)
        mainTableView.whc_Top(0, toView: searchView)
            .whc_Left(0)
            .whc_Right(0)
            .whc_Bottom(0, true)
    }
    
    private func setupBindings() {
        mainTableView.rx.contentOffset.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            self.view.endEditing(true)
        }.disposed(by: disposeBag)
        
        mainNavView.addButton.rx.tap.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            
            if self.menuView.superview == nil, let window = self.view.window {
                self.menuView.frame = window.bounds
                window.addSubview(self.menuView)
            } else {
                self.menuView.removeFromSuperview()
            }
        }.disposed(by: disposeBag)
        
        MessageManager.shared.connectionRelay.subscribe { [weak self] event in
            guard let `self` = self else { return }
            guard let status = event.element else { return }
            self.mainNavView.statusView.present(status)
            if status == .syncComplete {
                self.fetchConversitions()
            }
        }.disposed(by: disposeBag)
        
        MessageManager.shared.newMsgReceivedSubject.subscribe { [weak self] event in
            guard let `self` = self else { return }
            guard let message = event.element else { return }
            
            if let msgtips = message.typingElem?.msgTips {
                self.receivedCall(message: message)
                return
            }
            
            if let _ = message.customElem {
                self.receiveCustom(message: message)
            }
            
            self.fetchConversitions()
        }.disposed(by: disposeBag)
        
        MessageManager.shared.totalUnreadSubject.subscribe { [weak self] event in
            guard let `self` = self else { return }
            guard let total = event.element else { return }
            guard total > 0 else {
                self.tabBarController?.tabBar.removeBadgeOnItem(index: 0)
                return
            }
            self.tabBarController?.tabBar.showBadgeOnItem(index: 0, count: total)

        }.disposed(by: disposeBag)
    }
    
    private func fetchUserInfo() {
        viewModel.showLoader()
        viewModel.fetchUserInfo { [weak self] success in
            guard let `self` = self else { return }
            self.viewModel.hideLoader()
            guard success else { return}
            
            self.setupNavStatus()
        }
    }
    
    private func setupNavStatus() {
        mainNavView.avatar.setImage(
            withURL: URL(string: kUserInfoModel["FaceURL"].stringValue),
            placeholderImage: UIImage(.systemBlue, content: kUserInfoModel["nickName"].stringValue, width: 40)
        )
        mainNavView.nickLabel.text = kUserInfoModel["nickName"].stringValue
    }
    
    private func fetchConversitions() {
        viewModel.fetchConversitionList { [weak self] success in
            guard success else {
                return
            }
            guard let `self` = self else { return }
            self.mainTableView.reloadData()
        }
    }
    
    private func receivedCall(message: OIMMessageInfo) {
        guard let msgtips = message.typingElem?.msgTips else { return }
        let json = JSON(parseJSON: msgtips)
        switch json["type"].stringValue {
        case "call":
            if let con = self.navigationController?.topViewController, con is RTCController {
                //已经在通话中
                let param: Param = ["type": "busy"]
                let str = try? param.jsonString(using: .utf8, options: .init(rawValue: 0))

                OIMManager.manager.typingStatusUpdate(json["oppositeUserId"].stringValue, msgTip: str ?? "") { result in }

                return
            }
//            //进入通话页面
            let controller = RTCController()
            controller.rtcData = json
            controller.recvMessage = message
            self.navigationController?.pushViewController(controller)
        case "hang_upfadf3fadf4561fas4d5":
            //挂断 退出通话页面
            if let con = self.navigationController?.topViewController, con is RTCController {
                self.navigationController?.popViewController(animated: true)
            }
            //对方挂断
            let p: Param = ["type": "hang_up",
                            "status": 7]
            MessageManager.shared.sendCustomMessage(param: p, recvID: message.sendID ?? "")
        default:
            break
        }
    }
    
    private func receiveCustom(message: OIMMessageInfo) {
        guard let customData = message.customElem?.data else { return }
        let json = JSON(parseJSON: customData)
        switch json["type"].stringValue {
        case "hang_up":
            //挂断 退出通话页面
            if let con = self.navigationController?.topViewController, con is RTCController {
                self.navigationController?.popViewController(animated: true)
            }
            
        default:
            break
        }
        
    }
}


extension MessageController: OIMConversationListener {
    
    func onSyncServerStart() {
        TTProgressHUD.show("正在同步会话")
    }
    
    func onSyncServerFailed() {
        viewModel.showToast("同步会话失败")
    }
    
    func onSyncServerFinish() {
        fetchConversitions()
        TTProgressHUD.hide()
    }
    
    func onNewConversation(_ conversations: [OIMConversationInfo]) {
        debugPrintS(conversations)
    }
    
}

extension MessageController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.conversationList.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MessageConversationCell.description(),
            for: indexPath
        ) as! MessageConversationCell
        let element = viewModel.conversationList[indexPath.row]
        
//        cell.setDelegator(delegate: self)
        cell.present(element)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let element = viewModel.conversationList[indexPath.row]
        let model = ChatViewModel()

        model.conversation = element
        let contrl = Chat2Controller(model: model)
        navigationController?.pushViewController(contrl, animated: true)
        
//        let control = ChatViewControllerBuilder().build(element.toConversationInfo())
//        navigationController?.pushViewController(control, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let element = viewModel.conversationList[indexPath.row]
            OIMManager.manager
                .deleteConversationAndDeleteAllMsg(element.conversationID ?? "") { [weak self] result in
                debugPrint(result)
                    guard let `self` = self else { return }
                    self.viewModel.conversationList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                    self.fetchConversitions()
            }
        }
    }
}
