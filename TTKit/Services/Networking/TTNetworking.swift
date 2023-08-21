import Foundation
import Alamofire

/// Closure type executed when the request is successful
public typealias TNSuccessClosure = (_ JSON: Any) -> Void
/// Closure type executed when the request is failed
public typealias TNFailedClosure = (_ error: TTError) -> Void
/// Closure type executed when monitoring the upload or download progress of a request.
public typealias TNProgressHandler = (Progress) -> Void
/// Closure type executed when the request is finished
public typealias TNResultClosure = (_ result: TTGenericResult<Any>) -> Void
/// Closure type executed when cache data response
public typealias TNCacheClosure = (_ JSON: Any) -> Void
/// Closure type executed when the download is finished
public typealias TNDownLoadResultClosure = (_ path: String?, _ error: TTError?) -> Void

/// Defines the various states of network reachability.
public enum TTReachabilityStatus {
    /// It is unknown whether the network is reachable.
    case unknown
    /// The network is not reachable.
    case notReachable
    /// The connection type is either over Ethernet or WiFi.
    case ethernetOrWiFi
    /// The connection type is a cellular connection.
    case cellular
    
    /// If network is  reachable.
    public var isReachable: Bool {
        switch self {
        case .unknown:
            return false
        case .notReachable:
            return false
        case .ethernetOrWiFi:
            return true
        case .cellular:
            return true
        }
    }
}

// ============================================================================

/// Reference to `TTNetworking.shared` for quick bootstrapping and examples.
public let TTNET = TTNetworking.shared

// ============================================================================

/// `TTNetworking`Network request main class
public class TTNetworking {
    /// For singleton pattern
    public static let shared = TTNetworking()
    /// TaskQueue Array for (`Alamofire.Request` & callback)
    private(set) var taskQueue = [TTNetworkRequest]()
    /// `Session` creates and manages Alamofire's `Request` types during their lifetimes.
    var sessionManager: Alamofire.Session!

    /// Request timeout interval
    public var timeoutIntervalForRequest: TimeInterval = TTKitConfiguration.Networking.timeoutIntervalForRequest
    /// Response timeout interval
    public var timeoutIntervalForResource: TimeInterval = TTKitConfiguration.Networking.timeoutIntervalForResource
    /// If mock data from local json file
    public var isMockData: Bool = TTKitConfiguration.Networking.isMockData
    /// Mock time interval from server
    public var mockRespTimeInterval: Double = TTKitConfiguration.Networking.mockRespTimeInterval
    /// General local json file name for mock response data
    public var mockGeneralJsonFileName: String = TTKitConfiguration.Networking.mockGeneralJsonFileName
    /// If show request log
    public var isShowRequestLog: Bool = TTKitConfiguration.Networking.isShowRequestLog
    
    /// Network reachability manager, The first call to method `startMonitoring()` will be initialized.
    private var reachability = NetworkReachabilityManager.default
    /// The newwork status, `.unknown` by default, You need to call the `startMonitoring()` method
    private var curNetStatus: TTReachabilityStatus = .unknown
    public var networkStatus: TTReachabilityStatus {
        get {
            if self.curNetStatus != .unknown {
                return curNetStatus
            } else {
                if let status = self.reachability?.status {
                    switch status {
                    case .notReachable:
                        return.notReachable
                    case .unknown:
                        return .unknown
                    case .reachable(.ethernetOrWiFi):
                        return .ethernetOrWiFi
                    case .reachable(.cellular):
                        return .cellular
                    }
                } else {
                    return .unknown
                }
            }
        }
    }

    // MARK: - Core method

    /// Initialization
    /// `private` for singleton pattern
    private init() {
        let config = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = timeoutIntervalForRequest
        config.timeoutIntervalForResource = timeoutIntervalForResource
        sessionManager = Alamofire.Session(configuration: config)
    }
    
