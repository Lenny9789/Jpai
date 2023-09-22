
import UIKit

class InfoTableFooterView: UIView {

    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(color: .systemRed), for: .normal)
        button.setTitle("保存", for: .normal)
        return button
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        
        addSubview(saveButton)
        saveButton.whc_CenterX(0)
            .whc_CenterY(0)
            .whc_Width(300)
            .whc_Height(45)
            .setLayerCorner(radius: 22.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
