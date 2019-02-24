// Copyright Max von Webel. All Rights Reserved.

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Decodable {
  public init(from decoder: Decoder) throws {
    self.init()
    self.latitude = 0
    self.longitude = 0
  }
}
