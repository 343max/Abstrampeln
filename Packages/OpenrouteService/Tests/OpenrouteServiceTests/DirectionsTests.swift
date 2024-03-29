import CoreLocation
import XCTest
import OpenrouteService

// swiftlint:disable force_try

class DirectionsTests: XCTestCase {
    func testDirections() {
        _ = try! JSONDecoder.openroute.decode(Directions.self, from: directionsData)
    }
    
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
        let coordinate = try! JSONDecoder.openroute.decode(CLLocationCoordinate2D.self, from: data)
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
        let segment = try! JSONDecoder.openroute.decode(Directions.Route.Segment.Step.self, from: data)
        XCTAssertEqual(segment.distance, 492.6)
        XCTAssertEqual(segment.duration, 98.5)
        XCTAssertEqual(segment.type, .slightLeft)
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
        let summary = try! JSONDecoder.openroute.decode(Directions.Route.Summary.self, from: data)
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
        let segment = try! JSONDecoder.openroute.decode(Directions.Route.Segment.self, from: data)
        XCTAssertEqual(segment.distance, 5510.5)
        XCTAssertEqual(segment.duration, 1313.5)
        XCTAssertEqual(segment.steps.count, 1)
        
        if let step = segment.steps.first {
            XCTAssertEqual(step.name, "Benatweg")
        }
    }
    
    func testBoundingBox() {
        let data = """
[
  8.327707,
  48.231946,
  8.345244,
  48.263552
]
""".data(using: .utf8)!
        let boundingBox = try! JSONDecoder.openroute.decode(BoundingBox.self, from: data)
        
        XCTAssertEqual(boundingBox.northEast.latitude, 48.231946)
        XCTAssertEqual(boundingBox.northEast.longitude, 8.327707)
        XCTAssertEqual(boundingBox.southWest.latitude, 48.263552)
        XCTAssertEqual(boundingBox.southWest.longitude, 8.345244)
    }
    
    let directionsData: Data = {
        return """
{
"routes": [
{
"summary": {
"distance": 5510.5,
"duration": 1313.5
},
"geometry_format": "geojson",
"geometry": {
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
],
[
8.343945,
48.233136
],
[
8.343853,
48.233047
],
[
8.34332,
48.232736
],
[
8.343098,
48.232473
],
[
8.342861,
48.232307
],
[
8.342711,
48.23224
],
[
8.342328,
48.232159
],
[
8.342045,
48.23209
],
[
8.341843,
48.232035
],
[
8.341711,
48.231946
],
[
8.341092,
48.232163
],
[
8.340386,
48.232388
],
[
8.34028,
48.23245
],
[
8.339983,
48.23274
],
[
8.339451,
48.23315
],
[
8.3393,
48.233316
],
[
8.339219,
48.233457
],
[
8.339185,
48.233646
],
[
8.339372,
48.234329
],
[
8.339367,
48.234539
],
[
8.339262,
48.234685
],
[
8.338886,
48.234971
],
[
8.338431,
48.235181
],
[
8.338327,
48.23528
],
[
8.338234,
48.235495
],
[
8.338176,
48.235798
],
[
8.338105,
48.235955
],
[
8.337919,
48.236102
],
[
8.33725,
48.236483
],
[
8.336922,
48.236771
],
[
8.336726,
48.237039
],
[
8.336421,
48.237391
],
[
8.33621,
48.237641
],
[
8.336115,
48.237759
],
[
8.336023,
48.237946
],
[
8.335972,
48.238081
],
[
8.335947,
48.238208
],
[
8.335922,
48.238621
],
[
8.335928,
48.238977
],
[
8.335862,
48.239325
],
[
8.3357,
48.239639
],
[
8.335379,
48.23992
],
[
8.335207,
48.240171
],
[
8.335072,
48.240445
],
[
8.335089,
48.240728
],
[
8.335146,
48.240961
],
[
8.335056,
48.241105
],
[
8.334592,
48.241447
],
[
8.334338,
48.241616
],
[
8.333982,
48.241818
],
[
8.333449,
48.242185
],
[
8.333166,
48.242623
],
[
8.333047,
48.242774
],
[
8.33289,
48.242884
],
[
8.332437,
48.243097
],
[
8.332313,
48.243212
],
[
8.332203,
48.2434
],
[
8.332093,
48.243811
],
[
8.331966,
48.244102
],
[
8.331775,
48.244413
],
[
8.331649,
48.244575
],
[
8.331717,
48.24471
],
[
8.331836,
48.244822
],
[
8.332961,
48.245226
],
[
8.33325,
48.245292
],
[
8.333439,
48.245365
],
[
8.333781,
48.245519
],
[
8.334241,
48.245794
],
[
8.334417,
48.245979
],
[
8.333901,
48.246311
],
[
8.33362,
48.246637
],
[
8.33304,
48.246836
],
[
8.332729,
48.247071
],
[
8.332437,
48.247353
],
[
8.332278,
48.247583
],
[
8.332271,
48.247685
],
[
8.332345,
48.247923
],
[
8.332441,
48.248093
],
[
8.332291,
48.248137
],
[
8.331258,
48.248526
],
[
8.330556,
48.248909
],
[
8.329865,
48.249228
],
[
8.329128,
48.249545
],
[
8.328832,
48.249737
],
[
8.328606,
48.249949
],
[
8.328412,
48.250198
],
[
8.328342,
48.250322
],
[
8.328084,
48.250757
],
[
8.327975,
48.25103
],
[
8.32782,
48.251499
],
[
8.327715,
48.251941
],
[
8.327707,
48.252051
],
[
8.327735,
48.252168
],
[
8.327871,
48.252433
],
[
8.328022,
48.252827
],
[
8.328051,
48.252982
],
[
8.328067,
48.253367
],
[
8.328094,
48.253482
],
[
8.328188,
48.253678
],
[
8.328516,
48.253748
],
[
8.329388,
48.253956
],
[
8.329619,
48.25405
],
[
8.32993,
48.254114
],
[
8.330179,
48.254184
],
[
8.330565,
48.254448
],
[
8.33078,
48.254627
],
[
8.330909,
48.254812
],
[
8.331049,
48.255072
],
[
8.331165,
48.255189
],
[
8.331417,
48.25535
],
[
8.331592,
48.255536
],
[
8.331745,
48.255884
],
[
8.331778,
48.256163
],
[
8.331733,
48.256781
],
[
8.331604,
48.257332
],
[
8.332141,
48.257903
],
[
8.332452,
48.258317
],
[
8.332688,
48.258781
],
[
8.332668,
48.259148
],
[
8.332765,
48.259448
],
[
8.33286,
48.259582
],
[
8.333589,
48.259789
],
[
8.333881,
48.259898
],
[
8.334074,
48.259932
],
[
8.334615,
48.260141
],
[
8.334832,
48.260261
],
[
8.335546,
48.260712
],
[
8.335655,
48.260829
],
[
8.335753,
48.260994
],
[
8.335783,
48.261319
],
[
8.33623,
48.261624
],
[
8.337095,
48.261891
],
[
8.337525,
48.262004
],
[
8.33783,
48.262411
],
[
8.337898,
48.262441
],
[
8.337994,
48.262433
],
[
8.338356,
48.26232
],
[
8.338735,
48.262012
],
[
8.339091,
48.261771
],
[
8.339439,
48.261581
],
[
8.339604,
48.261778
],
[
8.339748,
48.261829
],
[
8.339754,
48.26183
],
[
8.33996,
48.262052
],
[
8.340984,
48.262661
],
[
8.341287,
48.262828
],
[
8.341604,
48.262945
],
[
8.342296,
48.263073
],
[
8.343026,
48.263176
],
[
8.343188,
48.263176
],
[
8.343387,
48.263132
],
[
8.3438,
48.262989
],
[
8.343999,
48.26297
],
[
8.344228,
48.263014
],
[
8.344626,
48.263142
],
[
8.344987,
48.263166
],
[
8.345244,
48.263242
],
[
8.344865,
48.263233
],
[
8.344067,
48.263207
],
[
8.343897,
48.263233
],
[
8.343478,
48.263529
],
[
8.343433,
48.263552
]
]
},
"segments": [
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
},
{
"distance": 823.2,
"duration": 164.6,
"type": 1,
"instruction": "Biegen Sie rechts auf Hölzle, K 5528 ab",
"name": "Hölzle, K 5528",
"way_points": [
12,
36
]
},
{
"distance": 51.7,
"duration": 10.3,
"type": 13,
"instruction": "rechts halten auf Sulzbacher Straße, K 5528",
"name": "Sulzbacher Straße, K 5528",
"way_points": [
36,
39
]
},
{
"distance": 321.2,
"duration": 64.2,
"type": 6,
"instruction": "Weiter geradeaus auf Sulzbacher Straße, K 5528",
"name": "Sulzbacher Straße, K 5528",
"way_points": [
39,
48
]
},
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
},
{
"distance": 265.2,
"duration": 59.7,
"type": 13,
"instruction": "rechts halten",
"name": "",
"way_points": [
63,
71
]
},
{
"distance": 302.8,
"duration": 68.1,
"type": 0,
"instruction": "Biegen Sie links ab",
"name": "",
"way_points": [
71,
80
]
},
{
"distance": 536.7,
"duration": 120.7,
"type": 0,
"instruction": "Biegen Sie links ab",
"name": "",
"way_points": [
80,
92
]
},
{
"distance": 247.6,
"duration": 55.7,
"type": 13,
"instruction": "rechts halten",
"name": "",
"way_points": [
92,
101
]
},
{
"distance": 293.7,
"duration": 75.5,
"type": 1,
"instruction": "Biegen Sie rechts ab",
"name": "",
"way_points": [
101,
111
]
},
{
"distance": 252.4,
"duration": 64.9,
"type": 12,
"instruction": "links halten",
"name": "",
"way_points": [
111,
117
]
},
{
"distance": 355.8,
"duration": 91.5,
"type": 13,
"instruction": "rechts halten",
"name": "",
"way_points": [
117,
125
]
},
{
"distance": 14.8,
"duration": 4.4,
"type": 5,
"instruction": "Biegen Sie leicht rechts ab",
"name": "",
"way_points": [
125,
126
]
},
{
"distance": 572.1,
"duration": 171.6,
"type": 12,
"instruction": "links halten",
"name": "",
"way_points": [
126,
142
]
},
{
"distance": 37.6,
"duration": 11.3,
"type": 0,
"instruction": "Biegen Sie links ab",
"name": "",
"way_points": [
142,
145
]
},
{
"distance": 469.9,
"duration": 141,
"type": 12,
"instruction": "links halten",
"name": "",
"way_points": [
145,
159
]
},
{
"distance": 165.9,
"duration": 49.8,
"type": 2,
"instruction": "Biegen Sie scharf links ab",
"name": "",
"way_points": [
159,
164
]
},
{
"distance": 0,
"duration": 0,
"type": 10,
"instruction": "Ziel erreicht (rechts)",
"name": "",
"way_points": [
164,
164
]
}
]
}
],
"way_points": [
0,
164
],
"bbox": [
8.327707,
48.231946,
8.345244,
48.263552
]
}
],
"bbox": [
8.327707,
48.231946,
8.345244,
48.263552
],
"info": {
"attribution": "openrouteservice.org | OpenStreetMap contributors",
"engine": {
"version": "4.7.0",
"build_date": "2018-12-19T09:34:35Z"
},
"service": "routing",
"timestamp": 1550954323103,
"query": {
"profile": "cycling-regular",
"preference": "recommended",
"coordinates": [
[
8.34234,
48.23424
],
[
8.34423,
48.26424
]
],
"language": "de",
"units": "m",
"geometry": true,
"geometry_format": "geojson",
"instructions_format": "text",
"instructions": true,
"elevation": false
}
}
}
""".data(using: .utf8)!
    }()
}
