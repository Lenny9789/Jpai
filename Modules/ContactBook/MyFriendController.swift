
import UIKit

class MyFriendController: BaseViewController {

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
        gk_navTitle = "我的好友"
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
        
        viewModel.fetchFriends { [weak self] success in
            guard let `self` = self else { return }
            guard success else {
                return
            }
            
            self.mainTableView.reloadData()
        }
    }
    
    private var isSearching = false
}

extension MyFriendController: UISearchBarDelegate {
    
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

extension MyFriendController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = viewModel.friendList[indexPath.section]
        viewModel.fetchConversationID(friend.userID) { [weak self] conversation in
            guard let `self` = self else { return }
            let model = ChatViewModel()
            model.conversation = conversation
            let contrl = Chat2Controller(model: model)
            self.navigationController?.pushViewController(contrl, animated: true)
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel.friendList.map { item in
            item.NickNamePre()
        }
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching { return viewModel.searchFriendList.count }
        return viewModel.friendList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model = viewModel.friendList[indexPath.section]
        if isSearching {
            model = viewModel.searchFriendList[indexPath.section]
        }
        let cell = UITableViewCell()
        cell.imageView?.image = R.image.contact_my_friend_icon()
        cell.textLabel?.text = model.publicInfo?.nickname
        cell.textLabel?.text = model.showName
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        54
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        label.font = .fontSemibold(fontSize: 17)
        label.textColor = .black
        label.text = viewModel.friendList[section].NickNamePre()
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
        return 18
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
