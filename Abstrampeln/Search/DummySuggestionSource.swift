// Copyright Max von Webel. All Rights Reserved.

import Combine
import Foundation
import CoreLocation

struct DummySuggestionSource: SearchResultsDataSource {
  func searchFor(text: String) -> AnyPublisher<(String, [Location]), Error> {
    let items: [Location]
    
    if !text.isEmpty {
      items = []
    } else {
      items = [
        Location(label: "Berliner Fernsehturm", detail: "Panoramastraße 1A, 10178 Berlin", coordinate: CLLocationCoordinate2D(latitude: 52.523430, longitude: 13.411440), gid: "dummy:tvtower"),
        Location(label: "Tierpark Berlin", detail: "Am Tierpark 125, 10319 Berlin", coordinate: CLLocationCoordinate2D(latitude: 52.495541, longitude: 13.526000), gid: "dummy:zoo"),
        Location(label: "Dolores", detail: "Rosa-Luxemburg-Straße 7, 10178 Berlin", coordinate: CLLocationCoordinate2D(latitude: 52.523870, longitude: 13.409310), gid: "dummy:dolores")
      ]
    }

    return Just<(String, [Location])>((text, items))
              .setFailureType(to: Error.self)
              .eraseToAnyPublisher()
  }
}
