import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchConversitions()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    private func setupViews() {
        gk_navigationBar.isHidden = true
        hidesBottomBarWhenPushed = true
        view.backgroundColor = .white
        
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
            
            self.fetchConversitions()
        }.disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(TTNotifyName.App.OIMSDKLoginSuccess)
            .subscribe { [weak self] _ in
                guard let `self` = self else { return }
                self.fetchUserInfo()
//                self.fetchConversitions()
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
            placeholderImage: UIImage(.systemBlue, content: kUserInfoModel["NickName"].stringValue, width: 40)
        )
        mainNavView.nickLabel.text = kUserInfoModel["NickName"].stringValue
        
        
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
        return 44
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
//        model.conversationReaded.subscribe { [weak self] _ in
//            guard let `self` = self else { return }
//            self.fetchConversitions()
//        }.disposed(by: disposeBag)
        model.conversation = element
        let contrl = ChatController(model: model)
        navigationController?.pushViewController(contrl, animated: true)
    }
    
}
