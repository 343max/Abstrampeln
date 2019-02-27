// Copyright Max von Webel. All Rights Reserved.

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
  public init(array: [Double]) {
    assert(array.count == 2)
    self.init()
    self.longitude = array[0]
    self.latitude = array[1]
  }
}

extension CLLocationCoordinate2D: Decodable {
  public init(from decoder: Decoder) throws {
    let array = try! decoder.singleValueContainer().decode([Double].self)
    self.init(array: array)
  }
}
