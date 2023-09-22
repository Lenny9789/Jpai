
import UIKit

class ChatTopNavView: BaseView {

    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(.init(named: "arrow.left"), for: .normal)
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
        button.setBackgroundImage(.init(named: "phone.arrow.normal"), for: .normal)
        button.setBackgroundImage(.init(named: "phone.arrow.highlight"), for: .highlighted)
        return button
    }()
    
    lazy var menuButon: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(nameInBundle: "common_more_btn_icon"), for: .normal)
        return button
    }()

    lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        
        addSubview(container)
        container.whc_Left(0)
            .whc_Right(0)
            .whc_Bottom(0)
            .whc_Height(44)
        
        backgroundColor = .white
        container.addSubview(backButton)
        backButton.whc_Left(16)
            .whc_CenterY(0)
            .whc_Width(30)
            .whc_Height(25)
        
        container.addSubview(titleLabel)
        titleLabel.whc_Top(0)
            .whc_CenterX(0)
            .whc_WidthAuto()
            .whc_Height(20)
        container.addSubview(statusView)
        statusView.whc_Top(3, toView: titleLabel)
            .whc_CenterX(0)
            .whc_WidthAuto()
            .whc_Height(20)
        
        container.addSubview(menuButon)
        menuButon.whc_Right(16)
            .whc_Width(30)
            .whc_Height(30)
            .whc_CenterYEqual(backButton)
        
        container.addSubview(callButon)
        callButon.whc_Right(10, toView: menuButon)
            .whc_CenterYEqual(menuButon)
            .whc_Width(25)
            .whc_Height(25)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
