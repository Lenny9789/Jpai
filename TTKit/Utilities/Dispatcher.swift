import Foundation

/// The `Dispatcher` is used by a view to dispatch actions to a listening `Processor`. The
/// dispatcher keeps a weak reference to its processor.
///
public final class Dispatcher<T> {

    /// Internal weak reference to the processor. Forwards dispatched actions.
    private let receive: (T) -> Void

    /// Creates a new dispatcher that uses the specified processor for receiving actions.
    ///
    /// - Parameters:
    ///     - processor: The processor that will receive actions dispatched by this dispatcher.
    ///
    public init<P: Processor>(_ processor: P) where P.ActionType == T {
        receive = { [weak processor] action in
            processor?.receive(action)
        }
    }

    /// Creates a new dispatcher that forwards actions to the specified `dispatcher` given the
    /// specified `map` function. This allows subviews to forward actions to their parent views
    /// while maintaining their own `Action` type.
    ///
    /// - Parameters:
    ///     - dispatcher: The dispatcher that will receive actions forwarded from this dispatcher.
    ///         Forwarded actions are mapped with the `map` function.
    ///     - map: Function to map actions emitted by this dispatcher, so they can be forwarded.
    ///
    public init<Action>(via dispatcher: Dispatcher<Action>?, map: @escaping (T) -> Action) {
        receive = { [weak dispatcher] action in
            dispatcher?.dispatch(map(action))
        }
    }

    /// Dispatch an action to the processor.
    ///
    /// - Parameter action: The action to dispatch.
    ///
    public func dispatch(_ action: T) {
        receive(action)
    }
}

/// Processor is responsible for receiving and processing dispatched actions. Generally a processor
/// will mutate local state based on the action it receives.
///
public protocol Processor: AnyObject {
    associatedtype ActionType

    /// Receives dispatched actions from a dispatcher.
    ///
    /// - Parameters:
    ///     - action: The action to process.
    ///
    func receive(_ action: ActionType)
}
