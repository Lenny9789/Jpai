import UIKit


class SubscribeTypeCell: UITableViewCell {
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            var frame = newValue
            frame.origin.x += 16
            frame.size.width -= 32
            frame.origin.y += 5
            frame.size.height -= 10
            super.frame = frame
        }
    }
    
    lazy var iconImageView: UIImageView = {
        let view = UIImageView()
//        view.image = ThemeGuide.Icons.Default.default_subscribe50
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel(
            text: "****",
            font: UIFont.fontRegular(fontSize: 15),
            color: .themeColor(ThemeGuide.Colors.theme_title)
        )
        return view
    }()
    
    lazy var diamandImageView: UIImageView = {
        let view = UIImageView()
//        view.image = ThemeGuide.Icons.Me.wallet_diamond_small
        return view
    }()
    
    lazy var numberLabel: UILabel = {
        let view = UILabel(
            text: "----",
            font: UIFont.fontRegular(fontSize: 15),
            color: .themeColor(ThemeGuide.Colors.theme_title)
        )
        return view
    }()
    
    private lazy var selectButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
//        button.setImage(ThemeGuide.Icons.Common.radiobox_selected, for: .normal)
        return button
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            selectButton.isHidden = false
            backgroundColor = ThemeGuide.Colors.radioItemBgAct
            setLayerCorner(
                radius: 10,
                corners: .allCorners,
                width: 1, color: .cgColor(ThemeGuide.Colors.radioItemBorderAct.cgColor)
            )
        } else {
            backgroundColor = ThemeGuide.Colors.radioItemBgUn
            setLayerCorner(
                radius: 10,
                corners: .allCorners,
                width: 1, color: .cgColor(ThemeGuide.Colors.radioItemBorderUn.cgColor)
            )
        }
    }
    
    init() {
        super.init(style: .default, reuseIdentifier: nil)
        selectionStyle = .none
        
        backgroundColor = ThemeGuide.Colors.radioItemBgUn
        setLayerCorner(
            radius: 10,
            corners: .allCorners,
            width: 1,
            color: .cgColor(ThemeGuide.Colors.radioItemBorderUn.cgColor)
        )
        
        contentView.addSubview(iconImageView)
        iconImageView.whc_Left(6)
            .whc_Width(30)
            .whc_Height(30)
            .whc_CenterY(0)
            .setLayerCorner(radius: 15)
        
        contentView.addSubview(titleLabel)
        titleLabel.whc_CenterY(0)
            .whc_Left(5, toView: iconImageView)
            .whc_WidthAuto()
            .whc_Height(20)
        
        contentView.addSubview(diamandImageView)
        contentView.addSubview(numberLabel)
        contentView.addSubview(selectButton)
        selectButton.whc_Right(13)
            .whc_CenterY(0)
            .whc_WidthAuto()
            .whc_HeightAuto()
        
        numberLabel.whc_Right(18, toView: selectButton)
            .whc_CenterY(0)
            .whc_WidthAuto()
            .whc_Height(20)
        diamandImageView.whc_CenterY(0)
            .whc_Right(6.5, toView: numberLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
