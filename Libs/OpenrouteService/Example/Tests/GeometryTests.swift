// Copyright Max von Webel. All Rights Reserved.

import XCTest
import OpenrouteService

class GeometryTests: XCTestCase {

  func testLineStringGeometry() {
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
    let geometry = try! JSONDecoder().decode(Geometry.self, from: data)
    XCTAssertEqual(geometry.type, .lineString)
    XCTAssertEqual(geometry.coordinates.count, 3)
    if let cooridinate = geometry.coordinates.first {
      XCTAssertEqual(cooridinate.longitude, 8.344268)
      XCTAssertEqual(cooridinate.latitude, 48.233826)
    }
  }
  
  func testPointGeometry() {
    let data = """
{
  "type": "Point",
  "coordinates": [
    16.646482,
    -20.458851
  ]
}
""".data(using: .utf8)!
    let geometry = try! JSONDecoder().decode(Geometry.self, from: data)
    XCTAssertEqual(geometry.type, .point)
    XCTAssertEqual(geometry.coordinates.count, 1)
    if let cooridinate = geometry.coordinates.first {
      XCTAssertEqual(cooridinate.longitude, 16.646482)
      XCTAssertEqual(cooridinate.latitude, -20.458851)
    }
  }
  
}
