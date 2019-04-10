// Copyright Max von Webel. All Rights Reserved.

import CoreLocation
import Foundation

struct Location {
  let label: String
  let detail: String?
  let coordinate: CLLocationCoordinate2D
  let gid: String
  let isTemporary: Bool

  init(label: String, detail: String?, coordinate: CLLocationCoordinate2D, gid: String, isTemporary: Bool = false) {
    self.label = label
    self.detail = detail
    self.coordinate = coordinate
    self.gid = gid
    self.isTemporary = isTemporary
  }
}
