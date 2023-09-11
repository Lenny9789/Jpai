//
//  BaseViewController.swift
//  minghaimuyuan
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {

    public var disposeBag = DisposeBag()
    
    lazy var backImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage(named: "home_bg")
        return imageV
    }()
    
    /// deinit
    deinit {
        debugPrintS("🟠🟠🟠🟠🟠🟠🟠🟠🟠 \(ttClassName) 已经释放了 🟠🟠🟠🟠🟠🟠🟠🟠🟠")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
#if DEBUG
        if TTKitConfiguration.General.isShowDebugController {
            let noteLabel = TTDebuger.shared.noticeLabel;
            if noteLabel.superview == nil {
                noteLabel.bringSubviewToFront(noteLabel)
            }
            noteLabel.text = " [\(TTDebuger.shared.customNote)]:\(ttClassName)"
        }
#endif
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tt_lastClassName = ttClassName
    }
}
