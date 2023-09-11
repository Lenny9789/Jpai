import UIKit

fileprivate let containerHeight = 44.0

/// 浏览器Navbar
class TMediaBrowserNavbar: UIView {
    
    /// 动作事件
    public enum ActionEvent {
        case backTapped
    }
    
    var eventBlock: ((ActionEvent)->())?
    var disposeBag = DisposeBag()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(R.image.memorial_navbar_dismiss(), for: .normal)
        return button
    }()
    
    deinit {
        debugPrint("deinit - \(self.classForCoder)")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .init(white: 0, alpha: 0.5)

        addSubview(backButton)

        backButton.whc_Bottom(0, true)
            .whc_Left(5)
            .whc_Width(containerHeight)
            .whc_Height(containerHeight)
        
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
}
