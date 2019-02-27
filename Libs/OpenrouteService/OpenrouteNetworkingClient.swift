// Copyright Max von Webel. All Rights Reserved.

import Foundation

public class OpenrouteNetworkingClient: NetworkingClient {
  private let apiKey: String
  
  private static let endpoint = URL(string: "https://api.openrouteservice.org/")!
  private var session: URLSession!
  
  public init(apiKey: String) {
    self.apiKey = apiKey
    self.session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
  }
  
  public func sendRequest(_ method: HTTPMethod, _ path: String, _ parameter: ParameterDict, callback: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
    var components = URLComponents(url: OpenrouteNetworkingClient.endpoint, resolvingAgainstBaseURL: false)!
    components.path += path
    var parameter = parameter
    parameter["api_key"] = apiKey
    components.queryItems = parameter.map { URLQueryItem(name: $0, value: $1) }
    var request = URLRequest(url: components.url!)
    request.httpMethod = method.rawValue
    
    let task = session.dataTask(with: request) { (data, response, error) in
      let httpResponse = response as! HTTPURLResponse?
      callback(data, httpResponse, error)
    }
    
    task.resume()
  }
}
