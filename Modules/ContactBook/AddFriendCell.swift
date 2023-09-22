
import UIKit

class AddFriendCell: UITableViewCell {

    lazy var avatar: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var titlelabel: UILabel = {
        let label = UILabel()
        label.font = .fontMedium(fontSize: 17)
        label.textColor = .c0C1C33
        return label
    }()
    
    lazy var desclabel: UILabel = {
        let label = UILabel()
        label.font = .fontMedium(fontSize: 14)
        label.textColor = .c0C1C33
        return label
    }()
    
    init() {
        super.init(style: .default, reuseIdentifier: "cell")
        selectionStyle = .none
        backgroundColor = .cellBackgroundColor
        
        contentView.addSubview(avatar)
        avatar.whc_CenterY(0)
            .whc_Left(22)
            .whc_Width(44)
            .whc_Height(44)
        
        contentView.addSubview(titlelabel)
        titlelabel.whc_TopEqual(avatar)
            .whc_Left(18, toView: avatar)
            .whc_WidthAuto()
            .whc_HeightAuto()
        
        contentView.addSubview(desclabel)
        desclabel.whc_LeftEqual(titlelabel)
            .whc_WidthAuto()
            .whc_HeightAuto()
            .whc_Top(10, toView: titlelabel)
        
        accessoryType = .disclosureIndicator
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
