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
  
  func searchFor(text: String, completion: @escaping (String, [SearchResultItem]) -> ()) -> Bool {
    guard text.count > 0 else {
      return false
    }
    
    currentText = text
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
      guard let self = self, self.currentText == text else { return }
      
      //WARNING: insert focusPoint here
      self.client.autocomplete(text: text, focusPoint: self.locationController.latestLocations.first?.coordinate).then { [weak self] (suggestions) in
        guard let self = self, self.currentText == text else { return }
        
        let items = suggestions.features.map({ (feature) -> SearchResultItem in
          return SearchResultItem(label: feature.properties.name, detail: feature.properties.label, coordinate: feature.geometry.start, gid: feature.properties.gid)
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
