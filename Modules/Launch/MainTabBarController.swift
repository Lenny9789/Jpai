import UIKit
//import PPBadgeViewSwift

class MainTabBarController: UITabBarController {

    private let disposeBag = DisposeBag()
    
    static let shared: MainTabBarController = MainTabBarController()
    
//    let viewModel = LoginViewModel()
    
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
        message.tabBarItem.image = R.image.tabbar_message_normal()
        message.tabBarItem.selectedImage = R.image.tabbar_message_selected()
        
        let contact = UINavigationController(rootVC: UIViewController())
        contact.gk_openScrollLeftPush = true
        contact.hidesBottomBarWhenPushed = true
        contact.tabBarItem.title = "通讯录"
        contact.tabBarItem.image = R.image.tabbar_contact_normal()
        contact.tabBarItem.selectedImage = R.image.tabbar_contact_selected()
        
        let mall = UINavigationController(rootVC: UIViewController())
        mall.gk_openScrollLeftPush = true
        mall.hidesBottomBarWhenPushed = true
        mall.tabBarItem.title = "商城"
        mall.tabBarItem.image = UIImage(named: "tabbar_icon_message_normal")
        mall.tabBarItem.selectedImage = UIImage(named: "tabbar_icon_message_selected")
        
        let me = UINavigationController(rootVC: UIViewController())
        me.gk_openScrollLeftPush = true
        me.hidesBottomBarWhenPushed = true
        me.tabBarItem.title = "我的"
        me.tabBarItem.image = R.image.tabbar_profile_normal()
        me.tabBarItem.selectedImage = R.image.tabbar_profile_selected()
        
        viewControllers = [message, contact, mall, me]
        tabBar.tintColor = .systemRed
        tabBar.backgroundColor = .white
        
//        NotificationCenter.default.rx.notification(TTNotifyName.App.needLogin)
//            .subscribe { [weak self] _ in
//                guard let `self` = self else { return }
//                self.setupLogin()
//            }.disposed(by: disposeBag)
    }

    private func setupBindings() {
        //登录页面
        loginCheck()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    private var isChecked: Bool = false
}

extension MainTabBarController {
    
    private func loginCheck() {
        let status = OIMManager.manager.getLoginStatus()
        switch status {
        case 1:
            if kUserToken.count == 0 {
                let contrl = MainWebView(url: localDebugIP)
                contrl.modalTransitionStyle = .coverVertical
                contrl.modalPresentationStyle = .popover
                self.present(contrl, animated: true)
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
                            
                            } onFailure: { code, message in
                                debugPrint("---------code:\(code), message: \(message ?? "")")
                            }
                        } else {
                            //token 过期
                            let contrl = MainWebView(url: localDebugIP)
                            contrl.modalTransitionStyle = .coverVertical
                            contrl.modalPresentationStyle = .popover
                            self.present(contrl, animated: true)
                        }
                        
                    case .failure(let error):
                        debugPrintS(error)
                    }
                }
            }
        case 3:
            //已登录
            NotificationCenter.default.post(name: TTNotifyName.App.OIMSDKLoginSuccess, object: nil)
            
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
