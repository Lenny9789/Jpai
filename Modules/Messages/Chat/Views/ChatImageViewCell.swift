
import UIKit

class ChatImageViewCell: ChatMessageCell {

    /// 缩略图
    lazy var thumbImageView: UIImageView = {
        let view = UIImageView()
        
        view.contentMode = .scaleToFill
        view.backgroundColor = .clear
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        container.addSubview(thumbImageView)
        
        let tapThumb = UITapGestureRecognizer()
        thumbImageView.isUserInteractionEnabled = true
        thumbImageView.addGestureRecognizer(tapThumb)
        tapThumb.rx.event
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                
                self.eventDelegate?.cellAction(self, event: .pictureTapped)
            }).disposed(by: disposeBag)
    }
    
    override func fillWith(_ data: OIMMessageInfo) {
        super.fillWith(data)
        
        debugPrintS("imageUrl:\(data.pictureElem?.snapshotPicture?.url)")
        
        DispatchQueue.main.async {
            self.thumbImageView.setImage(
                withURL: URL(string: data.pictureElem?.snapshotPicture?.url),
                placeholderImage: nil
            )
        }
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        thumbImageView.whc_AutoSize(left: 0, top: 0, right: 0, bottom: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
