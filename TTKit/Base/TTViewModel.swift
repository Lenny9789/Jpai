import Foundation
import RxSwift

open class TTViewModel: NSObject {
    public let disposeBag = DisposeBag()
    
    /// deinit
    deinit {
        debugPrintS("🟡🟡🟡🟡🟡🟡🟡🟡🟡 \(ttClassName) 已经释放了 🟡🟡🟡🟡🟡🟡🟡🟡🟡")
    }
    
    /// initializers
    public override init() {
    }
}
