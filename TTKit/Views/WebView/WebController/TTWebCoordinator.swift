import UIKit
import RxSwift

open class TTWebCoordinator: TTCoordinator<Void> {

    // MARK: Properties
    let rootViewController: UIViewController
    let url: String!
    var navTitle: String?

    // MARK: - Lifecycle
    public init(rootViewController: UIViewController, url: String, title: String? = nil) {
        self.rootViewController = rootViewController
        self.url = url
        self.navTitle = title
        super.init()
    }
    
    open override func start() -> Observable<Void> {
        let currentViewController = TTWebController(url: url, title: navTitle)
        
        rootViewController.navigationController?
            .pushViewController(currentViewController, animated: true)
        
        return Observable.never()
    }
}

