import UIKit
import Lantern

class TVideoZoomCell: UIView, UIScrollViewDelegate, UIGestureRecognizerDelegate, LanternCell, LanternZoomSupportedCell {
    
    /// 弱引用TMediaBrowser
    weak var lantern: Lantern?

    var playSize = CGSize(width: kScreenWidth, height: kScreenWidth*9/16)
            
    var videoCoverView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .black
        view.clipsToBounds = true
        return view
    }()
    
    var videoPlayView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .black
        view.clipsToBounds = true
        view.tag = kPlayerContainerViewTag
        return view
    }()

    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.maximumZoomScale = 2.0
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    
    deinit {
        debugPrint("deinit - \(self.classForCoder)")
    }
    
    public required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    /// 生成实例
    public static func generate(with lantern: Lantern) -> Self {
        let cell = Self.init(frame: .zero)
        cell.lantern = lantern
        return cell
    }
    
    /// 子类可重写，创建子视图。完全自定义时不必调super。
    open func constructSubviews() {
        scrollView.delegate = self
        addSubview(scrollView)
        scrollView.addSubview(videoPlayView)
//        scrollView.addSubview(activityIndicatorView)
    }
    
    open func setup() {
        backgroundColor = .clear
        constructSubviews()
        
        /// 拖动手势
        addPanGesture()
        
        // 单击手势
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(onSingleTap(_:)))
        addGestureRecognizer(singleTap)
    }
    
    func relayoutViews() {
        /// 强制cell更新，触发layoutSubviews
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func relayoutViewsInDelay(completion: @escaping () -> Void) {
        self.relayoutViews()
        
        delayExecuting(0.01, inMain: true) { //延迟下，否则视频图像出不来
            completion()
        }
    }
    
    // 加载视频网络预览图
    func loadWebCoverUrl(url: URL, completion: @escaping () -> Void) {
//        activityIndicatorView.startAnimating()
        videoCoverView.setImage(
            withURL: url,
            placeholderImage: nil//R.image.home_header_bg()
        ) { [weak self] result in
            
            delayExecuting(0.01, inMain: true) { //延迟下，否则视频图像出不来
//                self?.activityIndicatorView.stopAnimating()
                switch result {
                case .success(let image):
                    self?.videoPlayView.image = image
                    self?.relayoutViews()
                case .failure(_):
                    break
                }
                
                completion()
            }
        }
    }
    
    // 加载视频首帧图
    func loadVideoCropPicture(with url: URL, isShowPicture: Bool, isShowLoading: Bool, completion: @escaping () -> Void) {
        if isShowLoading {
//            activityIndicatorView.startAnimating()
        }
        backgroundQueueExecuting { [weak self] in
            let image = tt_videoCropPicture(videoUrl: url)
            mainQueueExecuting {
                if isShowLoading {
//                    self?.activityIndicatorView.stopAnimating()
                }
                if let image = image {
                    if isShowPicture {
                        self?.videoPlayView.image = image
                    }
                    self?.playSize = image.size
                    self?.relayoutViews()
                }
                
                completion()
            }
        }
    }
    
    
    private weak var existedPan: UIPanGestureRecognizer?
    
    /// 添加拖动手势
    func addPanGesture() {
        guard existedPan == nil else {
            return
        }
        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        // 必须加在图片容器上，否则长图下拉不能触发
        scrollView.addGestureRecognizer(pan)
        existedPan = pan
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        scrollView.setZoomScale(1.0, animated: false)
//        let size = computeImageLayoutSize(in: scrollView)
//        let origin = computeImageLayoutOrigin(for: size, in: scrollView)
        videoPlayView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        scrollView.setZoomScale(1.0, animated: false)
//        activityIndicatorView.centerX = bounds.size.width/2
//        activityIndicatorView.centerY = bounds.size.height/2
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        videoPlayView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        videoPlayView.center = computeImageLayoutCenter(in: scrollView)
    }
    
    func computeImageLayoutSize(in scrollView: UIScrollView) -> CGSize {
        let imageSize = self.playSize
        var width: CGFloat
        var height: CGFloat
        let containerSize = scrollView.bounds.size
        if containerSize.width < containerSize.height {
            width = containerSize.width
            height = imageSize.height / imageSize.width * width
        } else {
            height = containerSize.height
            width = imageSize.width / imageSize.height * height
            if width > containerSize.width {
                width = containerSize.width
                height = imageSize.height / imageSize.width * width
            }
        }
        
        return CGSize(width: width, height: height)
    }
    
    func computeImageLayoutOrigin(for imageSize: CGSize, in scrollView: UIScrollView) -> CGPoint {
        let containerSize = scrollView.bounds.size
        var y = (containerSize.height - imageSize.height) * 0.5
        y = max(0, y)
        var x = (containerSize.width - imageSize.width) * 0.5
        x = max(0, x)
        return CGPoint(x: x, y: y)
    }
    
    func computeImageLayoutCenter(in scrollView: UIScrollView) -> CGPoint {
        var x = scrollView.contentSize.width * 0.5
        var y = scrollView.contentSize.height * 0.5
        let offsetX = (bounds.width - scrollView.contentSize.width) * 0.5
        if offsetX > 0 {
            x += offsetX
        }
        let offsetY = (bounds.height - scrollView.contentSize.height) * 0.5
        if offsetY > 0 {
            y += offsetY
        }
        return CGPoint(x: x, y: y)
    }
    
    /// 单击
    @objc open func onSingleTap(_ tap: UITapGestureRecognizer) {
        lantern?.dismiss()
    }
    /// 记录pan手势开始时imageView的位置
    private var beganFrame = CGRect.zero
    
    /// 记录pan手势开始时，手势位置
    private var beganTouch = CGPoint.zero
    
    /// 响应拖动
    @objc open func onPan(_ pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            beganFrame = videoPlayView.frame
            beganTouch = pan.location(in: scrollView)
        case .changed:
            let result = panResult(pan)
            videoPlayView.frame = result.frame
            lantern?.maskView.alpha = result.scale * result.scale
            lantern?.setStatusBar(hidden: result.scale > 0.99)
            lantern?.pageIndicator?.isHidden = result.scale < 0.99
        case .ended, .cancelled:
            videoPlayView.frame = panResult(pan).frame
            let isDown = pan.velocity(in: self).y > 0
            if isDown {
                lantern?.dismiss()
            } else {
                lantern?.maskView.alpha = 1.0
                lantern?.setStatusBar(hidden: true)
                lantern?.pageIndicator?.isHidden = false
                resetImageViewPosition()
            }
        default:
            resetImageViewPosition()
        }
    }
    
    /// 计算拖动时图片应调整的frame和scale值
    private func panResult(_ pan: UIPanGestureRecognizer) -> (frame: CGRect, scale: CGFloat) {
        // 拖动偏移量
        let translation = pan.translation(in: scrollView)
        let currentTouch = pan.location(in: scrollView)
        
        // 由下拉的偏移值决定缩放比例，越往下偏移，缩得越小。scale值区间[0.3, 1.0]
        let scale = min(1.0, max(0.3, 1 - translation.y / bounds.height))
        
        let width = beganFrame.size.width * scale
        let height = beganFrame.size.height * scale
        
        // 计算x和y。保持手指在图片上的相对位置不变。
        // 即如果手势开始时，手指在图片X轴三分之一处，那么在移动图片时，保持手指始终位于图片X轴的三分之一处
        let xRate = (beganTouch.x - beganFrame.origin.x) / beganFrame.size.width
        let currentTouchDeltaX = xRate * width
        let x = currentTouch.x - currentTouchDeltaX
        
        let yRate = (beganTouch.y - beganFrame.origin.y) / beganFrame.size.height
        let currentTouchDeltaY = yRate * height
        let y = currentTouch.y - currentTouchDeltaY
        
        return (CGRect(x: x.isNaN ? 0 : x, y: y.isNaN ? 0 : y, width: width, height: height), scale)
    }
    
    /// 复位ImageView
    private func resetImageViewPosition() {
        // 如果图片当前显示的size小于原size，则重置为原size
        let size = computeImageLayoutSize(in: scrollView)
        let needResetSize = videoPlayView.bounds.size.width < size.width || videoPlayView.bounds.size.height < size.height
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let `self` = self else { return }
            self.videoPlayView.center = self.computeImageLayoutCenter(in: self.scrollView)
            if needResetSize {
                self.videoPlayView.bounds.size = size
            }
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // 只处理pan手势
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        let velocity = pan.velocity(in: self)
        // 向上滑动时，不响应手势
        if velocity.y < 0 {
            return false
        }
        // 横向滑动时，不响应pan手势
        if abs(Int(velocity.x)) > Int(velocity.y) {
            return false
        }
        // 向下滑动，如果图片顶部超出可视区域，不响应手势
        if scrollView.contentOffset.y > 0 {
            return false
        }
        // 响应允许范围内的下滑手势
        return true
    }
    
    var showContentView: UIView {
        return videoPlayView
    }
}
