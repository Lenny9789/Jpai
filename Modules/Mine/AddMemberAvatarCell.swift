//
//  AddMemberAvatarCell.swift
//  minghaimuyuan
//

import UIKit

class AddMemberAvatarCell: TableViewBaseCell {

    lazy var titleLabel: UILabel = {
        let label = UILabel(
            font: .fontMedium(fontSize: 14),
            color: .color(UIColor(hex: "#333333"))
        )
        return label
    }()
    
    lazy var avatarImage: UIImageView = {
        let imageA = UIImageView()
        imageA.contentMode = .scaleAspectFill
        return imageA
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
        
        contentView.addSubview(avatarImage)
        avatarImage.whc_CenterY(0)
            .whc_Right(5, toView: arrowImageV)
            .whc_Width(48)
            .whc_Height(48)
            .setLayerCorner(radius: 24)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setAvatarMemorialType() {
        avatarImage.whc_ResetConstraints()
            .whc_Right(5, toView: arrowImageV)
            .whc_Top(10)
            .whc_Bottom(10)
            .whc_Width(80)
        avatarImage.backgroundColor = UIColor(hex: "#e7e7e7")
        avatarImage.setLayerCorner(radius: 5)
    }
}