    /// Creates a `DataRequest` from a `URLRequest` created using the passed components
    ///
    /// - Parameters:
    ///   - method: `HTTPMethod` for the `URLRequest`. `.get` by default.
    ///   - parameters: `nil` by default.
    ///   - headers: `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default.
    ///
    /// - Returns:  The created `DataRequest`.
    public func request(url: String,
                        method: HTTPMethod = .get,
                        parameters: [String: Any]?,
                        headers: [String: String]? = nil,
                        encoding: ParameterEncoding = URLEncoding.default,
                        mockJsonFileName: String? = nil) -> TTNetworkRequest {
        let task = TTNetworkRequest()
        task.url = url
        task.parameters = parameters
        task.headers = headers

        if isShowRequestLog {
            task.printRequestLog()
        }

        var h: HTTPHeaders?
        if let tempHeaders = headers {
            h = HTTPHeaders(tempHeaders)
        }
        
        var encode = encoding
        if method == .post {
            encode = JSONEncoding.default
        }
        
        if !isMockData { // 从服务器请求
            task.request = sessionManager.request(url,
                                                  method: method,
                                                  parameters: parameters,
                                                  encoding: encode,
                                                  headers: h).validate().responseJSON { [weak self] response in
                task.handleResponse(response: response)

                if let index = self?.taskQueue.firstIndex(of: task) {
                    self?.taskQueue.remove(at: index)
                }
            }
            taskQueue.append(task)
        } else { // 从本地Json文件读取模拟数据
            var filePath: String?
            if let mockJsonFileName = mockJsonFileName {
                if let path = Bundle.main.path(forResource: "\(mockJsonFileName)", ofType: "json") {
                    filePath = path
                }
            } else {
                var secondLastField: String?
                var lastField: String?

                let fields = url.split(separator: "/")
                if fields.count > 2 {
                    secondLastField = String(fields[fields.count-2])
                    lastField = String(fields[fields.count-1])
                }

                if let secondLastField = secondLastField,
                   let lastField = lastField,
                   let path = Bundle.main.path(forResource: "\(secondLastField)_\(lastField)", ofType: "json") {
                    filePath = path
                } else {
                    if let path = Bundle.main.path(forResource: "\(mockGeneralJsonFileName)", ofType: "json") {
                        filePath = path
                    }
                }
            }
            
            assert(filePath != nil, "Local json file does not exist")
        
            var data: Data?
            if let filePath = filePath {
                data = try? Data.init(contentsOf: URL.init(fileURLWithPath: filePath))
            }
            
            delayExecuting(mockRespTimeInterval) {
                if let data = data, let dataDic: [String: Any] = tt_dataToDictionary(data) {
                    task.handleMockResponse(JSON: dataDic)
                } else {
                    task.handleMockResponse(JSON: nil)
                }
            }
        }
        return task
    }

    /// Creates a `UploadRequest` from a `URLRequest` created using the passed components
    ///
    /// - Parameters:
    ///   - method: `HTTPMethod` for the `URLRequest`. `.post` by default.
    ///   - parameters: In order to facilitate formatting parameters, the [String: String] format is adopted. `nil` by default.
    ///   - datas: Data to upload. The data is encapsulated here! more see `TTMultipartData`
    ///   - headers: `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default.
    ///
    /// - Returns: The created `UploadRequest`.
    public func upload(url: String,
                       method: HTTPMethod = .post,
                       parameters: [String: String]?,
                       datas: [TTMultipartData],
                       headers: [String: String]? = nil,
                       mockJsonFileName: String? = nil,
                       isAddQueue: Bool = true) -> TTNetworkRequest {
        let task = TTNetworkRequest()
        task.url = url
        task.parameters = parameters
        task.headers = headers

        if isShowRequestLog {
            task.printRequestLog()
        }

        var h: HTTPHeaders?
        if let tempHeaders = headers {
            h = HTTPHeaders(tempHeaders)
        }

        if !isMockData { // 从服务器请求
            task.request = sessionManager.upload(multipartFormData: { (multipartData) in
                // 1.参数 parameters
                if let parameters = parameters {
                    for p in parameters {
                        multipartData.append(p.value.data(using: .utf8)!, withName: p.key)
                    }
                }
                // 2.datas
                for d in datas {
                    multipartData.append(d.data, withName: d.name, fileName: d.fileName, mimeType: d.mimeType)
                }
            }, to: url, method: method, headers: h).uploadProgress(queue: .main, closure: { (progress) in
                task.handleProgress(progress: progress)
            }).validate().responseJSON(completionHandler: { [weak self] response in
                task.handleResponse(response: response)

                if isAddQueue {
                    if let index = self?.taskQueue.firstIndex(of: task) {
                        self?.taskQueue.remove(at: index)
                    }
                }
            })
            if isAddQueue {
                taskQueue.append(task)
            }
        } else {
            var filePath: String?
            if let mockJsonFileName = mockJsonFileName {
                if let path = Bundle.main.path(forResource: "\(mockJsonFileName)", ofType: "json") {
                    filePath = path
                }
            } else {
                var secondLastField: String?
                var lastField: String?

                let fields = url.split(separator: "/")
                if fields.count > 2 {
                    secondLastField = String(fields[fields.count-2])
                    lastField = String(fields[fields.count-1])
                }

                if let secondLastField = secondLastField,
                   let lastField = lastField,
                   let path = Bundle.main.path(forResource: "\(secondLastField)_\(lastField)", ofType: "json") {
                    filePath = path
                } else {
                    if let path = Bundle.main.path(forResource: "\(mockGeneralJsonFileName)", ofType: "json") {
                        filePath = path
                    }
                }
            }
            
            assert(filePath != nil, "Local json file does not exist")
        
            var data: Data?
            if let filePath = filePath {
                data = try? Data.init(contentsOf: URL.init(fileURLWithPath: filePath))
            }
            
            delayExecuting(mockRespTimeInterval) {
                if let data = data, let dataDic: [String: Any] = tt_dataToDictionary(data) {
                    task.handleMockResponse(JSON: dataDic)
                } else {
                    task.handleMockResponse(JSON: nil)
                }
            }
        }
        return task
    }
    
