// Copyright Max von Webel. All Rights Reserved.

import Foundation

public enum HTTPMethod : String {
    case GET = "GET"
    case POST = "POST"
}

public protocol NetworkingClient {
    typealias ParameterDict = [String: String]
    func sendRequest(_ method: HTTPMethod, _ path: String, _ parameter: ParameterDict, callback: @escaping (Data?, HTTPURLResponse?, Error?) -> Void)
}

extension NetworkingClient {
    public func GET(_ path: String, _ parameter: ParameterDict, callback: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        self.sendRequest(.GET, path, parameter, callback: callback)
    }
    
    public func GET<T>(_ path: String, _ parameter: ParameterDict, type: T.Type) -> Promise<T> where T : Decodable {
        return Promise<T>({ (completion, promise) in
            self.GET(path, parameter) { (data, _, error) in
                guard let data = data else {
                    promise.throw(error: error!)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(type, from: data)
                    completion(result)
                } catch {
                    print(error)
                }
            }
        })
    }
}
