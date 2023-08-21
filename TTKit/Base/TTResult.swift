import Foundation

public protocol TTResultType {
    var error: TTError? { get }
    var isSuccess: Bool { get }
    var isFailure: Bool { get }

    init(error: TTError)
}

extension TTResultType {
    public var isFailure: Bool {
        return !isSuccess
    }
}

public enum TTBooleanResult: TTResultType {
    case success
    case failure(error: TTError)

    public init(error: TTError) {
        self = .failure(error: error)
    }

    public var error: TTError? {
        switch self {
        case .success:
            return nil
        case let .failure(error):
            return error
        }
    }

    public var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }
}

public enum TTGenericResult<T>: TTResultType {
    case success(value: T)
    case failure(error: TTError)
    
    public init(value: T) {
        self = .success(value: value)
    }

    public init(error: TTError) {
        self = .failure(error: error)
    }

    public var error: TTError? {
        switch self {
        case .success:
            return nil
        case let .failure(error):
            return error
        }
    }
    
    public var value: T? {
        switch self {
        case .success(value: let value):
            return value
        default:
            return nil
        }
    }

    public var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }
}
