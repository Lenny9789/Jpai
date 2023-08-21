import Foundation

open class TTAsynchronousOperation : Operation {

    private let stateLock = NSLock()

    private var _executing: Bool = false
    override private(set) open var isExecuting: Bool {
        get {
            return stateLock.withCriticalScope { _executing }
        }
        set {
            willChangeValue(forKey: "isExecuting")
            stateLock.withCriticalScope { _executing = newValue }
            didChangeValue(forKey: "isExecuting")
        }
    }

    private var _finished: Bool = false
    override private(set) open var isFinished: Bool {
        get {
            return stateLock.withCriticalScope { _finished }
        }
        set {
            willChangeValue(forKey: "isFinished")
            stateLock.withCriticalScope { _finished = newValue }
            didChangeValue(forKey: "isFinished")
        }
    }

    /// Complete the operation
    ///
    /// This will result in the appropriate KVN of isFinished and isExecuting
    ///
    open func completeOperation() {
        if isExecuting {
            isExecuting = false
        }

        if !isFinished {
            isFinished = true
        }
    }

    override open func start() {
        if isCancelled {
            isFinished = true
            return
        }

        isExecuting = true

        main()
    }

    override open func main() {
        fatalError("subclasses must override `main`")
    }
}
