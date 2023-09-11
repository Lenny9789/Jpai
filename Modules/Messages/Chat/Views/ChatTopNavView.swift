
import UIKit

class ChatTopNavView: BaseView {

    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(R.image.icon_back(), for: .normal)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .init(white: 0, alpha: 0.8)
        return label
    }()
    
    lazy var statusView: OnlineStatusView = {
        let view = OnlineStatusView()
        view.colorStatus.image = UIImage(color: .gray)
        view.statusLabel.text = "离线"
        return view
    }()
    
    lazy var callButon: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(color: .random), for: .normal)
        return button
    }()
    
    lazy var menuButon: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(color: .random), for: .normal)
        return button
    }()

    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        addSubview(backButton)
        backButton.whc_Left(16)
            .whc_Top(kStatusBarHeight + 5)
            .whc_Width(30)
            .whc_Height(25)
        
        addSubview(titleLabel)
        titleLabel.whc_Top(kStatusBarHeight)
            .whc_CenterX(0)
            .whc_WidthAuto()
            .whc_Height(20)
        addSubview(statusView)
        statusView.whc_Top(3, toView: titleLabel)
            .whc_CenterX(0)
            .whc_WidthAuto()
            .whc_Height(20)
        
        addSubview(menuButon)
        menuButon.whc_Right(16)
            .whc_Width(40)
            .whc_Height(30)
            .whc_CenterYEqual(backButton)
        
        addSubview(callButon)
        callButon.whc_Right(10, toView: menuButon)
            .whc_CenterYEqual(menuButon)
            .whc_Width(40)
            .whc_Height(30)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
