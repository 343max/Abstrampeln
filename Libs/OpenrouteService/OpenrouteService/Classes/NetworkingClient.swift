// Copyright Max von Webel. All Rights Reserved.

import Foundation

public enum HTTPMethod : String {
    case GET = "GET"
    case POST = "POST"
}

public protocol NetworkingClient {
    typealias ParameterDict = [String: String]
    func sendRequest(_ method: HTTPMethod, _ path: String, _ parameter: ParameterDict, callback: @escaping (_ response: HTTPURLResponse, _ result: Result<Data, Error>) -> Void)
}

extension NetworkingClient {
    public func GET(_ path: String, _ parameter: ParameterDict, callback: @escaping (_ response: HTTPURLResponse, _ result: Result<Data, Error>) -> Void) {
        self.sendRequest(.GET, path, parameter, callback: callback)
    }
  
    public func GET<T>(_ path: String, _ parameter: ParameterDict, type: T.Type, callback: @escaping (_ response: HTTPURLResponse, _ result: Result<T, Error>) -> Void) where T : Decodable {
        GET(path, parameter) { (response, result) in
            switch result {
            case .failure(let error):
                callback(response, .failure(error))
            case .success(let data):
                do {
                    let payload = try JSONDecoder().decode(type, from: data)
                    callback(response, .success(payload))
                } catch {
                    callback(response, .failure(error))
                }
            }
        }
    }
}
