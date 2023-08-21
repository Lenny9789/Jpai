import UIKit

class TTImageToast: UIView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textColor = UIColor.white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var iconView: UIImageView = {
        let icon = UIImageView.init(frame: CGRect.zero)
        return icon
    }()
    
    open var text: String? {
        get { return self.titleLabel.text }
        set { self.titleLabel.text = newValue }
    }
    
    var position = TToastPosition.middle

    var keyBoardHeight: CGFloat = 0
    
    var superWidth = kScreenWidth
    var superHeight = kScreenHeight

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.iconView)
        self.addSubview(self.titleLabel)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(aNotification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(aNotification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        ScreenTools.share.screenClosure = { [weak self] (orientation) in
            self?.setNeedsLayout()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.superWidth = self.superview?.frame.width ?? kScreenWidth
        self.superHeight = self.superview?.frame.height ?? kScreenHeight

        let constraintSize = CGSize(
            width: superWidth - 80,
            height: CGFloat.greatestFiniteMagnitude
        )
        let textLabelSize = self.titleLabel.sizeThatFits(constraintSize)
        self.titleLabel.preferredMaxLayoutWidth = superWidth - 80
        
        let contentH: CGFloat = textLabelSize.height + 36 + 40
        
        var Y = self.superHeight*0.5 - contentH * 0.5
        
        if self.position == .middle {
            Y = self.superHeight*0.5 - contentH * 0.5
            if self.keyBoardHeight > 0 {
                Y = self.superHeight - self.keyBoardHeight - (contentH) - 20
            }
        }
        if self.position == .top {
            Y = 100
        }
        if self.position == .bottom {
            Y = self.superHeight - 100 - textLabelSize.height
            if self.keyBoardHeight > 0 {
                Y = self.superHeight - self.keyBoardHeight - (contentH) - 20
            }
        }
        
        self.frame = CGRect.init(x: 0.5*(superWidth-textLabelSize.width-60), y: Y, width: textLabelSize.width + 60, height: textLabelSize.height + 36 + 42)
        
        self.iconView.frame = CGRect.init(x: 0.5*(self.frame.width - 36), y: 14, width: 36, height:  36)

        self.titleLabel.frame = CGRect.init(x: 30, y: self.iconView.frame.maxY + 14, width: textLabelSize.width, height:  textLabelSize.height)
    }
    
    @objc func keyboardWillShow(aNotification: Notification) {
        let userInfo = aNotification.userInfo
        guard let info = userInfo else {
            return
        }
        let aValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        let keyboardRect = aValue?.cgRectValue
        let height = keyboardRect?.size.height
        self.keyBoardHeight = height ?? 0
        self.setNeedsLayout()
    }
    
    @objc func keyboardWillHide(aNotification: Notification) {
        self.keyBoardHeight = 0
        self.setNeedsLayout()
    }
}
