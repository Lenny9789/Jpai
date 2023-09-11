//
//  BaseView.swift
//  minghaimuyuan
//

import UIKit
import RxSwift

class BaseView: UIView {

    public let disposeBag = DisposeBag()
    
    deinit {
        print("\n--------\(self.classForCoder) 已经释放了------\n")
    }

}
