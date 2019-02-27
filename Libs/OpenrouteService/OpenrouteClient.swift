// Copyright Max von Webel. All Rights Reserved.

import Foundation
import CoreLocation

public class OpenrouteClient {
  let client: NetworkingClient
  
  public init(networkingClient: NetworkingClient) {
    self.client = networkingClient
  }
  
  // search:
  // https://api.openrouteservice.org/geocode/search?text=Brandenburger&boundary.circle.lon=13.449880&boundary.circle.lat=52.511180&boundary.circle.radius=200
  
  
  // https://api.openrouteservice.org/geocode/autocomplete?text=Toky&focus.point.lon=13.449880&focus.point.lat=52.511180
  public func autocomplete(text: String, focusPoint: CLLocationCoordinate2D?) -> Promise<Geocode> {
    var parameters: NetworkingClient.ParameterDict = ["text": text]
    if let focusPoint = focusPoint {
      parameters["focus.point.lon"] = "\(focusPoint.longitude)"
      parameters["focus.point.lat"] = "\(focusPoint.latitude)"
    }
    
    return client.GET("geocode/autocomplete", parameters, type: Geocode.self)
  }
}