    /// Creates a `DownloadRequest`...
    ///
    /// - Parameters:
    ///   - url: The download source URL
    ///   - method: `HTTPMethod` for the `URLRequest`. `.get` by default.
    ///   - path: The final destination path of the data returned from the server
    ///   - parameters: In order to facilitate formatting parameters, the [String: String] format is adopted. `nil` by default.
    ///   - headers: `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default.
    ///
    /// - Returns: The created `UploadRequest`.
    public func download(url: String,
                         method: HTTPMethod = .get,
                         path: String? = nil,
                         parameters: [String: String]? = nil,
                         headers: [String: String]? = nil) -> TTNetworkRequest {
        
        let task = TTNetworkRequest()
        task.url = url
        task.parameters = parameters
        task.headers = headers

        if isShowRequestLog {
            task.printRequestLog()
        }

        var h: HTTPHeaders?
        if let tempHeaders = headers {
            h = HTTPHeaders(tempHeaders)
        }
        
        var destination: DownloadRequest.Destination?
        if let path = path {
            var retPath = path
            if (retPath as NSString).hasPrefix("file://") == false {
                retPath = "file://" + retPath
            }
            if let fileURL = URL(string: retPath) {
                destination = { _, _ in
                    return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                }
            }
        } else {
            destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        }
        
        task.request = sessionManager.download(url,
                                               method: method,
                                               parameters: parameters,
                                               headers: h,
                                               to: destination)
            .downloadProgress() { progress in
                task.handleProgress(progress: progress)
            }
            .response { [weak self] response in
                task.handleDownloadResponse(response: response)
                
                if let index = self?.taskQueue.firstIndex(of: task) {
                    self?.taskQueue.remove(at: index)
                }
            }
        
        taskQueue.append(task)
        return task
    }

    // MARK: - Cancellation

    /// Cancel all active `Request`s, optionally calling a completion handler when complete.
    ///
    /// - Note: This is an asynchronous operation and does not block the creation of future `Request`s. Cancelled
    ///         `Request`s may not cancel immediately due internal work, and may not cancel at all if they are close to
    ///         completion when cancelled.
    ///
    /// - Parameters:
    ///   - queue:      `DispatchQueue` on which the completion handler is run. `.main` by default.
    ///   - completion: Closure to be called when all `Request`s have been cancelled.
    public func cancelAllRequests(completingOnQueue queue: DispatchQueue = .main, completion: (() -> Void)? = nil) {
        sessionManager.cancelAllRequests(completingOnQueue: queue, completion: completion)
    }
}

/// Shortcut method for `TTNetworking`
extension TTNetworking {

