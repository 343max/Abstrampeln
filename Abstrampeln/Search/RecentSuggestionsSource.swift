// Copyright Max von Webel. All Rights Reserved.

import Foundation
import CoreLocation

class RecentSuggestionsSource {
  var history: [Location] {
    didSet {
      save()
    }
  }
  
  init() {
    history = RecentSuggestionsSource.load()
  }
}

extension RecentSuggestionsSource: SearchResultsDataSource {
  func searchFor(text: String, completion: @escaping (String, [Location]) -> ()) -> Bool {
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
  
  static func load() -> [Location] {
    let dicts = UserDefaults.standard.object(forKey: UserDefaultsKeys.RecentSuggestion.rawValue) as? [[String: Any?]] ?? []
    return dicts.map({ (dict) -> Location in
      return Location(dict: dict)
    })
  }
  
  func save() {
    let defaults = UserDefaults.standard
    defaults.set(history.map { $0.dict }, forKey: UserDefaultsKeys.RecentSuggestion.rawValue)
    defaults.synchronize()
  }
}

extension RecentSuggestionsSource: DirectionsControllerDestinationListener {
  static let collector = RecentSuggestionsSource()
  
  func register(dispatcher: SignalDispatcher) {
    dispatcher.register(listener: self)
  }
  
  func destinationDidChange(_ destination: Location?) {
    guard let destination = destination else { return }

    var history = self.history
    history.removeAll { $0 == destination }
    history.insert(destination, at: 0)
    self.history = Array(history.prefix(100))
  }
}

extension Location: Equatable {
  static func == (lhs: Location, rhs: Location) -> Bool {
    return lhs.gid == rhs.gid
  }
}

extension Location {
  enum DictKeys: String {
    case Label = "Label"
    case Detail = "Detail"
    case Latitude = "Latitude"
    case Longitude = "Longitude"
    case Gid = "Gid"
  }
  
  var dict: [String: Any] {
    get {
      var dict: [String: Any] = [
        DictKeys.Label.rawValue: label,
        DictKeys.Latitude.rawValue: coordinate.latitude,
        DictKeys.Longitude.rawValue: coordinate.longitude,
        DictKeys.Gid.rawValue: gid
      ]
      
      if let detail = detail {
        dict[DictKeys.Detail.rawValue] = detail
      }
      
      return dict
    }
  }
  
  init(dict: [String: Any?]) {
    self.label = dict[DictKeys.Label.rawValue] as! String
    self.detail = dict[DictKeys.Detail.rawValue] as? String
    self.gid = dict[DictKeys.Gid.rawValue] as! String
    self.coordinate = CLLocationCoordinate2D(latitude: dict[DictKeys.Latitude.rawValue] as! Double,
                                             longitude: dict[DictKeys.Longitude.rawValue] as! Double)
  }
}
