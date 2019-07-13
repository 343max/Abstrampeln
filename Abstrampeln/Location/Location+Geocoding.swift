// Copyright Max von Webel. All Rights Reserved.

import Combine
import CoreLocation
import Foundation

extension CLLocation {
  convenience init(coordinate: CLLocationCoordinate2D) {
    self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
  }
}

extension Location {
  static func reverseLookup(coordinate: CLLocationCoordinate2D) -> AnyPublisher<Location, Never> {
    return Future<Location, Never> { (completion) in
      let geocoder = CLGeocoder()
      let location = CLLocation(coordinate: coordinate)
      geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) in
        if let placemark = placemarks?.first {
          if let name = placemark.name,
            let addressLines = placemark.addressDictionary?["FormattedAddressLines"] as? [String],
            let coordinate = placemark.location?.coordinate {
            let location = Location(label: name,
                                    detail: addressLines.joined(separator: ", "),
                                    coordinate: coordinate,
                                    gid: "geocoder:\(coordinate.latitude),\(coordinate.longitude)")
            completion(.success(location))
          }
        }
      })
    }.eraseToAnyPublisher()
  }
}