    /// Creates a POST request
    ///
    /// - note: more see: `self.request(...)`
    @discardableResult
    public func POST(url: String, parameters: [String: Any]? = nil, headers: [String: String]? = nil) -> TTNetworkRequest {
        request(url: url, method: .post, parameters: parameters, headers: nil)
    }

    /// Creates a POST request for upload data
    ///
    /// - note: more see: `self.request(...)`
    @discardableResult
    public func POST(url: String, parameters: [String: String]? = nil, headers: [String: String]? = nil, datas: [TTMultipartData]? = nil) -> TTNetworkRequest {
        guard datas != nil else {
            return request(url: url, method: .post, parameters: parameters, headers: nil)
        }
        return upload(url: url, parameters: parameters, datas: datas!, headers: headers)
    }

    /// Creates a GET request
    ///
    /// - note: more see: `self.request(...)`
    @discardableResult
    public func GET(url: String, parameters: [String: Any]? = nil, headers: [String: String]? = nil) -> TTNetworkRequest {
        request(url: url, method: .get, parameters: parameters, headers: nil)
    }
}

/// Detect network status 监听网络状态
extension TTNetworking {
    /// Starts monitoring for changes in network reachability status.
    public func startMonitoring() {
        reachability?.startListening(onQueue: .main, onUpdatePerforming: { [weak self] (status) in
            guard let `self` = self else { return }
            switch status {
            case .notReachable:
                self.curNetStatus = .notReachable
            case .unknown:
                self.curNetStatus = .unknown
            case .reachable(.ethernetOrWiFi):
                self.curNetStatus = .ethernetOrWiFi
            case .reachable(.cellular):
                self.curNetStatus = .cellular
            }
            // Sent notification
            mainQueueExecuting {
                NotificationCenter.default.post(name: TTNotifyName.Kit.networkStatus, object: self.networkStatus)
            }
            debugPrint("TTNetworking Network Status: \(self.networkStatus)")
        })
    }

    /// Stops monitoring for changes in network reachability status.
    public func stopMonitoring() {
        reachability?.stopListening()
    }
}

/// RequestTask
public class TTNetworkRequest: Equatable {

    /// Request url
    var url: String?
    /// Request parameters
    var parameters: [String: Any]?
    /// Dynamic parameters
    var dynamicParams: [String: Any]?
    /// Request headers
    var headers: [String: String]?
    /// Alamofire.DataRequest
    var request: Alamofire.Request?
    /// API description information. default: nil
    var description: String?
    /// API additional information, eg: Author | Note...,  default: nil
    var extra: String?
    /// Is cache the response data,  default: false
    var cache: Bool = false

    /// request response callback
    private var successHandler: TNSuccessClosure?
    /// request failed callback
    private var failedHandler: TNFailedClosure?
    /// `ProgressHandler` provided for upload/download progress callbacks.
    private var progressHandler: TNProgressHandler?
    /// finished callback, contains the result of successful or failed
    private var resultHandler: TNResultClosure?
    /// cache response callback
    private var cacheHandler: TNCacheClosure?
    /// cache response callback
    private var downLoadResultHandler: TNDownLoadResultClosure?

    // MARK: - Handler
    
    /// Handle request response
    func handleResponse(response: AFDataResponse<Any>) {
        switch response.result {
        case .failure(let error):
            printResponseLog(JSON: nil, error: error)
            
            let err = TTError(code: error.responseCode ?? (error as NSError).code, desc: error.localizedDescription)

            mainQueueExecuting {
                if let url = response.request?.url {
                    let errInfo = RequestErrorInfo(error: err, url: url)
                    NotificationCenter.default.post(name: TTNotifyName.Kit.apiRequestError, object: errInfo)
                }
            }
            
            if let closure = failedHandler {
                closure(err)
            }
            if let closure = resultHandler {
                closure(.failure(error: err))
            }
        case .success(let JSON):
            printResponseLog(JSON: JSON, error: nil)
            
            if let closure = successHandler {
                closure(JSON)
            }
            if let closure = resultHandler {
                closure(.success(value: JSON))
            }
            
            /// write cache
            if self.cache {
                var model = TTCacheModel()
                model.data = response.data
                TTCacheManager.default.setObject(model, forKey: self.cacheKey())
            }
        }
        clearReference()
    }
    
