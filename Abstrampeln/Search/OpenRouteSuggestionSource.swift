// Copyright Max von Webel. All Rights Reserved.

import Combine
import Foundation
import OpenrouteService

class OpenRouteSuggestionSearch: SearchResultsDataSource {
  let client: OpenrouteClient
  let locationController: LocationController

  var currentText: String?

  init(client: OpenrouteClient, locationController: LocationController) {
    self.client = client
    self.locationController = locationController
  }
  
  func searchFor(text: String) -> AnyPublisher<(String, [Location]), Error> {
    guard !text.isEmpty else {
      return Just<(String, [Location])>(("", []))
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }

    return self.client.autocomplete(text: text, focusPoint: self.locationController.latestLocations.first?.coordinate)
      .map { (suggestions) -> (String, [Location]) in
        let items = suggestions.features.map({ (feature) -> Location in
          return Location(label: feature.properties.name, detail: feature.properties.label, coordinate: feature.geometry.start, gid: feature.properties.gid)
        })
        
        return (text, items)
      }
      .eraseToAnyPublisher()
  }
}
