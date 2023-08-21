import UIKit
import RxSwift

public protocol TTAlertTextCellDelegate: AnyObject {
    func alertTextCell(_ cell: TTAlertTextCell, didClickRadio isSelected: Bool)
}

public class TTAlertTextCell: UITableViewCell {

    // MARK: - Variables
    public weak var delegate: TTAlertTextCellDelegate?
    private var disposeBag = DisposeBag()
    var radioNormalImage: UIImage?
    var radioSelectedImage: UIImage?
    var isRadioSelected = false

    lazy var titleLabel: UILabel = {
        let label = UILabel(
            text: "",
            font: UIFont.fontMedium(fontSize: 14),
            color: .color(UIColor(hex: "#333333")),
            lines: 0,
            align: .center
        )
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel(
            text: "",
            font: UIFont.fontMedium(fontSize: 16),
            color: .color(UIColor(hex: "#333333")),
            lines: 0,
            align: .center
        )
        return label
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel(
            text: "",
            font: UIFont.fontRegular(fontSize: 13),
            color: .color(UIColor(hex: "#333333")),
            lines: 0,
            align: .center
        )
        return label
    }()
    
    lazy var radioImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var radioLabel: UILabel = {
        let label = UILabel(
            text: "",
            font: UIFont.fontRegular(fontSize: 13),
            color: .color(UIColor(hex: "#333333")),
            lines: 1,
            align: .left
        )
        return label
    }()
    
    // MARK: Initialization Methods
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        // Radio-Image点击
        let tapRadioImage = UITapGestureRecognizer()
        radioImage.isUserInteractionEnabled = true
        radioImage.addGestureRecognizer(tapRadioImage)
        tapRadioImage.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.toggleSelectRadio()
            })
            .disposed(by: disposeBag)
        
        // Radio-Label点击
        let tapRadioLabel = UITapGestureRecognizer()
        radioLabel.isUserInteractionEnabled = true
        radioLabel.addGestureRecognizer(tapRadioLabel)
        tapRadioLabel.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.toggleSelectRadio()
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout Methods
    override public func layoutSubviews() {
        super.layoutIfNeeded()
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }
    
    func toggleSelectRadio() {
        self.isRadioSelected = !self.isRadioSelected

        if let radioNormalImage = self.radioNormalImage, let radioSelectedImage = self.radioSelectedImage {
            self.radioImage.image = self.isRadioSelected ? radioSelectedImage : radioNormalImage
        }
        
        if let delegate = self.delegate {
            delegate.alertTextCell(self, didClickRadio: self.isRadioSelected)
        }
    }
}

extension TTAlertTextCell {
    
    public func setTitle(_ title: String?,
                         titleFont: UIFont?,
                         titleColor: TTColor?,
                         subtitle: NSAttributedString?,
                         subtitleFont: UIFont?,
                         subtitleColor: TTColor?,
                         message: String?,
                         messageFont: UIFont?,
                         messageColor: TTColor?,
                         radioText: String?,
                         radioFont: UIFont?,
                         radioColor: TTColor?,
                         radioNormalImage: UIImage?,
                         radioSelectedImage: UIImage?,
                         isRadioSelected: Bool,
                         textEdgeInsets: UIEdgeInsets,
                         subtitleTop: CGFloat,
                         messageTop: CGFloat,
                         radioTop: CGFloat,
                         actionsCount: Int) {
        self.radioNormalImage = radioNormalImage
        self.radioSelectedImage = radioSelectedImage

        for (_, item) in contentView.allSubviews().enumerated() {
            item.removeFromSuperview()
        }

        var lastView: UIView?

        if let title = title {
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(titleLabel)

            titleLabel.text = title
            titleLabel.font = titleFont
            switch titleColor {
            case .color(let color):
                titleLabel.textColor = color
            #if canImport(SwiftTheme)
            case .themeColor(let themeColor):
                titleLabel.theme_textColor = themeColor
            #endif
            default:
                break
            }
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: textEdgeInsets.top),
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: textEdgeInsets.left),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -textEdgeInsets.right),
            ])
                        
            lastView = titleLabel
        }
        
        if let subtitle = subtitle {
            subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(subtitleLabel)
            
            subtitleLabel.attributedText = subtitle
            subtitleLabel.font = subtitleFont
            switch subtitleColor {
            case .color(let color):
                subtitleLabel.textColor = color
            #if canImport(SwiftTheme)
            case .themeColor(let themeColor):
                subtitleLabel.theme_textColor = themeColor
            #endif
            default:
                break
            }

            if let lastView = lastView {
                subtitleLabel.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: subtitleTop).isActive = true
            } else {
                subtitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: textEdgeInsets.top).isActive = true
            }
            NSLayoutConstraint.activate([
                subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: textEdgeInsets.left),
                subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -textEdgeInsets.right)
            ])
            
            lastView = subtitleLabel
        }
        
        if let message = message {
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(messageLabel)
            
            messageLabel.text = message
            messageLabel.font = messageFont
            switch messageColor {
            case .color(let color):
                messageLabel.textColor = color
            #if canImport(SwiftTheme)
            case .themeColor(let themeColor):
                messageLabel.theme_textColor = themeColor
            #endif
            default:
                break
            }

            if let lastView = lastView {
                messageLabel.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: messageTop).isActive = true
            } else {
                messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: textEdgeInsets.top).isActive = true
            }
            NSLayoutConstraint.activate([
                messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: textEdgeInsets.left),
                messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -textEdgeInsets.right),
            ])
            
            lastView = messageLabel
        }
        
        if let radioText = radioText {
            radioLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(radioLabel)
            
            radioLabel.text = radioText
            radioLabel.font = radioFont
            switch radioColor {
            case .color(let color):
                radioLabel.textColor = color
            #if canImport(SwiftTheme)
            case .themeColor(let themeColor):
                radioLabel.theme_textColor = themeColor
            #endif
            default:
                break
            }
            
            if let lastView = lastView {
                radioLabel.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: radioTop).isActive = true
            } else {
                radioLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: textEdgeInsets.top).isActive = true
            }
            radioLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 11).isActive = true
            
            
            if let radioNormalImage = radioNormalImage, let radioSelectedImage = radioSelectedImage {
                radioImage.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(radioImage)
                
                radioImage.image = isRadioSelected ? radioSelectedImage : radioNormalImage
                
                radioImage.rightAnchor.constraint(equalTo: radioLabel.leftAnchor, constant: -8).isActive = true
                radioImage.centerYAnchor.constraint(equalTo: radioLabel.centerYAnchor, constant: 0).isActive = true
                radioImage.widthAnchor.constraint(equalToConstant: radioNormalImage.size.width).isActive = true
                radioImage.heightAnchor.constraint(equalToConstant: radioNormalImage.size.height).isActive = true
            }
            
            lastView = radioLabel
        }
        
        if let lastView = lastView {
            let bottom = actionsCount > 0 ? abs(textEdgeInsets.bottom) : textEdgeInsets.top
            lastView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -bottom).isActive = true
        }
    }
}
