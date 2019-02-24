import CoreLocation
import XCTest
import OpenrouteService

class Tests: XCTestCase {
  
  private func data(fileName: String) -> Data {
    let bundle = Bundle(for: type(of: self))
    let url = bundle.url(forResource: fileName, withExtension: "json")!
    return try! Data(contentsOf: url)
  }

  
//  func testDirections() {
//    let data = self.data(fileName: "Directions")
//    let directions = try JSONDecoder().decode(Directions.self, from: data)
//  }
  
  func testCoordinates() {
    let array = [
      8.343853,
      48.233047
    ]
    let coordinate = CLLocationCoordinate2D(array: array)
    XCTAssertEqual(coordinate.longitude, 8.343853)
    XCTAssertEqual(coordinate.latitude, 48.233047)
  }
  
  func testCoordinatesDecode() {
    let data = """
[
  8.343853,
  48.233047
]
""".data(using: .utf8)!
    let coordinate = try! JSONDecoder().decode(CLLocationCoordinate2D.self, from: data)
    XCTAssertEqual(coordinate.longitude, 8.343853)
    XCTAssertEqual(coordinate.latitude, 48.233047)
  }
  
  func testSegmentStep() {
    let data = """
{
"distance": 492.6,
"duration": 98.5,
"type": 4,
"instruction": "Biegen Sie leicht links auf Sulzbacher Straße, K 5528 ab",
"name": "Sulzbacher Straße, K 5528",
"way_points": [
48,
63
]
}
""".data(using: .utf8)!
    let segment = try! JSONDecoder().decode(Directions.Route.Segment.Step.self, from: data)
    XCTAssertEqual(segment.distance, 492.6)
    XCTAssertEqual(segment.duration, 98.5)
    XCTAssertEqual(segment.type, 4)
    XCTAssertEqual(segment.instruction, "Biegen Sie leicht links auf Sulzbacher Straße, K 5528 ab")
    XCTAssertEqual(segment.name, "Sulzbacher Straße, K 5528")
    XCTAssertEqual(segment.wayPoints, [48, 63])
  }
  
  func testSummary() {
    let data = """
{
"distance": 5510.5,
"duration": 1313.5
}
""".data(using: .utf8)!
    let summary = try! JSONDecoder().decode(Directions.Route.Summary.self, from: data)
    XCTAssertEqual(summary.distance, 5510.5)
    XCTAssertEqual(summary.duration, 1313.5)

  }
  
  func testSegment() {
    let data = """
{
"distance": 5510.5,
"duration": 1313.5,
"steps": [
{
"distance": 307.3,
"duration": 61.5,
"type": 11,
"instruction": "Weiter südlich auf Benatweg",
"name": "Benatweg",
"way_points": [
0,
12
]
}
]
}
""".data(using: .utf8)!
    let segment = try! JSONDecoder().decode(Directions.Route.Segment.self, from: data)
    XCTAssertEqual(segment.distance, 5510.5)
    XCTAssertEqual(segment.duration, 1313.5)
    XCTAssertEqual(segment.steps.count, 1)
    
    if let step = segment.steps.first {
      XCTAssertEqual(step.name, "Benatweg")
    }
  }
  
  func testGeometry() {
    let data = """
{
  "type": "LineString",
  "coordinates": [
    [
      8.344268,
      48.233826
    ],
    [
      8.344147,
      48.233507
    ],
    [
      8.344098,
      48.233435
    ]
  ]
}
""".data(using: .utf8)!
    let geometry = try! JSONDecoder().decode(Directions.Route.Geometry.self, from: data)
    XCTAssertEqual(geometry.coordinates.count, 3)
    if let cooridinate = geometry.coordinates.first {
      XCTAssertEqual(cooridinate.longitude, 8.344268)
      XCTAssertEqual(cooridinate.latitude, 48.233826)
    }
  }
}
