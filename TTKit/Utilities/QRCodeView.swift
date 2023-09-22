

import UIKit


class QRCodeView: UIView {

    lazy var QRCodeImage: UIImageView = {
        let imageV = UIImageView()
        imageV.theme_backgroundColor = ThemeGuide.Colors.theme_background
        imageV.isUserInteractionEnabled = true
        return imageV
    }()
    
    lazy var payLabel: UILabel = {
        let label = UILabel()
        label.text = "扫描二维码，添加我为好友"
        label.textColor = .systemGray3
        label.font = .fontMedium(fontSize: 14)
        return label
    }()
   
    init() {
        super.init(frame: .zero)
        theme_backgroundColor = ThemeGuide.Colors.theme_backgroundHigh
        addSubview(QRCodeImage)
        QRCodeImage.whc_Top(40)
            .whc_CenterX(0)
            .whc_Width(225)
            .whc_Height(225)
            .setLayerCorner(radius: 8)
        
        addSubview(payLabel)
        payLabel.whc_CenterX(0)
            .whc_Top(30, toView: QRCodeImage)
            .whc_WidthAuto()
            .whc_HeightAuto()
            .whc_Bottom(40)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(content: String) {
        if content.count > 0 {
            let qrImage = UIImage.imageWithCIQRCode(content, size: 225)
            QRCodeImage.image = qrImage
        }else {
            QRCodeImage.image = nil
        }
        TTAlertViewController.showCustomPopup(self, style: .alert,width:kScreenWidth - 70)
    }
}
