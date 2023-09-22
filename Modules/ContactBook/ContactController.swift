
import UIKit

class ContactController: BaseViewController {

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
    
    lazy var newFriendCell: ContactCell = {
        let cell = ContactCell()
        cell.avatar.image = R.image.contact_new_friend_icon()
        cell.titlelabel.text = "新的好友"
        return cell
    }()
    lazy var groupNotiCell: ContactCell = {
        let cell = ContactCell()
        cell.avatar.image = R.image.contact_new_group_icon()
        cell.titlelabel.text = "群通知"
        return cell
    }()
    lazy var myFriendCell: ContactCell = {
        let cell = ContactCell()
        cell.avatar.image = R.image.contact_my_friend_icon()
        cell.titlelabel.text = "我的好友"
        return cell
    }()
    lazy var myGroupCell: ContactCell = {
        let cell = ContactCell()
        cell.avatar.image = R.image.contact_my_group_icon()
        cell.titlelabel.text = "我的群组"
        return cell
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    private func setupViews() {
//        let backItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .systemRed
        view.backgroundColor = .viewBackgroundColor
        
        view.addSubview(mainTableView)
        mainTableView.whc_Top(kStatusAndNavBarHeight)
            .whc_Left(0)
            .whc_Right(0)
            .whc_Bottom(0)
        
    }
    
    private func setupBindings() {
        
    }

}

extension ContactController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            return newFriendCell
        case (0,1):
            return groupNotiCell
        case (1, 0):
            return myFriendCell
        case (1, 1):
            return myGroupCell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let model = ContactViewModel()
            let contrl = NewFriendController(viewModel: model)
            navigationController?.pushViewController(contrl, animated: true)
        case (1, 0):
            let model = ContactViewModel()
            let contrl = MyFriendController(viewModel: model)
            navigationController?.pushViewController(contrl, animated: true)
        case (1, 1):
            let model = ContactViewModel()
            let contrl = MyGroupController(viewModel: model)
            navigationController?.pushViewController(contrl, animated: true)
        default:
            break
        }
    }
}
