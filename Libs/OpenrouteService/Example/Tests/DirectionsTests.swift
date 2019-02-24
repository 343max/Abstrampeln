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
  
//  func testCoordinates() {
//    let data = """
//[
//8.342296,
//48.263073
//]
//""".data(using: .utf8)!
//    let coordinates = try? JSONDecoder().decode(CLLocationCoordinate2D.self, from: data)
//    XCTAssertEqual(coordinates?.longitude, 8.342296)
//    XCTAssertEqual(coordinates?.latitude, 48.263073)
//  }
  
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
}
