
import UIKit
import ProgressHUD

class ChatSettingsController: UIViewController {

    init(viewModel: SingleChatSettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var viewModel: SingleChatSettingViewModel!
    
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
        view.register(SingleChatMemberTableViewCell.self, forCellReuseIdentifier: SingleChatMemberTableViewCell.className)
        view.register(SingleChatRecordTableViewCell.self, forCellReuseIdentifier: SingleChatRecordTableViewCell.className)
        view.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.className)
        view.register(OptionTableViewCell.self, forCellReuseIdentifier: OptionTableViewCell.className)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupBindings()
    }
    
    private func setupViews() {
//        gk_navTitle = "聊天设置"
//        gk_navigationBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .viewBackgroundColor
        view.addSubview(mainTableView)
        mainTableView.whc_Top(kStatusAndNavBarHeight)
            .whc_Left(0)
            .whc_Right(0)
            .whc_Bottom(0)
    }
    
    private func setupBindings() {
        viewModel.getConversationInfo()
    }
    
    private var sectionItems: [[RowType]] = [
        [.members],
        [.clearRecord],
    ]
    
    func newGroup() {
        let vc = SelectContactsViewController()
//        vc.gk_navigationBar.isHidden = false
//        vc.gk_navTitle = "选择好友"
//        vc.gk_backStyle = .black
        vc.selectedContact() { [weak self] r in
            guard let self else { return }
            let users = r.map {UserInfo(userID: $0.ID!, nickname: $0.name, faceURL: $0.faceURL)}
            let vc = NewGroupViewController(users: users, groupType: .working)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        navigationController?.pushViewController(vc, animated: true)
        navigationController?.isNavigationBarHidden = false
    }
    
    enum RowType: CaseIterable {
        case members
        case clearRecord
        
        var title: String {
            switch self {
            case .members:
                return ""
            case .clearRecord:
                return "清空聊天记录".innerLocalized()
            }
        }
        
        var subTitle: String {
            switch self {
            default:
                return ""
            }
        }
    }
}

extension ChatSettingsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 12
    }
    
    func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_: UITableView, viewForFooterInSection _: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowType = sectionItems[indexPath.section][indexPath.row]
        
        if rowType == .members {
            return UITableView.automaticDimension
        }
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func numberOfSections(in _: UITableView) -> Int {
        return sectionItems.count
    }
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowType = sectionItems[indexPath.section][indexPath.row]
        switch rowType {
        case .members:
            let cell = tableView.dequeueReusableCell(withIdentifier: SingleChatMemberTableViewCell.className) as! SingleChatMemberTableViewCell
            viewModel.membesRelay.asDriver(onErrorJustReturn: []).drive(cell.memberCollectionView.rx.items) { (collectionView, row, item: UserInfo) in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SingleChatMemberTableViewCell.MemberCell.className, for: IndexPath(row: row, section: 0)) as! SingleChatMemberTableViewCell.MemberCell
                if item.isAddButton {
                    cell.avatarView.setAvatar(url: nil, text: nil, placeHolder: "setting_add_btn_icon")
                } else {
                    cell.avatarView.setAvatar(url: nil, text: nil, placeHolder: "contact_my_friend_icon")
                }
                cell.nameLabel.text = item.nickname
                
                return cell
            }.disposed(by: cell.disposeBag)
            
            cell.memberCollectionView.rx.modelSelected(UserInfo.self).subscribe(onNext: { [weak self] (userInfo: UserInfo) in
                guard let sself = self else { return }
                if userInfo.isAddButton {
                    sself.newGroup()
                } else {
                    let vc = UserDetailTableViewController(userId: userInfo.userID, groupId: sself.viewModel.conversation.groupID)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }).disposed(by: cell.disposeBag)
            return cell
            
        case .clearRecord:
            let cell = tableView.dequeueReusableCell(withIdentifier: OptionTableViewCell.className) as! OptionTableViewCell
            cell.titleLabel.text = rowType.title
            cell.titleLabel.textColor = .cFF381F
            
            return cell
        }
    }
    
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowType: RowType = sectionItems[indexPath.section][indexPath.row]
        switch rowType {
        case .clearRecord:
            presentAlert(title: "确认清空所有聊天记录吗？".innerLocalized()) {
                self.viewModel.clearRecord(completion: { _ in
                    ProgressHUD.showSuccess("清空成功".innerLocalized())
                })
            }
        default:
            break
        }
    }
}
