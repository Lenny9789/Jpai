
import UIKit

class ChatMergeCell: ChatBubbleCell {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(white: 0, alpha: 0.7)
        label.font = .fontMedium(fontSize: 18)
        return label
    }()
    
    lazy var abs1Label: UILabel = {
        let label = UILabel()
        label.textColor = .init(white: 0, alpha: 0.5)
        label.font = .fontMedium(fontSize: 12)
        return label
    }()
    
    lazy var abs2Label: UILabel = {
        let label = UILabel()
        label.textColor = .init(white: 0, alpha: 0.5)
        label.font = .fontMedium(fontSize: 12)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        bubbleView.addSubview(titleLabel)
        bubbleView.addSubview(abs1Label)
        bubbleView.addSubview(abs2Label)
        
        let tapThumb = UITapGestureRecognizer()
        bubbleView.isUserInteractionEnabled = true
        bubbleView.addGestureRecognizer(tapThumb)
        tapThumb.rx.event
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                
                self.eventDelegate?.cellAction(self, event: .mergeTapped)
            }).disposed(by: disposeBag)
    }
    
    override func fillWith(_ data: OIMMessageInfo) {
        super.fillWith(data)
        
        bubbleView.image = UIImage(color: .clear)
        guard let merge = data.mergeElem else { return }
        
        titleLabel.text = merge.title
        abs1Label.text = merge.abstractList?.first
        abs2Label.text = merge.abstractList?.last
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bubbleView.backgroundColor = .white
        bubbleView.borderColor = .lightGray
        bubbleView.borderWidth = 1
        
        titleLabel.whc_Top(10)
            .whc_Left(10)
            .whc_WidthAuto()
            .whc_HeightAuto()
        
        let line = UIView()
        line.backgroundColor = .lightGray
        bubbleView.addSubview(line)
        line.whc_Top(10, toView: titleLabel)
            .whc_Left(10)
            .whc_Right(10)
            .whc_Height(1)
        
        abs1Label.whc_Top(5, toView: line)
            .whc_LeftEqual(titleLabel)
            .whc_WidthAuto()
            .whc_HeightAuto()
        abs2Label.whc_Top(5, toView: abs1Label)
            .whc_LeftEqual(titleLabel)
            .whc_WidthAuto()
            .whc_HeightAuto()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
