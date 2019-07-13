// Copyright Max von Webel. All Rights Reserved.

import Combine
import Foundation
import CoreLocation

class RecentSuggestionsSource {
  var history: [Location] {
    didSet {
      save()
    }
  }

  init() {
    do {
      history = try RecentSuggestionsSource.load()
    } catch {
      history = []
    }
  }
}

extension RecentSuggestionsSource: SearchResultsDataSource {
  func searchFor(text: String) -> AnyPublisher<(String, [Location]), Error> {
    return Just<(String, [Location])>((text, []))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
  }
}

extension RecentSuggestionsSource {
  enum UserDefaultsKeys: String {
    case recentSuggestion = "RecentSuggestions"
  }

  static func load() throws -> [Location] {
    let dicts = UserDefaults.standard.object(forKey: UserDefaultsKeys.recentSuggestion.rawValue) as? [[String: Any?]] ?? []
    return try dicts.map({ (dict) throws -> Location in
      return try Location(dict: dict)
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

  enum ParsingError: Error {
    case invalidType(_ property: String)
  }

  init(dict: [String: Any?]) throws {
    self.label = try dict[DictKeys.label.rawValue] as? String ?! ParsingError.invalidType(DictKeys.label.rawValue)
    self.detail = dict[DictKeys.detail.rawValue] as? String
    self.gid = try dict[DictKeys.gid.rawValue] as? String ?! ParsingError.invalidType(DictKeys.gid.rawValue)
    self.coordinate = CLLocationCoordinate2D(latitude: try dict[DictKeys.latitude.rawValue] as? Double ?! ParsingError.invalidType(DictKeys.latitude.rawValue),
                                             longitude: try dict[DictKeys.longitude.rawValue] as? Double ?! ParsingError.invalidType(DictKeys.longitude.rawValue))
    self.isTemporary = false
  }
}
