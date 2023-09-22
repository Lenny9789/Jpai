import UIKit

class PopDateSelectView: BaseView {

    static let viewHeight: CGFloat = 350
    
    
    
    lazy var pickerView: UIDatePicker = {
        let view = UIDatePicker()
        view.backgroundColor = .clear
        view.datePickerMode = .date
        view.timeZone = .current
        view.setDate(Date(), animated: true)
        view.minimumDate = Date(timeInterval: -60*60*24*365*300, since: .now)
        view.maximumDate = .now
        view.locale = Locale(identifier: "zh_CN")
//        view.calendar = Calendar(identifier: .gregorian)
//        view.
        if #available(iOS 13.4, *) {
            view.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        return view
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("确定", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .fontMedium(fontSize: 17)
        button.setBackgroundImage(UIImage(color: kMainColor), for: .normal)
        
        return button
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .white
        
        addSubview(pickerView)
        pickerView.whc_Top(20)
            .whc_Left(16)
            .whc_Right(16)
            .whc_Height(200)
        pickerView.addTarget(self, action: #selector(dateChanged(picker: )), for: .valueChanged)
        
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
    
    var selected: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"//"yyyy年MM月dd日 HH:mm:ss"
        return formatter.string(from: pickerView.date)
    }
    
    @objc private func dateChanged(picker: UIDatePicker) {
        debugPrint(picker)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
//        selected = formatter.string(from: picker.date)
    }
    
}

