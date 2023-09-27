
import UIKit

class MineViewController: BaseViewController {

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
        
        return view
    }()
    
    lazy var mainNavView: MineTopNavView = {
        let view = MineTopNavView()
        return view
    }()
    
    let infoModel = InfoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        guard let id = kUserInfoModel["Id"].int, id >= 0 else {
            infoModel.fetchUserInfo { [weak self] success in
                guard let `self` = self else { return }
                guard success else { return }
                self.mainNavView.presentInfo()
            }
            return
        }
        
        mainNavView.presentInfo()
    }
    private func setupViews() {
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .systemRed
        
        view.backgroundColor = .viewBackgroundColor
        
        view.addSubview(mainNavView)
        mainNavView.whc_Top(0)
            .whc_Left(0)
            .whc_Right(0)
            .whc_Height(kStatusAndNavBarHeight + 40)
        
        view.addSubview(mainTableView)
        mainTableView.whc_Top(0, toView: mainNavView)
            .whc_Left(0)
            .whc_Right(0)
            .whc_Bottom(0, true)
        
        mainNavView.presentInfo()
    }
    
    private func setupBindings() {
        mainNavView.addButton.rx.tap.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            
            let vc = QRCodeViewController(idString: IMController.addFriendPrefix.append(string: kUserInfoModel["Id"].intValue.description))
            vc.nameLabel.text = kUserInfoModel["NickName"].string
            vc.avatarView.setAvatar(
                url: kUserInfoModel["FaceURL"].string,
                text: kUserInfoModel["NickName"].string
            )
            vc.tipLabel.text = "扫一扫下面的二维码，添加为好友"
            self.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
        mainNavView.rx_didIDTapped.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            
            UIPasteboard.general.string = kUserInfoModel["Id"].intValue.description
            TToast.show("ID已复制到剪切板")
        }.disposed(by: disposeBag)
    }

}

extension MineViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MineTableCell()
        switch indexPath.row {
        case 0:
            cell.avatar.image = UIImage(named: "info.square")
            cell.titlelabel.text = "用户信息"
            cell.setLayerCorner(radius: 5, corners: .topCorners)
        case 1:
            cell.avatar.image = UIImage(named: "mine.safe")
            cell.titlelabel.text = "安全信息"
        case 2:
            cell.avatar.image = UIImage(named: "wallet.pass")
            cell.titlelabel.text = "钱包信息"
        case 3:
            cell.avatar.image = UIImage(named: "accountsettings")
            cell.titlelabel.text = "账号设置"
        case 4:
            cell.avatar.image = UIImage(named: "mine.about")
            cell.titlelabel.text = "关于我们"
        case 5:
            cell.avatar.image = UIImage(named: "mine.exit")
            cell.titlelabel.text = "退出登录"
            cell.setLayerCorner(radius: 5, corners: .bottomCorners)
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        16
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let model = InfoViewModel()
            let controller = InfoViewController(model: model)
            self.navigationController?.pushViewController(controller, animated: true)
        case 2:
            let pay = MainWebView()
            pay.isPayment = true
            pay.loadLocals()
            navigationController?.pushViewController(pay, animated: true)
        case 5:
            showAlert(title: "提示", message: "确认退出登录吗？", buttonTitles: ["取消", "确认"]) { index in
                guard index > 0 else {
                    return
                }
                
                OIMManager.manager.logoutWith { message in
                    debugPrint(message)
                    
                    kUserToken = ""
                    kUserLoginModel = JSON()
                    kUserInfoModel = JSON()
                    
                    MainTabBarController.shared.selectedIndex = 0
                    MainTabBarController.shared.loginCheck()
                }
            }
            
            
        default:
            break
        }
    }
}
