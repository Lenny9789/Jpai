import Foundation
import RxSwift

open class TTCoordinator<ResultType>: NSObject {
    /// Type alias which will allows to access a ResultType of the Coordinator by `CoordinatorName.CoordinationResult`.
    public typealias CoordinationResult = ResultType
    
    /// Utility `DisposeBag` used by the subclasses.
    public let disposeBag = DisposeBag()
    
    /// Unique identifier.
    private let identifier = UUID()
    
    /// Dictionary of the child coordinators. Every child coordinator should be added
    /// to that dictionary in order to keep it in memory.
    /// Key is an `identifier` of the child coordinator and value is the coordinator itself.
    /// Value type is `Any` because Swift doesn't allow to store generic types in the array.
    private var childCoordinators = [UUID: Any]()
    
    
    /// deinit
    deinit {
        debugPrintS("🔴🔴🔴🔴🔴🔴🔴🔴🔴 \(ttClassName) 已经释放了 🔴🔴🔴🔴🔴🔴🔴🔴🔴")
    }
    
    /// initializers
    public override init() {
    }
    
    /// Stores coordinator to the `childCoordinators` dictionary.
    ///
    /// - Parameter coordinator: Child coordinator to store.
    private func store<T>(coordinator: TTCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }
    
    /// Release coordinator from the `childCoordinators` dictionary.
    ///
    /// - Parameter coordinator: Coordinator to release.
    private func free<T>(coordinator: TTCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }
    
    /// 1. Stores coordinator in a dictionary of child coordinators.
    /// 2. Calls method `start()` on that coordinator.
    /// 3. On the `onNext:` of returning observable of method `start()` removes coordinator from the dictionary.
    ///
    /// - Parameter coordinator: Coordinator to start.
    /// - Returns: Result of `start()` method.
    open func coordinate<T>(to coordinator: TTCoordinator<T>) -> Observable<T> {
        store(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in
                self?.free(coordinator: coordinator)
            })
    }
    
    /// Starts job of the coordinator.
    ///
    /// - Returns: Result of coordinator job.
    open func start() -> Observable<ResultType> {
        fatalError("Start method should be implemented.")
    }
}

