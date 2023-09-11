import UIKit
import ZFPlayer

/// 快进/快退视图
class PlayerFastView: UIView {
    
    static var viewWidth: CGFloat {
        return 140
    }
    
    static var viewHeight: CGFloat {
        return 80
    }
    
    lazy var fastImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var fastTimeLabel: UILabel = {
        let label = UILabel(
            text: "",
            font: UIFont.fontRegular(fontSize: 14),
            color: .color(.white),
            lines: 1,
            align: .center
        )
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var fastProgressView: ZFSliderView = {
        let slider = ZFSliderView()
        slider.maximumTrackTintColor = .black
        slider.minimumTrackTintColor = .white
        slider.sliderHeight = 2
        slider.isHideSliderBlock = false
        return slider
    }()
    
    deinit {
        debugPrint("deinit - \(self.classForCoder)")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .init(white: 0, alpha: 0.5)
        setLayerCorner(radius: 4)

        addSubview(fastImageView)
        addSubview(fastTimeLabel)
        addSubview(fastProgressView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var min_x :CGFloat = 0
        var min_y :CGFloat = 0
        var min_w :CGFloat = 0
        var min_h :CGFloat = 0
        let min_view_w :CGFloat = self.frame.size.width
        
        min_w = 32
        min_h = 32
        min_x = (min_view_w - min_w) / 2
        min_y = 5
        fastImageView.frame = CGRect(x: min_x, y: min_y, width: min_w, height: min_h)
        
        min_x = 0
        min_y = fastImageView.bottom + 2
        min_w = min_view_w
        min_h = 20
        fastTimeLabel.frame = CGRect(x: min_x, y: min_y, width: min_w, height: min_h)
        
        min_x = 12
        min_y = fastTimeLabel.bottom + 5
        min_w = min_view_w - min_x*2
        min_h = 10
        fastProgressView.frame = CGRect(x: min_x, y: min_y, width: min_w, height: min_h)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
