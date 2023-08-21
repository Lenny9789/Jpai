import UIKit
import RxSwift

///带PlaceHolder的UITextView
///
open class TTPlaceHolderTextView: UITextView {
    var disposeBag = DisposeBag()

    /// 设置内容内间距（如果top或bottom等于0，则引用控件原始值）
    public var textInset: UIEdgeInsets?
    {
        didSet {
            let top = textInset!.top != 0 ? textInset!.top : self.textContainerInset.top
            let bottom = textInset!.bottom != 0 ? textInset!.bottom : self.textContainerInset.bottom
            self.textContainerInset = UIEdgeInsets(top: top, left: textInset!.left, bottom: bottom, right: textInset!.right)
        }
    }
    
    /// 设置PlaceHolder内间距（如果top等于0，则垂直居中）
    public var placeHolderInset: UIEdgeInsets?
    {
        didSet {
            placeHolderLabel.whc_Left(placeHolderInset!.left)
            if placeHolderInset!.top != 0 {
                placeHolderLabel.whc_Top(placeHolderInset!.top)
            }else {
                placeHolderLabel.whc_CenterY(0)
            }
        }
    }
        
    public lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
       super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeHolderLabel)
        placeHolderLabel.whc_Left(0)
            .whc_CenterY(0)
        /// 控制PlaceHolder显示是否
        self.rx.text.orEmpty
            .flatMap{ text -> Observable<String> in
                return Observable.create({ observer -> Disposable in
                    observer.onNext(text.trimmingCharacters(in: .whitespacesAndNewlines))
                    return Disposables.create()
                })
            }
            .map{ $0.count > 0}
            .share(replay: 1)
            .bind(to: self.placeHolderLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
