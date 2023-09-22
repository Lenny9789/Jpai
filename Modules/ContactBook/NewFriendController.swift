
import UIKit

class NewFriendController: BaseViewController {

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
        controller.placeholder = "搜索：好友"
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
        gk_navTitle = "新的好友"
        gk_navigationBar.isTranslucent = false
        view.backgroundColor = .viewBackgroundColor
        
//        view.addSubview(searchController)
//        searchController.whc_Top(kStatusAndNavBarHeight)
//            .whc_Left(0)
//            .whc_Right(0)
//            .whc_Height(44)
        
        view.addSubview(mainTableView)
        mainTableView.whc_Top(kStatusAndNavBarHeight)
            .whc_Left(0)
            .whc_Right(0)
            .whc_Bottom(0)
    }
    
    private func setupBindings() {
        mainTableView.rx.contentOffset.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            self.view.endEditing(true)
        }.disposed(by: disposeBag)
        
        viewModel.fetchNewFriends { [weak self] success in
            guard let `self` = self else { return }
            guard success else {
                return
            }
            
            self.mainTableView.reloadData()
        }
    }
    
    private var isSearching = false
    
    func didCellButtonTapped(_ index: Int) {
        let friend = viewModel.newFriendList[index]
        switch friend.handleResult {
        case .accept:
            viewModel.fetchConversationID(friend.fromUserID ?? "") { [weak self] conversation in
                guard let `self` = self else { return }
                let model = ChatViewModel()
                model.conversation = conversation
                let contrl = Chat2Controller(model: model)
                self.navigationController?.pushViewController(contrl, animated: true)
            }
            
        case .normal:
            TTProgressHUD.show()
            viewModel.acceptFriend(friend.fromUserID ?? "") { [weak self] success in
                guard let `self` = self else { return }
                TTProgressHUD.hide()
                guard success else {
                    return
                }
                self.viewModel.showToast("添加好友成功")
                
                self.viewModel.fetchNewFriends { [weak self] success in
                    guard let `self` = self else { return }
                    guard success else {
                        return
                    }
                    
                    self.mainTableView.reloadData()
                }
            }
        default:
            break
        }
        
    }
}

extension NewFriendController: UISearchBarDelegate {
    
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

extension NewFriendController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.newFriendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.newFriendList[indexPath.row]
        
        let cell = NewFriendCell()
        cell.present(model, indexPath: indexPath)
        cell.didButtonTapped = { [weak self] index in
            guard let `self` = self else { return }
            self.didCellButtonTapped(index)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        label.font = .fontSemibold(fontSize: 14)
        label.textColor = .systemGray
        label.text = "新的好友请求"
        view.addSubview(label)
        label.whc_Left(16)
            .whc_CenterY(0)
            .whc_WidthAuto()
            .whc_HeightAuto()
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
