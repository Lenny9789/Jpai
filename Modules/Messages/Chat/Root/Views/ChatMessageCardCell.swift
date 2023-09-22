
import UIKit

class ChatMessageCardCell: ChatBubbleCell {

    lazy var cardAvatar: UIImageView = {
        let v = UIImageView()
        return v
    }()
    
    lazy var cardNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(white: 0, alpha: 0.7)
        label.font = .fontMedium(fontSize: 15)
        return label
    }()

    lazy var cardDescLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(white: 0, alpha: 0.5)
        label.font = .fontMedium(fontSize: 12)
        label.text = "名片"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        bubbleView.addSubview(cardAvatar)
        bubbleView.addSubview(cardNameLabel)
        bubbleView.addSubview(cardDescLabel)
        
        let tapThumb = UITapGestureRecognizer()
        bubbleView.isUserInteractionEnabled = true
        bubbleView.addGestureRecognizer(tapThumb)
        tapThumb.rx.event
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                
                self.eventDelegate?.cellAction(self, event: .cardTapped)
            }).disposed(by: disposeBag)
    }
    
    override func fillWith(_ data: OIMMessageInfo) {
        super.fillWith(data)
        
        bubbleView.image = UIImage(color: .clear)
        guard let card = data.cardElem else { return }
        
        cardAvatar.setImage(
            withURL: URL(string: card.faceURL),
            placeholderImage: UIImage(.systemRed, content: data.senderNickname ?? "", width: 40)
        )
        cardNameLabel.text = card.nickname
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bubbleView.backgroundColor = .white
        bubbleView.borderColor = .lightGray
        bubbleView.borderWidth = 1
        
        cardAvatar.whc_Left(20)
            .whc_Top(10)
            .whc_Width(40)
            .whc_Height(40)
            .setLayerCorner(radius: 5)
        
        cardNameLabel.whc_CenterYEqual(cardAvatar)
            .whc_Left(10, toView: cardAvatar)
            .whc_WidthAuto()
            .whc_HeightAuto()
        
        let line = UIView()
        line.backgroundColor = .lightGray
        bubbleView.addSubview(line)
        line.whc_Top(10, toView: cardAvatar)
            .whc_Left(10)
            .whc_Right(10)
            .whc_Height(1)
        
        cardDescLabel.whc_Top(5, toView: line)
            .whc_Left(20)
            .whc_WidthAuto()
            .whc_HeightAuto()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
