// Copyright Max von Webel. All Rights Reserved.

import Foundation
import CoreLocation

public struct Directions: Decodable {
  public let routes: [Route]
  public let boundingBox: BoundingBox
  
  public enum CodingKeys: String, CodingKey {
    case routes = "routes"
    case boundingBox = "bbox"
  }
}

extension Directions {
  public struct Route: Decodable {
    public let summary: Summary
    public let geometry: Geometry?
    public let segments: [Segment]
    public let boundingBox: BoundingBox
    
    public enum CodingKeys: String, CodingKey {
      case summary = "summary"
      case geometry = "geometry"
      case segments = "segments"
      case boundingBox = "bbox"
    }
  }
}

extension Directions.Route {
  public struct Summary: Decodable {
    public let distance: Float
    public let duration: TimeInterval
  }
  
  public struct Segment: Decodable {
    public let distance: Float
    public let duration: TimeInterval
    public let steps: [Step]
  }
}

extension Directions.Route.Segment {
  public struct Step: Decodable {
    public let distance: Float
    public let duration: TimeInterval
    public let type: InstructionType
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

extension Directions.Route.Segment.Step {
  
  // accroding to https://github.com/GIScience/openrouteservice-docs/blob/master/README.md#instruction-types
  public enum InstructionType: Int, Decodable {
    case Left = 0
    case Right = 1
    case SharpLeft = 2
    case SharpRight = 3
    case SlightLeft = 4
    case SlightRight = 5
    case Straight = 6
    case EnterRoundabout = 7
    case ExitRoundabout = 8
    case UTurn = 9
    case Goal = 10
    case Depart = 11
    case KeepLeft = 12
    case KeepRight = 13
  }
}

public struct BoundingBox: Decodable {
  public let northEast: CLLocationCoordinate2D
  public let southWest: CLLocationCoordinate2D
  
  public init(from decoder: Decoder) {
    let array = try! decoder.singleValueContainer().decode([Double].self)
    assert(array.count == 4)
    self.northEast = CLLocationCoordinate2D(array: [ array[0], array[1] ])
    self.southWest = CLLocationCoordinate2D(array: [ array[2], array[3] ])
  }
}
