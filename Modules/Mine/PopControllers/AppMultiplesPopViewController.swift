
import UIKit
import RxSwift


enum PopKinds {
    case
         sexSelect,
         dateSelect
         
}

class AppMultiplesPopViewController: BaseViewController {
    
    var isTouchBackGroundDismiss: Bool = false
    
    init(viewModel: AppMultiplesPopViewModel, types: PopKinds) {
        super.init(nibName: nil, bundle: nil)
        self.popType = types
        self.viewModel = viewModel
        
        modalPresentationStyle = .custom
        AppControllerTransitioningManager.shared.popType = types
        transitioningDelegate = AppControllerTransitioningManager.shared
        isTouchBackGroundDismiss = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var popType: PopKinds = .sexSelect
    
    private var viewModel: AppMultiplesPopViewModel!
    
    private let contentViewTag: Int = 1102
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.tag = 1101
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.2)
        
        setupViews()
        setupBindings()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
//        if popType == .createFamily {
//            view.endEditing(true)
//        }
//        if isTouchBackGroundDismiss {
//            dismiss(animated: true)
//        }
    }

    private func setupViews() {
        
        switch popType {
        case .sexSelect:
            let contentView = PopSexSelectView()
            contentView.tag = contentViewTag
            contentView.titleLabel.text = "逝者性别"
            view.addSubview(contentView)
            contentView.whc_Bottom(0)
                .whc_Left(0)
                .whc_Right(0)
                .whc_Height(PopSexSelectView.viewHeight)
            contentView.setLayerCorner(radius: 10, corners: .topCorners)
            
        case .dateSelect:
            let contentView = PopDateSelectView()
            contentView.tag = contentViewTag
            view.addSubview(contentView)
            contentView.whc_Bottom(0)
                .whc_Left(0)
                .whc_Right(0)
                .whc_Height(PopDateSelectView.viewHeight)
            contentView.setLayerCorner(radius: 10, corners: .topCorners)
            
        
                
        }
    }
    
    private func setupBindings() {
        
        switch popType {
        
        case .sexSelect:
            let contentView = view.viewWithTag(contentViewTag) as! PopSexSelectView
            contentView.confirmButton.rx.tap.subscribe { [weak self, weak contentView] _ in
                guard let `self` = self else { return }
                
                self.dismiss(animated: true) {
                    self.viewModel.rx_didSexSelectedTapped.onNext(contentView!.selectedSex)
                }
            }.disposed(by: disposeBag)
            
        case .dateSelect:
            let contentView = view.viewWithTag(contentViewTag) as! PopDateSelectView
            contentView.confirmButton.rx.tap.subscribe { [weak self, weak contentView] _ in
                guard let `self` = self else { return }
                
                self.dismiss(animated: true) {
                    self.viewModel.rx_didDateSelectedTapped.onNext(contentView!.selected)
                }
            }.disposed(by: disposeBag)
            
        }
    }
}


