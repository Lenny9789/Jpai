import JXSegmentedView
import UIKit

class MyGroupController: BaseViewController {

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
        controller.placeholder = "搜索：群组"
        controller.delegate = self
        return controller
    }()
    lazy var dataSource: JXSegmentedTitleDataSource = {
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.isTitleColorGradientEnabled = true
        dataSource.titleSelectedColor = kMainColor
        dataSource.titleNormalColor = UIColor(hex: "#989898")
        dataSource.isTitleZoomEnabled = true
        dataSource.titleSelectedZoomScale = 1.3
        dataSource.titles = ["我创建的", "我加入的"]
        dataSource.itemSpacing = 20
        dataSource.isItemSpacingAverageEnabled = false
        dataSource.isTitleStrokeWidthEnabled = true
        return dataSource
    }()
    
    //    lazy var listContainerView: JXSegmentedListContainerView! = {
    //        return JXSegmentedListContainerView(dataSource: self)
    //    }()
    
    lazy var segmentedView: JXSegmentedView = {
        let view = JXSegmentedView()
        view.dataSource = dataSource
        view.delegate = self
        view.backgroundColor = .white
        return view
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
        gk_navTitle = "我的群组"
        gk_navigationBar.isTranslucent = false
        view.backgroundColor = .viewBackgroundColor
        
        view.addSubview(searchController)
        searchController.whc_Top(kStatusAndNavBarHeight)
            .whc_Left(0)
            .whc_Right(0)
            .whc_Height(44)
        view.addSubview(segmentedView)
        segmentedView.whc_Top(5, toView: searchController)
            .whc_Left(16)
            .whc_Right(16)
            .whc_Height(44)
            .setLayerCorner(radius: 5)
        
        view.addSubview(mainTableView)
        mainTableView.whc_Top(5, toView: segmentedView)
            .whc_Left(0)
            .whc_Right(0)
            .whc_Bottom(0, true)
    }
    
    private func setupBindings() {
        mainTableView.rx.contentOffset.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            self.view.endEditing(true)
        }.disposed(by: disposeBag)
        
        viewModel.fetchGroups { [weak self] success in
            guard let `self` = self else { return }
            guard success else {
                return
            }
            
            self.mainTableView.reloadData()
        }
    }
    
    private var isSearching = false
}

extension MyGroupController: JXSegmentedViewDelegate {
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        switch index {
        case 0:
            self.viewModel.groupPresent = "create"
        case 1:
            self.viewModel.groupPresent = "join"
        default:
            break
        }
        
        self.mainTableView.reloadData()
    }
}
extension MyGroupController: UISearchBarDelegate {
    
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
        
        if viewModel.groupPresent == "create" {
            viewModel.searchGroup = viewModel.groupCreate.filter({ item in
                item.groupName!.contains(searchText)
            })
        } else {
            viewModel.searchGroup = viewModel.groupJoined.filter({ item in
                item.groupName!.contains(searchText)
            })
        }
        mainTableView.reloadData()
    }
}

extension MyGroupController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
        if isSearching { return viewModel.searchGroup.count }
        if viewModel.groupPresent == "create" {
            return viewModel.groupCreate.count
        }
        return viewModel.groupJoined.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model: OIMGroupInfo
        if viewModel.groupPresent == "create" {
            model = viewModel.groupCreate[indexPath.section]
        } else {
            model = viewModel.groupJoined[indexPath.section]
        }
        if isSearching {
            model = viewModel.searchGroup[indexPath.section]
        }
        let cell = UITableViewCell()
        cell.imageView?.image = R.image.contact_my_group_icon()
        cell.textLabel?.text = model.groupName
//        cell.textLabel?.text = model.showName
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
