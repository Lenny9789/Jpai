
import UIKit

class AddFriendController: BaseViewController {

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
    
    lazy var searchController: UISearchBar = {
        let controller = UISearchBar()
        controller.placeholder = "搜索用户ID添加好友"
        controller.delegate = self
        return controller
    }()
    
    init(viewModel: ContactViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var viewModel: ContactViewModel!
    
    lazy var qRCodeCell: AddFriendCell = {
        let cell = AddFriendCell()
        cell.avatar.image = UIImage(color: .random)
        cell.titlelabel.text = "我的二维码"
        cell.desclabel.text = "邀请对方扫描，添加好友"
        return cell
    }()
    
    lazy var scanCell: AddFriendCell = {
        let cell = AddFriendCell()
        cell.avatar.image = UIImage(color: .random)
        cell.titlelabel.text = "扫一扫"
        cell.desclabel.text = "扫描二维码名片"
        return cell
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setupViews() {
        gk_navigationItem.hidesSearchBarWhenScrolling = false
        gk_navTitle = "添加好友"
        gk_navigationBar.isTranslucent = false
        view.backgroundColor = .viewBackgroundColor
        
        view.addSubview(searchController)
        searchController.whc_Top(kStatusAndNavBarHeight)
            .whc_Left(0)
            .whc_Right(0)
            .whc_Height(44)
        
        view.addSubview(mainTableView)
        mainTableView.whc_Top(0, toView: searchController)
            .whc_Left(0)
            .whc_Right(0)
            .whc_Bottom(0)
    }
    
    private func setupBindings() {
        mainTableView.rx.contentOffset.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            self.view.endEditing(true)
        }.disposed(by: disposeBag)
        
    }
    
    private var isSearching = false
}

extension AddFriendController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debugPrintS(searchText)
        guard searchText.count > 0 else {
            return
        }
        
        viewModel.searchFriendList = viewModel.friendList.filter({ item in
            item.showName.contains(searchText)
        })
        
        mainTableView.reloadData()
    }
}

extension AddFriendController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            QRCodeView().show(content: kUserLoginModel["Id"].intValue.description)
        default:
            break
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching { return viewModel.searchFriendList.count }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching {
            let model = viewModel.searchFriendList[indexPath.section]
            let cell = UITableViewCell()
            cell.imageView?.image = R.image.contact_my_friend_icon()
            cell.textLabel?.text = model.publicInfo?.nickname
            cell.textLabel?.text = model.showName
            cell.selectionStyle = .none
            return cell
        }else {
            if indexPath.row == 0 {
                return qRCodeCell
            }else {
                return scanCell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 18
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
