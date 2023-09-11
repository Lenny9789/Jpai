import UIKit
import ZFPlayer

fileprivate let containerHeight = 44.0
fileprivate let avatarHeight = 40.0
fileprivate let buyWidth = 90.0
fileprivate let buyHeight = 32.0

/// 浏览器Navbar
class ContentBrowserNavbar: UIView {
    
    /// 动作事件
    public enum ActionEvent {
        case backTapped
        case buyTapped
        case avatarTapped
    }
    
    /// 倒计时值
    enum CountdownValue {
        case remainSecond(Int)
        case hidden
    }
    
    var eventBlock: ((ActionEvent)->())?
    var disposeBag = DisposeBag()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(R.image.comment_close_btn(), for: .normal)
        return button
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .fontMedium(fontSize: 15)
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    
    deinit {
        debugPrint("deinit - \(self.classForCoder)")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .init(white: 0, alpha: 0.5)

        addSubview(backButton)
        addSubview(timeLabel)
        

        backButton.whc_Bottom(0, true)
            .whc_Left(5)
            .whc_Width(containerHeight)
            .whc_Height(containerHeight)
        timeLabel.whc_CenterYEqual(backButton)
            .whc_Left(0, toView: backButton)

        // 返回点击
        backButton.rx.tap
            .subscribe({ [weak self] (_) in
                self?.eventBlock?(.backTapped)
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func viewHeight() -> CGFloat {
        var height: CGFloat = 0
        height += kSafeAreaTopHeight()
        height += containerHeight
        return height
    }
    
    func updateCountdownAndBuy(value: CountdownValue) {
        switch value {
        case .remainSecond(let seconds):
            timeLabel.isHidden = false
            if let remainStr = ZFUtilities.convertTimeSecond(seconds) {
                timeLabel.text = "\(remainStr)"
            }
            
        case .hidden:
            timeLabel.isHidden = true
        }
        
    }
}
