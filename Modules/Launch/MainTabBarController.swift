import UIKit


class MainTabBarController: UITabBarController {

    private let disposeBag = DisposeBag()
    
    static let shared: MainTabBarController = MainTabBarController()
    
//    let viewModel = LoginViewModel()
    let mainWebView = MainWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupBindings()
    }

    private func setupViews() {
        view.backgroundColor = .white
        
        let message = UINavigationController(rootViewController: MessageController())
        message.hidesBottomBarWhenPushed = true
        message.tabBarItem.title = "消息"
        message.tabBarItem.image = UIImage(named: "message.unselect")
        message.tabBarItem.selectedImage = UIImage(named: "message.select")

        let contact = UINavigationController(rootVC: ContactController())
        contact.gk_openScrollLeftPush = true
        contact.hidesBottomBarWhenPushed = true
        contact.tabBarItem.title = "通讯录"
        contact.tabBarItem.image = R.image.tabbar_contact_normal()
        contact.tabBarItem.selectedImage = R.image.tabbar_contact_selected()

//        let path = Bundle.main.path(forResource: "index", ofType: "html", inDirectory: "dist")
//        var url = URL(fileURLWithPath: path ?? "")
        let control = MainWebView()
//        control.loadRequest(urlStr: url.description)
        control.isShop = true
        let mall = UINavigationController(rootVC: control)
        mall.gk_openScrollLeftPush = true
        mall.hidesBottomBarWhenPushed = true
        mall.tabBarItem.title = "商城"
        mall.tabBarItem.image = UIImage(named: "bag.unselect")
        mall.tabBarItem.selectedImage = UIImage(named: "bag.select")

        let me = UINavigationController(rootVC: MineViewController())
        me.gk_openScrollLeftPush = true
        me.hidesBottomBarWhenPushed = true
        me.tabBarItem.title = "我的"
        me.tabBarItem.image = R.image.tabbar_profile_normal()
        me.tabBarItem.selectedImage = R.image.tabbar_profile_selected()

//        viewControllers = [message, contact, mall, me]
        tabBar.tintColor = .red
        tabBar.backgroundColor = .white

//        NotificationCenter.default.rx.notification(TTNotifyName.App.needLogin)
//            .subscribe { [weak self] _ in
//                guard let `self` = self else { return }
//                self.setupLogin()
//            }.disposed(by: disposeBag)
        
//        let chatNav = UINavigationController.init(rootViewController: ChatListViewController())
//        chatNav.tabBarItem.title = "OpenIM"
//        chatNav.tabBarItem.image = UIImage.init(named: "tab_home_icon_normal")?.withRenderingMode(.alwaysOriginal)
//        chatNav.tabBarItem.selectedImage = UIImage.init(named: "tab_home_icon_selected")?.withRenderingMode(.alwaysOriginal)
////        controllers.append(chatNav)
//        IMController.shared.totalUnreadSubject.map({ (unread: Int) -> String? in
//            var badge: String?
//            if unread == 0 {
//                badge = nil
//            } else if unread > 99 {
//                badge = "99+"
//            } else {
//                badge = String(unread)
//            }
//            return badge
//        }).bind(to: chatNav.tabBarItem.rx.badgeValue).disposed(by: disposeBag)
//
        let contactVC = ContactsViewController()
        contactVC.viewModel.dataSource = self
        let contactNav = UINavigationController.init(rootViewController: contactVC)
        contactNav.tabBarItem.title = "通讯录".localized()
        contactNav.tabBarItem.image = UIImage.init(named: "contact.unselect")?.withRenderingMode(.automatic)
        contactNav.tabBarItem.selectedImage = UIImage.init(named: "contact.select")?.withRenderingMode(.automatic)
//        controllers.append(contactNav)
        IMController.shared.contactUnreadSubject.map({ (unread: Int) -> String? in
            var badge: String?
            if unread == 0 {
                badge = nil
            } else {
                badge = String(unread)
            }
            return badge
        }).bind(to: contactNav.tabBarItem.rx.badgeValue).disposed(by: disposeBag)

        let mineNav = UINavigationController.init(rootViewController: MineViewController())
        mineNav.tabBarItem.title = "我的".localized()
//        mineNav.tabBarItem.image = UIImage.init(named: "tab_me_icon_normal")?.withRenderingMode(.alwaysOriginal)
        mineNav.tabBarItem.image = UIImage.init(named: "person")?.withRenderingMode(.automatic)
        mineNav.tabBarItem.selectedImage = UIImage.init(named: "person.fill")?.withRenderingMode(.automatic)
////        controllers.append(mineNav)
//
        self.viewControllers = [message, contactNav, mall, mineNav]
//        self.tabBar.isTranslucent = false
//        self.tabBar.backgroundColor = .white;
//
//        self.tabBar.layer.shadowColor = UIColor.black.cgColor;
//        self.tabBar.layer.shadowOpacity = 0.08;
//        self.tabBar.layer.shadowOffset = CGSize.init(width: 0, height: 0);
//        self.tabBar.layer.shadowRadius = 5;
//
//        self.tabBar.backgroundImage = UIImage.init()
//        self.tabBar.shadowImage = UIImage.init()
    }

    private func setupBindings() {
        //登录页面
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loginCheck()
    }
    
    private var isChecked: Bool = false
    
    func jumpConversation(_ conversation: OIMConversationInfo) {
        selectedIndex = 0
        if let nav = viewControllers?[0] as? UINavigationController {
            if let container = nav.viewControllers.filter({ con in
                con is Chat2Controller
            }).first {
                nav.popToViewController(container, animated: true)
                return
            }
            
            
            let model = ChatViewModel()
            model.conversation = conversation
            let contrl = Chat2Controller(model: model)
            nav.pushViewController(contrl, animated: true)
        }
    }
    
    func jumpPayment() {
        selectedIndex = 3
        if let nav = viewControllers?.last as? UINavigationController {
            let pay = MainWebView()
            pay.isPayment = true
            pay.loadLocals()
            nav.pushViewController(pay, animated: true)
        }
    }
}

