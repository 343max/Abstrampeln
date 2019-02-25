// Copyright Max von Webel. All Rights Reserved.

import Foundation
import MapKit

extension BoundingBox {
  public var mapRect: MKMapRect {
    get {
      let ne = MKMapPoint(self.northEast)
      let sw = MKMapPoint(self.southWest)
      
      return MKMapRect(x: fmin(ne.x, sw.x), y: fmin(ne.y, sw.y), width: fabs(sw.x - ne.x), height: fabs(sw.y - ne.y))
    }
  }
}

extension Geometry {
  public var geodesicPolyline: MKGeodesicPolyline {
    get {
      return MKGeodesicPolyline(coordinates: coordinates, count: coordinates.count)
    }
  }
}
