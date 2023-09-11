import UIKit


class SubscribeAndBuyCardView: UICollectionViewCell {
    
    lazy var bgView: UIButton = {
        let view = UIButton()
        view.theme_backgroundColor = ThemeGuide.Colors.theme_background
        view.setLayerCorner(
            radius: 10,
            corners: .allCorners,
            width: 1,
            color: .cgColor(ThemeGuide.Colors.primary.cgColor)
        )
        return view
    }()
    
    lazy var tipLabel: UILabel = {
        let view = UILabel(
            text: .localized_subscribeIts,
            font: UIFont.fontRegular(fontSize: 14),
            color: .themeColor(ThemeGuide.Colors.theme_title),
            lines: 1,
            align: .center
        )
        return view
    }()
    
    lazy var contentLabel: UILabel = {
        let view = UILabel(
            text: .localized_thisWorksForever,
            font: UIFont.fontRegular(fontSize: 12),
            color: .themeColor(ThemeGuide.Colors.theme_title),
            lines: 2,
            align: .center
        )
        return view
    }()
    
    lazy var amountLabel: UILabel = {
        let view = UILabel(
            text: "",
            font: UIFont.fontRegular(fontSize: 15),
            color: .themeColor(ThemeGuide.Colors.theme_title),
            lines: 1,
            align: .center
        )
        return view
    }()
    
    lazy var diamandView: UIImageView = {
        let view = UIImageView()
//        view.image = ThemeGuide.Icons.Me.wallet_diamond_small
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.setLayerCorner(radius: 8)
        view.theme_backgroundColor = ThemeGuide.Colors.theme_foreground
//        view.image = ThemeGuide.Icons.Home.works_pay_group_item_icon
        return view
    }()
    
    lazy var badgeBgView: UIImageView = {
        let view = UIImageView()
//        view.image = ThemeGuide.Icons.Home.works_subs_selection_normal
        return view
    }()
    
    
    func setSelectStatus(isSelected: Bool) {
        if isSelected == true {
            setLayerCorner(
                radius: 10,
                corners: .allCorners,
                width: 1,
                color: .cgColor(ThemeGuide.Colors.radioItemBorderAct.cgColor)
            )
            
            bgView.backgroundColor = ThemeGuide.Colors.radioItemBgAct
            tipLabel.theme_textColor = ThemeGuide.Colors.theme_title
            amountLabel.theme_textColor = ThemeGuide.Colors.theme_title
//            badgeBgView.image = ThemeGuide.Icons.Home.works_subs_selection_selected
            bgView.isSelected = true
        } else {
            setLayerCorner(
                radius: 10,
                corners: .allCorners,
                width: 1,
                color: .cgColor(ThemeGuide.Colors.radioItemBorderUn.cgColor)
            )
            
            bgView.backgroundColor = ThemeGuide.Colors.radioItemBgUn
            tipLabel.theme_textColor = ThemeGuide.Colors.theme_title
            amountLabel.theme_textColor = ThemeGuide.Colors.theme_title
//            badgeBgView.image = ThemeGuide.Icons.Home.works_subs_selection_normal
            bgView.isSelected = false
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.whc_AutoSize(left: 0, top: 0, right: 0, bottom: 0)
        
        addSubview(tipLabel)
        tipLabel.whc_Top(16)
            .whc_CenterX(0)
            .whc_WidthAuto()
            .whc_Height(20)
        
        addSubview(iconView)
        iconView.whc_Top(10, toView: tipLabel)
            .whc_CenterX(0)
            .whc_Width(50)
            .whc_Height(50)
            .setLayerCorner(radius: 25)
        
        addSubview(contentLabel)
        contentLabel.whc_Top(5, toView: iconView)
            .whc_CenterX(0)
            .whc_WidthAuto()
            .whc_Height(35)
        
        addSubview(diamandView)
        addSubview(amountLabel)
        addSubview(badgeBgView)
        badgeBgView.whc_Bottom(0)
            .whc_Right(0)
            .whc_Width(32)
            .whc_Height(32)
        
        amountLabel.whc_Bottom(5)
            .whc_Right(30)
            .whc_WidthAuto()
            .whc_Height(20)
        
        diamandView.whc_CenterYEqual(amountLabel)
            .whc_Right(5, toView: amountLabel)
            .whc_WidthAuto()
            .whc_HeightAuto()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
