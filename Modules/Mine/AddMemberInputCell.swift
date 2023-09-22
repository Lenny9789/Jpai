//
//  AddMemberInputCell.swift
//  minghaimuyuan
//

import UIKit

class AddMemberInputCell: TableViewBaseCell {

    lazy var textField: UITextField = {
        let textF = UITextField()
        textF.font = .fontMedium(fontSize: 14)
        textF.textColor = UIColor(hex: "#333333")
        textF.textAlignment = .right
        return textF
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(
            font: .fontMedium(fontSize: 14),
            color: .color(UIColor(hex: "#333333"))
        )
        return label
    }()
    
    init() {
        super.init(style: .default, reuseIdentifier: "cell")
        selectionStyle = .none
        backgroundColor = .init(white: 1, alpha: 0.8)
        
        contentView.addSubview(titleLabel)
        titleLabel.whc_Left(15)
            .whc_CenterY(0)
            .whc_WidthAuto()
            .whc_HeightAuto()
        contentView.addSubview(textField)
        textField.whc_Right(15)
            .whc_CenterY(0)
            .whc_Height(30)
            .whc_Width(200)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var placeHolder: String = "" {
        didSet {
            let attr = NSAttributedString(
                string: placeHolder,
                attributes: [NSAttributedString.Key.font : UIFont.fontMedium(fontSize: 14),
                             NSAttributedString.Key.foregroundColor: UIColor(hex: "#989898")]
            )
            textField.attributedPlaceholder = attr
        }
    }
}