    /// Handle mock response
    func handleMockResponse(JSON: Any?) {
        printResponseLog(JSON: JSON, error: nil)
        if let JSON = JSON {
            if let closure = successHandler {
                closure(JSON)
            }
            if let closure = resultHandler {
                closure(.success(value: JSON))
            }
            
            /// write cache
            if self.cache {
                if let dic = JSON as? Dictionary<String, Any> {
                    var model = TTCacheModel()
                    model.data = tt_jsonToData(dic)
                    TTCacheManager.default.setObject(model, forKey: self.cacheKey())
                }
            }
        } else {
            let err = TTError(code: .invalidData)
            if let closure = failedHandler {
                closure(err)
            }
            if let closure = resultHandler {
                closure(.failure(error: err))
            }
        }
    }
    
    /// Processing download response (Only when download files)
    func handleDownloadResponse(response: AFDownloadResponse<URL?>)  {
        switch response.result {
        case .failure(let error):
            printDownloadResponseLog(path: nil, error: error)

            let err = TTError(code: error.responseCode ?? (error as NSError).code, desc: error.localizedDescription)

            mainQueueExecuting {
                if let url = response.request?.url {
                    let errInfo = RequestErrorInfo(error: err, url: url)
                    NotificationCenter.default.post(name: TTNotifyName.Kit.apiRequestError, object: errInfo)
                }
            }
            
            if let closure = downLoadResultHandler {
                closure(nil, err)
            }
        case .success(_):
            var retPath: String?
            if let closure = downLoadResultHandler {
                if let fileUrl = response.fileURL {
                    let strFile = fileUrl.absoluteString as NSString
                    if strFile.hasPrefix("file://") {
                        retPath = strFile.substring(from: 7)
                    }
                }
                closure(retPath, nil)
            }
            
            printDownloadResponseLog(path: retPath, error: nil)
        }
    }
    
    /// Processing request progress (Only when uploading files)
    func handleProgress(progress: Foundation.Progress) {
        //debugPrint("Progress: \(progress.fractionCompleted)")
        if let closure = progressHandler {
            closure(progress)
        }
    }
    
    // MARK: - Callback

    /// Adds a handler to be called once the request has finished.
    ///
    /// - Parameters:
    ///   - closure: A closure to be executed once the request has finished.
    ///
    /// - Returns:             The request.
    @discardableResult
    public func success(_ closure: @escaping TNSuccessClosure) -> Self {
        successHandler = closure
        return self
    }

    /// Adds a handler to be called once the request has finished.
    ///
    /// - Parameters:
    ///   - closure: A closure to be executed once the request has finished.
    ///
    /// - Returns:             The request.
    @discardableResult
    public func failed(_ closure: @escaping TNFailedClosure) -> Self {
        failedHandler = closure
        return self
    }

    /// Sets a closure to be called periodically during the lifecycle of the instance as data is sent to the server.
    ///
    /// - Note: Only the last closure provided is used.
    ///
    /// - Parameters:
    ///   - closure: The closure to be executed periodically as data is sent to the server.
    ///
    /// - Returns:   The instance.
    @discardableResult
    public func progress(closure: @escaping TNProgressHandler) -> Self {
        progressHandler = closure
        return self
    }
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - Parameters:
    ///   - closure: A closure to be executed once the request has finished.
    ///
    /// - Returns:             The request.
    @discardableResult
    public func result(_ closure: @escaping TNResultClosure) -> Self {
        resultHandler = closure
        return self
    }
    
    /// Adds a handler to be called once the download has finished.
    ///
    /// - Parameters:
    ///   - closure: A closure to be executed once the download has finished.
    ///
    /// - Returns:             The request.
    @discardableResult
    public func downloadResult(_ closure: @escaping TNDownLoadResultClosure) -> Self {
        downLoadResultHandler = closure
        return self
    }

    // MARK: - Cache

    /// Generate cache key.
    ///
    /// - Returns:             The cache key.
    fileprivate func cacheKey() -> String {
        if let url = self.url {
            let key = tt_cacheKey(url, parameters, dynamicParams)
            return key
        }
        return ""
    }
    
