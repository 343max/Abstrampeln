// Copyright Max von Webel. All Rights Reserved.

import Foundation
import CoreLocation

struct DummySuggestionSource: SearchResultsDataSource {
  func searchFor(text: String, completion: @escaping (String, [SearchResultItem]) -> ()) -> Bool {
    guard text.count == 0 else {
      return false
    }
    
    let items = [
      SearchResultItem(label: "Berliner Fernsehturm", detail: "Panoramastraße 1A, 10178 Berlin", coordinate: CLLocationCoordinate2D(latitude: 52.523430, longitude: 13.411440)),
      SearchResultItem(label: "Tierpark Berlin", detail: "Am Tierpark 125, 10319 Berlin", coordinate: CLLocationCoordinate2D(latitude: 52.495541, longitude: 13.526000)),
      SearchResultItem(label: "Dolores", detail: "Rosa-Luxemburg-Straße 7, 10178 Berlin", coordinate: CLLocationCoordinate2D(latitude: 52.523870, longitude: 13.409310))
    ]
    completion(text, items)
    
    return true
  }
  
  func cancelSearchFor(text: String) {
    //
  }
}