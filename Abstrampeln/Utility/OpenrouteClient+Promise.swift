// Copyright Max von Webel. All Rights Reserved.

import OpenrouteService
import Promise

extension OpenrouteClient {
  public func autocomplete(text: String, focusPoint: CLLocationCoordinate2D?) -> Promise<Geocode> {
    return Promise<Geocode>({ (completion, promise) in
      self.autocomplete(text: text, focusPoint: focusPoint, callback: { (result) in
        switch result {
        case .success(let payload):
          completion(payload)
        case .failure(let error):
          promise.throw(error: error)
        }
      })
    })
  }

  public func directions(start: CLLocationCoordinate2D,
                         finish: CLLocationCoordinate2D,
                         profile: Directions.Profile = .cyclingRegular,
                         language: Directions.Language = .english) -> Promise<Directions> {
    return Promise<Directions>({ (completion, promise) in
      self.directions(start: start, finish: finish, profile: profile, language: language, callback: { (result) in
        switch result {
        case .success(let payload):
          completion(payload)
        case .failure(let error):
          promise.throw(error: error)
        }
      })
    })
  }
}
