import UIKit
import ZLPhotoBrowser

class InfoViewController: BaseViewController {

    init(model: InfoViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = model
        self.viewModel.setupAlertDelegator(with: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var viewModel: InfoViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupBindings()
    }
    
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
    
    lazy var footerView: InfoTableFooterView = {
        let view = InfoTableFooterView()
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    private func setupViews() {
        title = "个人资料"
        
        view.backgroundColor = .viewBackgroundColor
        
        view.addSubview(mainTableView)
        mainTableView.whc_Top(kSafeAreaTopHeight() + kNavBarHeight)
            .whc_Left(0)
            .whc_Right(0)
            .whc_Bottom(0)
        
        mainTableView.tableFooterView = footerView
        mainTableView.tableFooterView?.height = 85
        
        present()
    }
    
    lazy var avatarCell: AddMemberAvatarCell = {
        let cell = AddMemberAvatarCell()
        cell.titleLabel.text = "头像"
        cell.avatarImage.image = UIImage(color: .systemRed)
        return cell
    }()
    lazy var nameCell: AddMemberInputCell = {
        let cell = AddMemberInputCell()
        cell.titleLabel.text = "昵称"
        cell.placeHolder = "请输入昵称"
        return cell
    }()
    lazy var phoneCell: AddMemberInputCell = {
        let cell = AddMemberInputCell()
        cell.titleLabel.text = "手机号码"
        cell.placeHolder = "请输入手机号码"
        return cell
    }()
    lazy var emailCell: AddMemberInputCell = {
        let cell = AddMemberInputCell()
        cell.titleLabel.text = "邮箱"
        cell.placeHolder = "请输入邮箱地址"
        return cell
    }()
    lazy var sexSelectCell: AddMemberSelectCell = {
        let cell = AddMemberSelectCell()
        cell.titleLabel.text = "性别"
        return cell
    }()
    lazy var birthdayCell: AddMemberSelectCell = {
        let cell = AddMemberSelectCell()
        cell.titleLabel.text = "出日"
        return cell
    }()
    
    
    private func setupBindings() {
        mainTableView.rx.contentOffset.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            self.view.endEditing(true)
        }.disposed(by: disposeBag)
        
        viewModel.rx_didUpdateSuccess.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            
            self.navigationController?.popViewController()
        }.disposed(by: disposeBag)
        
        footerView.saveButton.rx.tap.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            
            self.updateInfo()
        }.disposed(by: disposeBag)
        
    }
    
    private func present() {
        // 模型数据回填
        self.avatarCell.avatarImage.setImage(
            withURL: URL(string: kUserInfoModel["FaceURL"].stringValue),
            placeholderImage: UIImage(.systemRed, content: kUserInfoModel["NickName"].stringValue, width: 40)
        )
        self.viewModel.uploadedUrl = kUserInfoModel["FaceURL"].stringValue
        self.nameCell.textField.text = kUserInfoModel["NickName"].stringValue
        self.birthdayCell.detailLabel.text = kUserInfoModel["Birth"].stringValue
        self.viewModel.birthDate = kUserInfoModel["Birth"].stringValue
        self.sexSelectCell.detailLabel.text = kUserInfoModel["Gender"].intValue == 1 ? "男" : "女"
        self.viewModel.selectedSex = kUserInfoModel["Gender"].intValue
        self.phoneCell.textField.text = kUserInfoModel["Phone"].stringValue
        self.emailCell.textField.text = kUserInfoModel["Email"].stringValue
    }
    
    private func updateInfo() {
        
        let NickName = nameCell.textField.text ?? ""
        let gender = viewModel.selectedSex
        let birth = viewModel.birthDate
        let phone = phoneCell.textField.text ?? ""
        let email = emailCell.textField.text ?? ""
        let avatar = viewModel.uploadedUrl
        let param: Param = ["NickName": NickName,
                            "FaceURL": avatar,
                            "Birth": birth,
                            "Email": email,
                            "Phone": phone,
                            "Gender": gender]
        viewModel.updateInfo(param)
    }
}

extension InfoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 2
        
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                avatarCell.setLayerCorner(radius: 5, corners: .topCorners)
                return avatarCell
            case 1:
                return nameCell
            case 2:
                return sexSelectCell
            case 3:
                birthdayCell.setLayerCorner(radius: 5, corners: .bottomCorners)
                return birthdayCell
            default:
                break
            }
        case 1:
            if indexPath.row == 0 {
                phoneCell.setLayerCorner(radius: 5, corners: .topCorners)
                return phoneCell
            }else {
                emailCell.setLayerCorner(radius: 5, corners: .bottomCorners)
                return emailCell
            }
            
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                return 60
            }else {
                return 45
            }
        case 1:
            return 45
        
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let config = ZLPhotoConfiguration.default()
                config.allowMixSelect = false
                config.allowSelectVideo = false
                config.maxSelectCount = 1
                let controller = ZLPhotoPreviewSheet()
                controller.selectImageBlock = { [weak self] results, isOrigin in
                    guard let `self` = self else { return }
                    guard let asset = results.first?.asset else { return }
                    
                    self.viewModel.showLoader()
                    self.viewModel.upload(asset) { success in
                        self.viewModel.hideLoader()
                        guard success else { return }
                        
                        self.updateInfo()
                    }
                }
                controller.showPreview(animate: true, sender: self)
                
            case 2:
                let model = AppMultiplesPopViewModel()
                let controller = AppMultiplesPopViewController(viewModel: model, types: .sexSelect)
                controller.isTouchBackGroundDismiss = true
                self.present(controller, animated: true, completion: nil)
                model.rx_didSexSelectedTapped.subscribe { event in
                    guard let sex = event.element else { return }
                    self.sexSelectCell.detailLabel.text = sex.1
                    self.viewModel.selectedSex = sex.0 + 1
                }.disposed(by: disposeBag)
              
            case 3:
                let model = AppMultiplesPopViewModel()
                let controller = AppMultiplesPopViewController(
                    viewModel: model,
                    types: .dateSelect
                )
                controller.isTouchBackGroundDismiss = true
                self.present(controller, animated: true, completion: nil)
                model.rx_didDateSelectedTapped.subscribe { event in
                    guard let date = event.element else { return }
                    
                    self.birthdayCell.detailLabel.text = date

                    self.viewModel.birthDate = date
                }.disposed(by: disposeBag)
                
            default:
                break
            }
        default:
            break
        }
    }
}