extension MainTabBarController: ContactsDataSource {
    func getFrequentUsers() -> [OIMUserInfo] {
        guard let uid = kUserInfoModel["Id"].string else { return [] }
        guard let usersJson = UserDefaults.standard.object(forKey: uid) as? String else { return [] }
        
        guard let users = JsonTool.fromJson(usersJson, toClass: [UserEntity].self) else {
            return []
        }
        let current = Int(Date().timeIntervalSince1970)
        let oUsers: [OIMUserInfo] = users.compactMap { (user: UserEntity) in
            if current - user.savedTime <= 7 * 24 * 3600 {
                return user.toOIMUserInfo()
            }
            return nil
        }
        return oUsers
    }
    
    func setFrequentUsers(_ users: [OIMUserInfo]) {
//        guard let uid = AccountViewModel.userID else { return }
//        let saveTime = Int(Date().timeIntervalSince1970)
//        let before = getFrequentUsers()
//        var mUsers: [OIMUserInfo] = before
//        mUsers.append(contentsOf: users)
//        let ret = mUsers.deduplicate(filter: {$0.userID})
//        
//        let uEntities: [UserEntity] = ret.compactMap { (user: OIMUserInfo) in
//            var uEntity = UserEntity.init(user: user)
//            uEntity.savedTime = saveTime
//            return uEntity
//        }
//        let json = JsonTool.toJson(fromObject: uEntities)
//        UserDefaults.standard.setValue(json, forKey: uid)
//        UserDefaults.standard.synchronize()
    }
    
    struct UserEntity: Codable {
        var userID: String?
        var nickname: String?
        var faceURL: String?
        var savedTime: Int = 0
        
        init(user: OIMUserInfo) {
            self.userID = user.userID
            nickname = user.nickname
            faceURL = user.faceURL
        }
        
        func toOIMUserInfo() -> OIMUserInfo {
            let item = OIMUserInfo.init()
            item.userID = userID
            item.nickname = nickname
            item.faceURL = faceURL
            return item
        }
    }
}

extension MainTabBarController {
    
    private func presentLoginController() {
        mainWebView.isLogin = true
        mainWebView.loadLocals()
        
        mainWebView.modalTransitionStyle = .coverVertical
        mainWebView.modalPresentationStyle = .custom
        self.present(mainWebView, animated: true)
    }
    
    func loginCheck() {
        let status = OIMManager.manager.getLoginStatus()
        switch status {
        case 1:
            if kUserToken.count == 0 {
                
                presentLoginController()
            } else {
                APIService.shared.checkToken { [weak self] result in
                    guard let `self` = self else { return }
                    switch result {
                    case .success(let model):
                        if model["data"].stringValue.count == 0 {
                            //data == "" 说明token未过期
                            OIMManager.manager.login(
                                kUserLoginModel["Id"].intValue.description,
                                token: kUserLoginModel["Token"].stringValue
                            ) { result in
                                debugPrint("----loginSuccess:", result ?? "")
                            
                                let event = EventLoginSucceed()
                                JNNotificationCenter.shared.post(event)
                            } onFailure: { code, message in
                                debugPrint("---------code:\(code), message: \(message ?? "")")
                            }
                            IMController.shared.uid = kUserLoginModel["Id"].intValue.description
                            IMController.shared.token = kUserLoginModel["Token"].stringValue
                        } else {
                            //token 过期
                            self.presentLoginController()
                        }
                        
                    case .failure(let error):
                        debugPrintS(error)
                        self.presentLoginController()
                    }
                }
            }
            
//        case 3:
            //已登录
//            NotificationCenter.default.post(name: TTNotifyName.App.OIMSDKLoginSuccess, object: nil)
        default:
            break
        }
    }
}


extension UITabBar {
    
    func removeBadgeOnItem(index: Int) {
        for subview in subviews {
            if subview.tag == 888+index {
                subview.removeFromSuperview()
            }
        }
    }
    
    func showBadgeOnItem(index: Int, count: Int) {
        removeBadgeOnItem(index: index)
        
        let bView = UIView()
        bView.tag = 888+index
        bView.layer.cornerRadius = 9
        bView.clipsToBounds = true
        bView.backgroundColor = .red
        
        let tabFrame = self.frame
        let percentX = (Float(index)+0.6)/4
        let x = CGFloat(ceilf(percentX*Float(tabFrame.width)))
        let y = CGFloat(ceilf(0.1*Float(tabFrame.height)))
        bView.frame = CGRect(x: x, y: y, width: 18, height: 18)
        
        let cLabel = UILabel()
        cLabel.text = "\(count)"
        cLabel.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        cLabel.font = .systemFont(ofSize: 10)
        cLabel.textColor = .white
        cLabel.textAlignment = .center
        bView.addSubview(cLabel)
        
        addSubview(bView)
        bringSubviewToFront(bView)
    }
}
