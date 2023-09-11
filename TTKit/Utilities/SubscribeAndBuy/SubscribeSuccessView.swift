import UIKit


class SubscribeSuccessView: UIView {

    lazy var headerImageView: UIImageView = {
        let image = UIImageView()
//        image.image = ThemeGuide.Icons.Common.subscribe_success_header
        return image
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.theme_backgroundColor = ThemeGuide.Colors.theme_foreground
        return view
    }()
    
    lazy var avatarImageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    lazy var headerTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .fontMedium(fontSize: 15)
        label.theme_textColor = ThemeGuide.Colors.theme_title
        return label
    }()
    
//    lazy var subedView: UserSubscribedView = {
//        let view = UserSubscribedView()
//        view.setGradient(
//            size: CGSize(width: UserSubscribedView.viewWidth(),
//                         height: UserSubscribedView.viewHeight()),
//            bgColors: ThemeGuide.Colors.flatBtnLightBgNor,
//            cornerRadius: UserSubscribedView.viewHeight()/2
//        )
//        return view
//    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .fontMedium(fontSize: 14)
        label.theme_textColor = ThemeGuide.Colors.theme_assist
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        
        addSubview(headerImageView)
        headerImageView.whc_Top(0)
            .whc_Left(0)
            .whc_Right(0)
            .whc_Height(113)
        
        addSubview(containerView)
        containerView.whc_Top(0, toView: headerImageView)
            .whc_Left(0)
            .whc_Right(0)
            .whc_Bottom(0)
        
        containerView.addSubview(avatarImageView)
        avatarImageView.whc_Top(20)
            .whc_CenterX(0)
            .whc_Width(50)
            .whc_Height(50)
            .setLayerCorner(radius: 25)
        
        containerView.addSubview(headerTitleLabel)
        headerTitleLabel.whc_Top(5, toView: avatarImageView)
            .whc_CenterX(0)
            .whc_Height(20)
            .whc_WidthAuto()
        
//        containerView.addSubview(subedView)
//        subedView.whc_Top(25, toView: headerTitleLabel)
//            .whc_CenterX(0)
//            .whc_Width(UserSubscribedView.viewWidth())
//            .whc_Height(UserSubscribedView.viewHeight())
        
//        containerView.addSubview(dateLabel)
//        dateLabel.whc_Top(10, toView: subedView)
//            .whc_CenterX(0)
//            .whc_WidthAuto()
//            .whc_Height(20)
//            .whc_Bottom(20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}
