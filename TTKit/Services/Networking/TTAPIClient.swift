import Foundation
import Alamofire

/// Type representing HTTP methods.
public enum TTHTTPMethod {
    /// Common HTTP methods.
    case get, post, put, delete, patch
}

/// API interface protocol
public protocol TTAPIProtocol {
    /// API URL address
    var url: String { get }
    /// API description information
    var description: String { get }
    /// API additional information, eg: Author | Note...
    var extra: String? { get }
    /// Type representing HTTP methods.
    var method: TTHTTPMethod { get }
    /// General headers
    var generalHeaders: [String: String]? { get }
}

/// Extension method
public extension TTAPIProtocol {

    /// Make a network request according to `TTAPIProtocol`
    ///
    /// - Parameters:
    ///   - parameters: `nil` by default.
    ///   - headers: `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default.
    ///   - result: Finished response
    ///
    func fetch(_ parameters: [String: Any]? = nil, headers: [String: String]? = nil, result: TNResultClosure?) {
        let task = TTNET.fetch(self, parameters: parameters, headers: headers)
        if let r = result {
            task.result(r)
        }
    }
    
    /// Make a network request according to `TTAPIProtocol`
    ///
    /// - Parameters:
    ///   - parameters: `nil` by default.
    ///   - headers: `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default.
    ///   - success: Successful response
    ///   - failed: Failed response
    ///
    func fetch(_ parameters: [String: Any]? = nil, headers: [String: String]? = nil, success: TNSuccessClosure?, failed: TNFailedClosure?) {
        let task = TTNET.fetch(self, parameters: parameters, headers: headers)
        if let s = success {
            task.success(s)
        }
        if let f = failed {
            task.failed(f)
        }
    }

    /// Make a network request according to `TTAPIProtocol`
    ///
    /// - Parameters:
    ///   - parameters: `nil` by default.
    ///   - headers: `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default.
    ///
    func fetch(_ parameters: [String: Any]? = nil, headers: [String: String]? = nil) -> TTNetworkRequest {
        TTNET.fetch(self, parameters: parameters, headers: headers)
    }
}

/// In order to `TTAPIProtocol` to `TTNetworking` extended network request method
public extension TTNetworking {
    /// Creates a request, for `TTAPIProtocol`
    ///
    /// - note: more see: `self.request(...)`
    @discardableResult
    func fetch(_ api: TTAPIProtocol,
               parameters: [String: Any]? = nil,
               headers: [String: String]? = nil,
               mockJsonFileName: String? = nil) -> TTNetworkRequest {
        let method = methodWith(api.method)
        
        var retHeaders = [String: String]()
        if let generalHeaders = api.generalHeaders {
            for (key,value) in generalHeaders.reversed() {
                retHeaders[key] = value
            }
        }
        retHeaders[TTKitConfiguration.Networking.dynamicHeaderTimestamp] = "\(Date().milliStamp)"
        retHeaders[TTKitConfiguration.Networking.dynamicHeaderLanguage] = getPreferredLanguage()
        if let headers = headers {
            for (key,value) in headers.reversed() {
                retHeaders[key] = value
            }
        }
        
        let task = request(url: api.url,
                           method: method,
                           parameters: parameters,
                           headers: retHeaders,
                           mockJsonFileName: mockJsonFileName
        )
        task.description = api.description
        task.extra = api.extra
        return task
    }
    
    /// Creates a request, for `TTAPIProtocol`
    ///
    /// - note: more see: `self.request(...)`
    @discardableResult
    func upload(_ api: TTAPIProtocol,
                parameters: [String: String]? = nil,
                headers: [String: String]? = nil,
                datas: [TTMultipartData],
                mockJsonFileName: String? = nil,
                isAddQueue: Bool = true) -> TTNetworkRequest {
        let method = methodWith(api.method)
        
        var retHeaders = [String: String]()
        if let generalHeaders = api.generalHeaders {
            for (key,value) in generalHeaders.reversed() {
                retHeaders[key] = value
            }
        }
        retHeaders[TTKitConfiguration.Networking.dynamicHeaderTimestamp] = "\(Date().milliStamp)"
        retHeaders[TTKitConfiguration.Networking.dynamicHeaderLanguage] = getPreferredLanguage()
        if let headers = headers {
            for (key,value) in headers.reversed() {
                retHeaders[key] = value
            }
        }
        
        let task = upload(url: api.url, method: method, parameters: parameters, datas: datas, headers: retHeaders, mockJsonFileName: mockJsonFileName, isAddQueue: isAddQueue)
        task.description = api.description
        task.extra = api.extra
        return task
    }
}

/// Function to convert request method
private func methodWith(_ m: TTHTTPMethod) -> Alamofire.HTTPMethod {
    // case delete, get, patch, post, put
    switch m {
    case .delete: return .delete
    case .get: return .get
    case .patch: return .patch
    case .post: return .post
    case .put: return .put
    }
}

/// 请求错误信息
public struct RequestErrorInfo {
    // 错误
    public var error: TTError!
    // 请求URL
    public var url: URL!
    
    public init(error: TTError,
                url: URL) {
        self.error = error
        self.url = url
    }
}
