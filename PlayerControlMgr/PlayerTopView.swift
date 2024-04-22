//
//  PlayerTopView.swift
//  QSTY
//
//  Created by jsbaldpiao on 19/1/2024.
//

import UIKit

class PlayerTopView: BaseView {

    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(R.image.live_player_back(), for: .normal)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(hex: "#F8F8F7")
        label.font = .fontMedium(fontSize: 14)
        return label
    }()

    init() {
        super.init(frame: .zero)
        
        addSubview(backButton)
        backButton.whc_Top(8)
            .whc_Left(8)
            .whc_Width(28)
            .whc_Height(28)
        
        addSubview(titleLabel)
        titleLabel.whc_Left(0, toView: backButton)
            .whc_CenterYEqual(backButton)
            .whc_Right(20, true)
            .whc_HeightAuto()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
