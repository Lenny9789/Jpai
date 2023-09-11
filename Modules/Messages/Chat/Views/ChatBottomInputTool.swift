
import UIKit

class ChatBottomInputTool: BaseView {

    static let height: CGFloat = kIsIPhoneX() ? 84 : 49
    
    lazy var voiceButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(R.image.chating_footer_audio(), for: .normal)
        return button
    }()
    
    lazy var textInputView: UITextField = {
        let textF = UITextField()
        textF.font = .fontMedium(fontSize: 14)
        textF.textColor = .init(hex: "#333333")
        textF.backgroundColor = .white
//        textF.setLayerCorner(radius: 20)
        textF.setValue(10, forKey: "paddingLeft")
        textF.setValue(20, forKey: "paddingRight")
        textF.delegate = self
        return textF
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        button.setBackgroundImage(R.image.chating_footer_add(), for: .normal)
        return button
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: "#989898")
        view.isHidden = true
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .init(hex: "#f5f5f5")
        
        addSubview(lineView)
        lineView.whc_Top(0)
            .whc_Height(0.5)
            .whc_Left(0)
            .whc_Right(0)
        
        addSubview(voiceButton)
        voiceButton.whc_Top(10)
            .whc_Left(16)
            .whc_Width(30)
            .whc_Height(30)
        
        addSubview(textInputView)
        textInputView.whc_Left(10, toView: voiceButton)
            .whc_Top(10)
            .whc_Height(30)
        
        addSubview(addButton)
        addButton.whc_Width(30)
        addButton.whc_Height(30)
            .whc_Top(10)
            .whc_Right(16)
        
        textInputView.whc_Right(10, toView: addButton)
        
    
            
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var didReturnTapped: ( (String) -> Void)?
}

extension ChatBottomInputTool: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didReturnTapped?(textField.text ?? "")
        return true
    }
}
