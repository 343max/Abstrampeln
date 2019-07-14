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
    }
}

extension Directions.Route.Segment.Step {
    
    // accroding to https://github.com/GIScience/openrouteservice-docs/blob/master/README.md#instruction-types
    public enum InstructionType: Int, Decodable {
        case left = 0
        case right = 1
        case sharpLeft = 2
        case sharpRight = 3
        case slightLeft = 4
        case slightRight = 5
        case straight = 6
        case enterRoundabout = 7
        case exitRoundabout = 8
        case uTurn = 9
        case goal = 10
        case depart = 11
        case keepLeft = 12
        case keepRight = 13
    }
}

public struct BoundingBox: Decodable {
    public let northEast: CLLocationCoordinate2D
    public let southWest: CLLocationCoordinate2D
    
    public init(from decoder: Decoder) throws {
        let array = try decoder.singleValueContainer().decode([Double].self)
        precondition(array.count == 4)
        self.northEast = CLLocationCoordinate2D(array: [ array[0], array[1] ])
        self.southWest = CLLocationCoordinate2D(array: [ array[2], array[3] ])
    }
}
