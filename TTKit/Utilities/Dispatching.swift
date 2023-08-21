/// A protocol which indicates that the type has a dispatcher. The `ActionType` associated type may
/// be used to constrain other generics code.
public protocol Dispatching: AnyObject {
    associatedtype ActionType

    /// The dispatcher used by this type.
    var dispatcher: Dispatcher<ActionType>? { get set }
}
