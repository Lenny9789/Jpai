
import UIKit

class MessageSearchView: BaseView {

    lazy var textField: UITextField = {
        let textF = UITextField()
        textF.backgroundColor = .systemGray6
        textF.leftView = UIImageView(image: UIImage(color: .label))
        textF.attributedPlaceholder = NSAttributedString(
            string: "搜索",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray,
                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
        )
        return textF
    }()
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        addSubview(textField)
        textField.whc_CenterY(0)
            .whc_Left(16)
            .whc_Right(16)
            .whc_Height(30)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
