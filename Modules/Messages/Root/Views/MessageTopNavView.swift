
import UIKit

class MessageTopNavView: BaseView {

    lazy var avatar: UIImageView = {
        let img = UIImageView()
        img.size = CGSize(width: 40, height: 40)
        img.image = UIImage(.systemBlue, content: kUserLoginModel["NickName"].stringValue, width: 40)
        return img
    }()
    
    lazy var nickLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .init(white: 0, alpha: 0.8)
        label.size = CGSize(width: 120, height: 40)
        return label
    }()
    
    lazy var statusView: OnlineStatusView = {
        let view = OnlineStatusView()
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        
        let bg = UIImageView()
        bg.image = R.image.message_nav_back()
        addSubview(bg)
        bg.whc_AutoSize(left: 0, top: 0, right: 0, bottom: 0)
        
        addSubview(avatar)
        avatar.whc_Top(kStatusBarHeight)
            .whc_Left(16)
            .whc_Width(40)
            .whc_Height(40)
            .setLayerCorner(radius: 5)
        
        addSubview(nickLabel)
        nickLabel.whc_CenterYEqual(avatar)
            .whc_WidthAuto()
            .whc_Left(10, toView: avatar)
            .whc_Height(20)
        
        addSubview(statusView)
        statusView.whc_CenterYEqual(avatar)
            .whc_Left(5, toView: nickLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class OnlineStatusView: BaseView {
    
    lazy var colorStatus: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(color: .systemGreen)
        return img
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .init(white: 0, alpha: 0.7)
        label.text = "手机在线"
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        addSubview(colorStatus)
        colorStatus.whc_CenterY(0)
            .whc_Left(5)
            .whc_Width(10)
            .whc_Height(10)
            .setLayerCorner(radius: 5)
        
        addSubview(statusLabel)
        statusLabel.whc_CenterY(0)
            .whc_Left(3, toView: colorStatus)
            .whc_WidthAuto()
            .whc_Height(15)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func present(_ status: ConnectionStatus) {
        if status == .connected || status == .syncStart || status == .syncComplete {
            colorStatus.image = UIImage(color: .systemGreen)
            statusLabel.text = "手机在线"
        }else {
            colorStatus.image = UIImage(color: .systemGray3)
            statusLabel.text = status.title
        }
        
        
    }
}