    /// Set if cache response data.
    ///
    /// - Parameters:
    ///   - cache: is cache.
    ///
    /// - Returns:             The request.
    public func cache(_ cache: Bool, dynamicParams: [String: Any]?) -> Self {
        self.cache = cache
        self.dynamicParams = dynamicParams;
        return self
    }
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - Parameters:
    ///   - closure: A closure to be executed once get the cache data.
    ///
    /// - Returns:             The request.
    @discardableResult
    public func cached(_ closure: @escaping TNCacheClosure) -> Self {
        cacheHandler = closure
        
        if let data = TTCacheManager.default.objectSync(forKey: self.cacheKey())?.data {
            let JSON = tt_dataToDictionary(data)
            if let JSON = JSON {
                if let closure = cacheHandler {
                    closure(JSON)
                }
            }
        }
        
        return self
    }
    
    // MARK: - Operate

    /// Cancels the instance. Once cancelled, a `Request` can no longer be resumed or suspended.
    ///
    /// - Returns: The instance.
    public func cancel() {
        request?.cancel()
    }

    /// Free memory
    func clearReference() {
        successHandler = nil
        failedHandler = nil
        progressHandler = nil
    }

    // MARK: - Log

    /// print request info
    func printRequestLog() {
#if DEBUG
        print("\n")
        print("【请求开始：\( Date().dateTimeString())】🤔🤔🤔🤔🤔🤔🤔🤔🤔🤔🤔🤔🤔🤔🤔🤔🤔🤔🤔🤔🤔🤔🤔")
        if let url = self.url {
            print("【请求地址】: " + url)
        }
        if let headers = self.headers {
            if let str = tt_jsonToString(headers) {
                print("【请求头部】: \n" + str)
            }
        }
        if let parameters =  self.parameters {
            if let str = tt_jsonToString(parameters) {
                print("【请求参数】: \n" + str)
            }
        }
        print("【请求开始】>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
        print("\n")
#endif
    }
    
    /// print response info
    func printResponseLog(JSON: Any?, error: Error?) {
#if DEBUG
        print("\n")
        print("【请求响应：\( Date().dateTimeString())】🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥")
        if let url = self.url {
            print("【请求地址】: " + url)
        }
        if let description = description {
            print("【接口描述】: " + description)
        }
        if let headers = self.headers {
            if let str = tt_jsonToString(headers) {
                print("【请求头部】: \n" + str)
            }
        }
        if let parameters =  self.parameters {
            if let str = tt_jsonToString(parameters) {
                print("【请求参数】: \n" + str)
            }
        }
        if let JSON = JSON {
            if let dic = JSON as? Dictionary<String, Any> {
                if let str = tt_jsonToString(dic) {
                    print("【响应数据】: \n" + str)
                }
            }
        }
        if let error = error {
            let code = (error as NSError).code
            let msg = error.localizedDescription
            print("【错误信息】: \ncode: \(code), errorMessage: \(msg)")
        }
        print("【请求响应】<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
        print("\n")
#endif
    }
    
    /// print download response info
    func printDownloadResponseLog(path: String?, error: Error?) {
#if DEBUG
        print("\n")
        print("【请求响应：\( Date().dateTimeString() )】🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥")
        if let url = self.url {
            print("【请求地址】: " + url)
        }
        if let path = path {
            print("【path】: \n" + path)
        }
        if let description = description {
            print("【接口描述】: " + description)
        }
        if let headers = self.headers {
            if let str = tt_jsonToString(headers) {
                print("【请求头部】: \n" + str)
            }
        }
        if let parameters =  self.parameters {
            if let str = tt_jsonToString(parameters) {
                print("【请求参数】: \n" + str)
            }
        }
        if let error = error {
            let code = (error as NSError).code
            let msg = error.localizedDescription
            print("【错误信息】: \ncode: \(code), errorMessage: \(msg)")
        }
        print("【请求响应】<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
        print("\n")
#endif
    }
}

/// Equatable for `TTNetworkRequest`
extension TTNetworkRequest {
    /// Returns a Boolean value indicating whether two values are equal.
    public static func == (lhs: TTNetworkRequest, rhs: TTNetworkRequest) -> Bool {
        return lhs.request?.id == rhs.request?.id
    }
}
