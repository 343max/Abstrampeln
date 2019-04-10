// Copyright Max von Webel. All Rights Reserved.

import XCTest
import OpenrouteService

 // swiftlint:disable force_try

class GeocodeTests: XCTestCase {
  private func data(fileName: String) -> Data {
    let bundle = Bundle(for: type(of: self))
    let url = bundle.url(forResource: fileName, withExtension: "json")!
    return try! Data(contentsOf: url)
  }

  func testGeocodeAutcomplete() {
    let data = self.data(fileName: "Geocode_Autocomplete")
    let geocode = try! JSONDecoder.openroute.decode(Geocode.self, from: data)
    XCTAssertEqual(geocode.features.count, 9)
  }

  func testGeocodeSearch() {
    let data = self.data(fileName: "Geocode_Search")
    let geocode = try! JSONDecoder.openroute.decode(Geocode.self, from: data)
    XCTAssertEqual(geocode.features.count, 10)
  }

  func testFeature() {
    let data = """
{
  "type": "Feature",
  "geometry": {
    "type": "Point",
    "coordinates": [
      13.433299,
      52.533359
    ]
  },
  "properties": {
    "id": "de/berlin:03dba121b3358265",
    "gid": "openaddresses:address:de/berlin:03dba121b3358265",
    "layer": "address",
    "source": "openaddresses",
    "source_id": "de/berlin:03dba121b3358265",
    "name": "Esmarchstraße 13",
    "housenumber": "13",
    "street": "Esmarchstraße",
    "postalcode": "10407",
    "distance": 2.713,
    "accuracy": "point",
    "country": "Germany",
    "country_gid": "whosonfirst:country:85633111",
    "country_a": "DEU",
    "region": "Berlin",
    "region_gid": "whosonfirst:region:85682499",
    "county": "Berlin ",
    "county_gid": "whosonfirst:county:102063945",
    "locality": "Berlin",
    "locality_gid": "whosonfirst:locality:101748799",
    "borough": "Pankow",
    "borough_gid": "whosonfirst:borough:1108815549",
    "neighbourhood": "Prenzlauer Berg",
    "neighbourhood_gid": "whosonfirst:neighbourhood:420784283",
    "continent": "Europe",
    "continent_gid": "whosonfirst:continent:102191581",
    "label": "Esmarchstraße 13, Berlin, Germany"
  }
}
""".data(using: .utf8)!
    let feature = try! JSONDecoder.openroute.decode(Geocode.Feature.self, from: data)
    XCTAssertEqual(feature.type, .feature)

    XCTAssertEqual(feature.properties.id, "de/berlin:03dba121b3358265")
    XCTAssertEqual(feature.properties.gid, "openaddresses:address:de/berlin:03dba121b3358265")
    XCTAssertEqual(feature.properties.layer, "address")
    XCTAssertEqual(feature.properties.source, "openaddresses")
    XCTAssertEqual(feature.properties.sourceId, "de/berlin:03dba121b3358265")
    XCTAssertEqual(feature.properties.name, "Esmarchstraße 13")
    XCTAssertEqual(feature.properties.housenumber, "13")
    XCTAssertEqual(feature.properties.street, "Esmarchstraße")
    XCTAssertEqual(feature.properties.postalcode, "10407")
    XCTAssertEqual(feature.properties.distance, 2.713)
    XCTAssertEqual(feature.properties.country, "Germany")
    XCTAssertEqual(feature.properties.countryGid, "whosonfirst:country:85633111")
    XCTAssertEqual(feature.properties.countryA, "DEU")
    XCTAssertEqual(feature.properties.region, "Berlin")
    XCTAssertEqual(feature.properties.regionGid, "whosonfirst:region:85682499")
    XCTAssertEqual(feature.properties.county, "Berlin ")
    XCTAssertEqual(feature.properties.countyGid, "whosonfirst:county:102063945")
    XCTAssertEqual(feature.properties.locality, "Berlin")
    XCTAssertEqual(feature.properties.localityGid, "whosonfirst:locality:101748799")
    XCTAssertEqual(feature.properties.borough, "Pankow")
    XCTAssertEqual(feature.properties.boroughGid, "whosonfirst:borough:1108815549")
    XCTAssertEqual(feature.properties.neighbourhood, "Prenzlauer Berg")
    XCTAssertEqual(feature.properties.neighbourhoodGid, "whosonfirst:neighbourhood:420784283")
    XCTAssertEqual(feature.properties.continent, "Europe")
    XCTAssertEqual(feature.properties.continentGid, "whosonfirst:continent:102191581")
    XCTAssertEqual(feature.properties.label, "Esmarchstraße 13, Berlin, Germany")
  }
}
