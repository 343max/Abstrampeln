// Copyright Max von Webel. All Rights Reserved.

import Foundation
import OpenrouteService

class OpenRouteSuggestionSearch: SearchResultsDataSource {
  let client: OpenrouteClient
  
  var currentText: String?
  
  init(client: OpenrouteClient) {
    self.client = client
  }
  
  func searchFor(text: String, completion: @escaping (String, [SearchResultItem]) -> ()) -> Bool {
    guard text.count > 0 else {
      return false
    }
    
    currentText = text
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
      guard let self = self, self.currentText == text else { return }
      
      //WARNING: insert focusPoint here
      self.client.autocomplete(text: text, focusPoint: nil).then { [weak self] (suggestions) in
        guard let self = self, self.currentText == text else { return }
        
        let items = suggestions.features.map({ (feature) -> SearchResultItem in
          return SearchResultItem(label: feature.properties.label, detail: feature.properties.name, coordinate: feature.geometry.start)
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
