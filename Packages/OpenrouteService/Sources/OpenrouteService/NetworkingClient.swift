// Copyright Max von Webel. All Rights Reserved.

import Combine
import Foundation

public enum HTTPMethod: String {
    case GET
    case POST
}

public protocol NetworkingClient {
    typealias ParameterDict = [String: String]
    func sendRequest(_ method: HTTPMethod, _ path: String, _ parameter: ParameterDict) -> AnyPublisher<Data, URLError>
}

extension NetworkingClient {
    public func GET(_ path: String, _ parameter: ParameterDict) -> AnyPublisher<Data, URLError> {
        return sendRequest(.GET, path, parameter)
    }
    
    public func GET<T>(_ path: String, _ parameter: ParameterDict, type: T.Type) -> AnyPublisher<T, Error> where T: Decodable {
        return GET(path, parameter)
            .decode(type: type, decoder: JSONDecoder.openroute)
            .eraseToAnyPublisher()
    }
}
