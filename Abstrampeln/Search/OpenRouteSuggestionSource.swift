// Copyright Max von Webel. All Rights Reserved.

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

  func searchFor(text: String, completion: @escaping (String, [Location]) -> ()) -> Bool {
    guard !text.isEmpty else {
      return false
    }

    currentText = text
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
      guard let self = self, self.currentText == text else { return }

      self.client.autocomplete(text: text, focusPoint: self.locationController.latestLocations.first?.coordinate).then { [weak self] (suggestions) in
        guard let self = self, self.currentText == text else { return }

        let items = suggestions.features.map({ (feature) -> Location in
          return Location(label: feature.properties.name, detail: feature.properties.label, coordinate: feature.geometry.start, gid: feature.properties.gid)
        })

        completion(text, items)
      }
    }

    return true
  }

  func cancelSearchFor(text: String) {
    if currentText == text {
      currentText = nil
    }
  }
}
