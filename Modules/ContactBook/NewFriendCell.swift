
import UIKit

class NewFriendCell: UITableViewCell {

    let disposeBag = DisposeBag()
    
    lazy var avatar: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var titlelabel: UILabel = {
        let label = UILabel()
        label.font = .fontMedium(fontSize: 17)
        label.textColor = .c0C1C33
        return label
    }()
    
    lazy var desclabel: UILabel = {
        let label = UILabel()
        label.font = .fontMedium(fontSize: 14)
        label.textColor = .c0C1C33
        return label
    }()
    
    lazy var resultButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(color: .systemBlue), for: .normal)
        
        button.setBackgroundImage(UIImage(color: .lightGray), for: .disabled)
        
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.black, for: .disabled)
        button.titleLabel?.font = .fontMedium(fontSize: 15)
        return button
    }()
    
    init() {
        super.init(style: .default, reuseIdentifier: "cell")
        selectionStyle = .none
        backgroundColor = .cellBackgroundColor
        
        contentView.addSubview(avatar)
        avatar.whc_CenterY(0)
            .whc_Left(16)
            .whc_Width(44)
            .whc_Height(44)
        
        contentView.addSubview(titlelabel)
        titlelabel.whc_TopEqual(avatar)
            .whc_Left(18, toView: avatar)
            .whc_WidthAuto()
            .whc_HeightAuto()
        
        contentView.addSubview(desclabel)
        desclabel.whc_LeftEqual(titlelabel)
            .whc_WidthAuto()
            .whc_HeightAuto()
            .whc_Top(5, toView: titlelabel)
        
        contentView.addSubview(resultButton)
        resultButton.whc_CenterY(0)
            .whc_Right(16)
            .whc_Width(60)
            .whc_Height(35)
            .setLayerCorner(radius: 5)
        
        resultButton.rx.tap.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            self.didButtonTapped?(self.indexPath.row)
        }.disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var didButtonTapped: ( (Int) -> Void)?
    
    private var indexPath: IndexPath!
    func present(_ model: OIMFriendApplication, indexPath: IndexPath) {
        self.indexPath = indexPath
        avatar.setImage(
            withURL: URL(string: model.fromFaceURL),
            placeholderImage: UIImage(.systemBlue, content: model.fromNickname ?? "", width: 40)
        )
        titlelabel.text = model.fromNickname
        desclabel.text = model.reqMsg
        
        switch model.handleResult {
        case .decline:
            resultButton.isEnabled = false
            resultButton.setTitle("已拒绝", for: .disabled)
        case .normal:
            resultButton.setTitle("同意", for: .normal)
        case .accept:
            resultButton.setTitle("打招呼", for: .normal)
        default:
            break
        }
    }
}
