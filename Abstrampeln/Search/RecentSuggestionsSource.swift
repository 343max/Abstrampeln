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
    case recentSuggestion = "RecentSuggestions"
  }

  static func load() -> [Location] {
    let dicts = UserDefaults.standard.object(forKey: UserDefaultsKeys.recentSuggestion.rawValue) as? [[String: Any?]] ?? []
    return dicts.map({ (dict) -> Location in
      return Location(dict: dict)
    })
  }

  func save() {
    let defaults = UserDefaults.standard
    defaults.set(history.map { $0.dict }, forKey: UserDefaultsKeys.recentSuggestion.rawValue)
    defaults.synchronize()
  }
}

extension RecentSuggestionsSource: DirectionsControllerDestinationListener {
  static let collector = RecentSuggestionsSource()

  func register(dispatcher: SignalDispatcher) {
    dispatcher.register(listener: self)
  }

  func destinationDidChange(_ destination: Location?) {
    guard let destination = destination, destination.isTemporary == false else { return }

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
    case label = "Label"
    case detail = "Detail"
    case latitude = "Latitude"
    case longitude = "Longitude"
    case gid = "Gid"
  }

  var dict: [String: Any] {
    var dict: [String: Any] = [
      DictKeys.label.rawValue: label,
      DictKeys.latitude.rawValue: coordinate.latitude,
      DictKeys.longitude.rawValue: coordinate.longitude,
      DictKeys.gid.rawValue: gid
    ]

    if let detail = detail {
      dict[DictKeys.detail.rawValue] = detail
    }

    return dict
  }

  init(dict: [String: Any?]) {
    // swiftlint:disable force_cast
    self.label = dict[DictKeys.label.rawValue] as! String
    self.detail = dict[DictKeys.detail.rawValue] as? String
    self.gid = dict[DictKeys.gid.rawValue] as! String
    self.coordinate = CLLocationCoordinate2D(latitude: dict[DictKeys.latitude.rawValue] as! Double,
                                             longitude: dict[DictKeys.longitude.rawValue] as! Double)
    self.isTemporary = false
    // swiftlint:enable force_cast
  }
}
