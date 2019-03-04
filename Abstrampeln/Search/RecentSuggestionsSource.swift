// Copyright Max von Webel. All Rights Reserved.

import Foundation
import CoreLocation

class RecentSuggestionsSource {
  var history: [SearchResultItem] {
    didSet {
      save()
    }
  }
  
  init() {
    history = RecentSuggestionsSource.load()
  }
}

extension RecentSuggestionsSource: SearchResultsDataSource {
  func searchFor(text: String, completion: @escaping (String, [SearchResultItem]) -> ()) -> Bool {
    if text.count == 0 {
      completion(text, history)
    }
    
    return false
  }
  
  func cancelSearchFor(text: String) {
    //
  }
}

extension RecentSuggestionsSource {
  enum UserDefaultsKeys: String {
    case RecentSuggestion = "RecentSuggestions"
  }
  
  static func load() -> [SearchResultItem] {
    let dicts = UserDefaults.standard.object(forKey: UserDefaultsKeys.RecentSuggestion.rawValue) as? [[String: Any?]] ?? []
    return dicts.map({ (dict) -> SearchResultItem in
      return SearchResultItem(dict: dict)
    })
  }
  
  func save() {
    let defaults = UserDefaults.standard
    defaults.set(history.map { $0.dict }, forKey: UserDefaultsKeys.RecentSuggestion.rawValue)
    defaults.synchronize()
  }
}

extension RecentSuggestionsSource: SelectedSuggestionListener {
  static let collector = RecentSuggestionsSource()
  
  func register(dispatcher: SignalDispatcher) {
    dispatcher.register(listener: self)
  }
  
  func didSelect(suggestion: SearchResultItem) {
    var history = self.history
    history.removeAll { $0 == suggestion }
    history.insert(suggestion, at: 0)
    self.history = Array(history.prefix(100))
  }
}

extension SearchResultItem: Equatable {
  static func == (lhs: SearchResultItem, rhs: SearchResultItem) -> Bool {
    return lhs.gid == rhs.gid
  }
}

extension SearchResultItem {
  enum DictKeys: String {
    case Label = "Label"
    case Detail = "Detail"
    case Latitude = "Latitude"
    case Longitude = "Longitude"
    case Gid = "Gid"
  }
  
  var dict: [String: Any?] {
    get {
      return [
        DictKeys.Label.rawValue: label,
        DictKeys.Detail.rawValue: detail,
        DictKeys.Latitude.rawValue: coordinate.latitude,
        DictKeys.Longitude.rawValue: coordinate.longitude,
        DictKeys.Gid.rawValue: gid
      ]
    }
  }
  
  init(dict: [String: Any?]) {
    self.label = dict[DictKeys.Label.rawValue] as! String
    self.detail = dict[DictKeys.Detail.rawValue] as? String
    self.gid = dict[DictKeys.Detail.rawValue] as! String
    self.coordinate = CLLocationCoordinate2D(latitude: dict[DictKeys.Latitude.rawValue] as! Double,
                                             longitude: dict[DictKeys.Longitude.rawValue] as! Double)
  }
}
