
import UIKit

class MineTopNavView: BaseView {

    lazy var avatar: UIImageView = {
        let img = UIImageView()
        img.size = CGSize(width: 40, height: 40)
        img.image = UIImage(.systemBlue, content: kUserInfoModel["NickName"].stringValue, width: 40)
        return img
    }()
    
    lazy var nickLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .init(white: 0, alpha: 0.8)
        
        return label
    }()
    
    lazy var idLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .white
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(
            R.image.common_qrcode_icon()?.withTintColor(.white, renderingMode: .automatic),
            for: .normal
        )
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        
        let bg = UIImageView()
        bg.image = R.image.message_nav_back()
        addSubview(bg)
        bg.whc_AutoSize(left: 0, top: 0, right: 0, bottom: 0)
        
        addSubview(avatar)
        avatar.whc_Top(kStatusBarHeight + 10)
            .whc_Left(16)
            .whc_Width(60)
            .whc_Height(60)
            .setLayerCorner(radius: 5)
        
        addSubview(nickLabel)
        nickLabel.whc_TopEqual(avatar)
            .whc_WidthAuto()
            .whc_Left(10, toView: avatar)
            .whc_Height(20)
        addSubview(idLabel)
        idLabel.whc_LeftEqual(nickLabel)
            .whc_Top(20, toView: nickLabel)
            .whc_WidthAuto()
            .whc_Height(15)
        
        
        addSubview(addButton)
        addButton.whc_CenterYEqual(avatar)
            .whc_Right(16)
            .whc_Width(35)
            .whc_Height(35)
        
        let tap = UITapGestureRecognizer()
        idLabel.addGestureRecognizer(tap)
        tap.rx.event.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            self.rx_didIDTapped.accept(())
        }.disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentInfo() {
        avatar.setImage(
            withURL: URL(string: kUserInfoModel["FaceURL"].stringValue),
            placeholderImage: UIImage(.lightText, content: kUserInfoModel["NickName"].stringValue, width: 40)
        )
        nickLabel.text = kUserInfoModel["NickName"].stringValue
        
        idLabel.text = "ID: " + kUserInfoModel["Id"].intValue.description
    }
    
    let rx_didIDTapped: PublishRelay<Void> = .init()
}
