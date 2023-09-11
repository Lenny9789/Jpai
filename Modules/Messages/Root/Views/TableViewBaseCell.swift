
import UIKit

class TableViewBaseCell: UITableViewCell {

    let disposeBag = DisposeBag()
    
    override var frame: CGRect {
        didSet {
            var newFrame = frame
            newFrame.origin.x += 16
            newFrame.size.width -= 2 * 16
            super.frame = newFrame
        }
    }

}
