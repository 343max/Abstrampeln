// Copyright Max von Webel. All Rights Reserved.

import CoreLocation
import Foundation

struct SearchResultItem {
  let label: String
  let detail: String?
  let coordinate: CLLocationCoordinate2D
  let gid: String
}
