import Foundation

extension NSObject {
    
    public var ttClassName: String {
        return String(describing: NSStringFromClass(self.classForCoder).components(separatedBy: ".").last ?? "")
    }
}
