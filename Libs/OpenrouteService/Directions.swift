// Copyright Max von Webel. All Rights Reserved.

import Foundation
import CoreLocation

public struct Directions {
  public let routes: [Route]
}

extension Directions {
  public struct Route {
    public let summary: Summary
    public let geometry: Geometry?
    public let segments: [Segment]
  }
}

extension Directions.Route {
  public struct Summary {
    public let distance: Float
    public let duration: TimeInterval
  }
  
  public struct Segment {
    public let distance: Float
    public let duration: TimeInterval
  }
}

extension Directions.Route.Segment {
  public struct Step: Decodable {
    public let distance: Float
    public let duration: TimeInterval
    public let type: Int
    public let instruction: String
    public let name: String
    public let wayPoints: [Int]
    
    public enum CodingKeys: String, CodingKey {
      case distance = "distance"
      case duration = "duration"
      case type = "type"
      case instruction = "instruction"
      case name = "name"
      case wayPoints = "way_points"
    }
  }
}

extension Directions.Route {
  public struct Geometry {
    public let coordinates: [CLLocationCoordinate2D]
  }
}
