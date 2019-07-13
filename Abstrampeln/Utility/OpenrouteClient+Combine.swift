// Copyright Max von Webel. All Rights Reserved.

import Combine
import CoreLocation
import Foundation
import OpenrouteService

extension OpenrouteClient {
  public func autocomplete(text: String, focusPoint: CLLocationCoordinate2D?) -> AnyPublisher<Geocode, Error> {
    return Future<Geocode, Error> { (completion) in
      self.autocomplete(text: text, focusPoint: focusPoint) { (result) in
        completion(result)
      }
    }.eraseToAnyPublisher()
  }
  
  public func directions(start: CLLocationCoordinate2D,
                         finish: CLLocationCoordinate2D,
                         profile: Directions.Profile = .cyclingRegular,
                         language: Directions.Language = .english) -> AnyPublisher<Directions, Error> {
    return Future<Directions, Error> { (completion) in
      self.directions(start: start, finish: finish, profile: profile, language: language) { (result) in
        completion(result)
      }
    }.eraseToAnyPublisher()
  }
}
