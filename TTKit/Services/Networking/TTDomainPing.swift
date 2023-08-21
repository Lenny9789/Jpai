import Foundation

/// 域名Ping检测服务
public class TTDomainPing {
    
    /// 检测一组域名，返回可用域名
    static public func pingDomainUrls(
        domains: [String],
        headers: [String : String]? = nil,
        onCompletion: @escaping (Array<String>) -> Void)
    {
        let startTime = Date().timeIntervalSince1970
        
        if domains.count == 0 {
            onCompletion([])
            return
        }
        
        let group = DispatchGroup()

        var results = [String]()
        
        for (_, domain) in domains.enumerated() {
            group.enter()
            self.pingDomainUrl(domain: domain, headers: headers) { ret in
                group.leave()
                if ret {
                    results.append(domain)
                }
            }
        }
        
        group.notify(queue: .main) {
            let endTime = Date().timeIntervalSince1970
            let seconds = endTime-startTime
            debugPrint("\n\n域名检测结果, \n源域名：\(domains), \n可用域名：\(results), \n耗时：\(seconds)s\n")
            onCompletion(results)
        }
    }
    
    /// 检查域名是否可用
    static public func pingDomainUrl(
        domain: String,
        headers: [String : String]?,
        completion: @escaping (Bool) -> Void)
    {
        guard let candidate = URL(string: domain) else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: candidate)
        request.httpMethod = "HEAD"
        request.allHTTPHeaderFields = headers
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                debugPrint("域名组检测, 不可用: \(domain), error: \(error)");
                completion(false)
            } else {
                debugPrint("域名组检测, 可用: \(domain)");
                completion(true)
            }
        }
        task.resume()
    }
}
