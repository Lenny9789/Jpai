import UIKit
import SnapKit

public class TTAlertCustomCell: UITableViewCell {
    
    lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: Initialization Methods
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setCustomView(_ destView: UIView) {
        for (_, subview) in containerView.allSubviews().enumerated() {
            if subview.tag == 9999 {
                subview.removeFromSuperview()
                break
            }
        }

        containerView.addSubview(destView)
        destView.tag = 9999
        destView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
}
