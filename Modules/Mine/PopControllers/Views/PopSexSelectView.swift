//
//  PopSexSelectView.swift
//  minghaimuyuan
//

import UIKit
import RxSwift

class PopSexSelectView: BaseView {

    static let viewHeight: CGFloat = 350
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#000000")
        label.font = .fontMedium(fontSize: 17)
        return label
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("确定", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .fontMedium(fontSize: 17)
        button.setBackgroundImage(UIImage(color: kMainColor), for: .normal)
        
        return button
    }()
    
    lazy var pickerView: UIPickerView = {
        let view = UIPickerView()
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .white
        
        return view
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.whc_CenterX(0)
            .whc_Top(20)
            .whc_Height(24)
            .whc_WidthAuto()
        
        addSubview(pickerView)
        pickerView.whc_Top(40, toView: titleLabel)
            .whc_Left(16)
            .whc_Right(16)
            .whc_Height(140)
        
        addSubview(confirmButton)
        confirmButton.whc_Bottom(44)
            .whc_CenterX(0)
            .whc_Width(300)
            .whc_Height(44)
            .setLayerCorner(radius: 22)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let dataSuorce: [String] = ["男", "女"]
    
    var selectedSex: (Int, String) {
        let index = pickerView.selectedRow(inComponent: 0)
        return (index, dataSuorce[index])
    }
}

extension PopSexSelectView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSuorce.count
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return kScreenWidth/2
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSuorce[row]
    }
}
