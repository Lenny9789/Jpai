//
//  AddMemberSelectCell.swift
//  minghaimuyuan
//

import UIKit

class AddMemberSelectCell: TableViewBaseCell {

    lazy var titleLabel: UILabel = {
        let label = UILabel(
            font: .fontMedium(fontSize: 14),
            color: .color(UIColor(hex: "#333333"))
        )
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel(
            font: .fontMedium(fontSize: 14),
            color: .color(UIColor(hex: "#989898"))
        )
        return label
    }()
    
    lazy var arrowImageV: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "home_family_member_add_arrow")
        return image
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
        
        contentView.addSubview(arrowImageV)
        arrowImageV.whc_Right(15)
            .whc_CenterY(0)
            .whc_Width(16)
            .whc_Height(16)
        
        contentView.addSubview(detailLabel)
        detailLabel.whc_CenterY(0)
            .whc_Right(5, toView: arrowImageV)
            .whc_WidthAuto()
            .whc_HeightAuto()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
