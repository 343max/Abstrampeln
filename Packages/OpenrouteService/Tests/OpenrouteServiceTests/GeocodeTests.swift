// Copyright Max von Webel. All Rights Reserved.

import XCTest
import OpenrouteService

// swiftlint:disable force_try

class GeocodeTests: XCTestCase {
    func testGeocodeAutcomplete() {
        let geocode = try! JSONDecoder.openroute.decode(Geocode.self, from: geocodeAutocompleteData)
        XCTAssertEqual(geocode.features.count, 9)
    }
    
    func testGeocodeSearch() {
        let geocode = try! JSONDecoder.openroute.decode(Geocode.self, from: geocodeSearchData)
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
    
    let geocodeAutocompleteData: Data = {
        return """
{
"geocoding": {
"version": "0.2",
"attribution": "openrouteservice.org | OpenStreetMap contributors | Geocoding by Pelias",
"query": {
"text": "13 esmarc",
"parser": "addressit",
"parsed_text": {},
"tokens": [
"13",
"esmarc"
],
"size": 10,
"private": false,
"focus.point.lat": 52.51118,
"focus.point.lon": 13.44988,
"lang": {
"name": "English",
"iso6391": "en",
"iso6393": "eng",
"defaulted": true
}
},
"engine": {
"name": "Pelias",
"author": "Mapzen",
"version": "1.0"
},
"timestamp": 1551271200973
},
"type": "FeatureCollection",
"features": [
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
},
{
"type": "Feature",
"geometry": {
"type": "Point",
"coordinates": [
9.664492,
53.761052
]
},
"properties": {
"id": "way:318960318",
"gid": "openstreetmap:address:way:318960318",
"layer": "address",
"source": "openstreetmap",
"source_id": "way:318960318",
"name": "Esmarchstraße 13",
"housenumber": "13",
"street": "Esmarchstraße",
"distance": 288.961,
"accuracy": "point",
"country": "Germany",
"country_gid": "whosonfirst:country:85633111",
"country_a": "DEU",
"region": "Schleswig-Holstein",
"region_gid": "whosonfirst:region:85682517",
"county": "Pinneberg ",
"county_gid": "whosonfirst:county:102064081",
"locality": "Elmshorn",
"locality_gid": "whosonfirst:locality:101838093",
"continent": "Europe",
"continent_gid": "whosonfirst:continent:102191581",
"label": "Esmarchstraße 13, Elmshorn, Germany"
}
},
{
"type": "Feature",
"geometry": {
"type": "Point",
"coordinates": [
8.887592,
53.063066
]
},
"properties": {
"id": "way:294852446",
"gid": "openstreetmap:address:way:294852446",
"layer": "address",
"source": "openstreetmap",
"source_id": "way:294852446",
"name": "Esmarchstraße 13",
"housenumber": "13",
"street": "Esmarchstraße",
"postalcode": "28309",
"distance": 313.813,
"accuracy": "point",
"country": "Germany",
"country_gid": "whosonfirst:country:85633111",
"country_a": "DEU",
"region": "Bremen",
"region_gid": "whosonfirst:region:85682561",
"county": "Bremen",
"county_gid": "whosonfirst:county:102063991",
"locality": "Bremen",
"locality_gid": "whosonfirst:locality:101748829",
"continent": "Europe",
"continent_gid": "whosonfirst:continent:102191581",
"label": "Esmarchstraße 13, Bremen, Germany"
}
},
{
"type": "Feature",
"geometry": {
"type": "Point",
"coordinates": [
6.793054,
51.444656
]
},
"properties": {
"id": "de/nw/statewide:7309d498c68271a3",
"gid": "openaddresses:address:de/nw/statewide:7309d498c68271a3",
"layer": "address",
"source": "openaddresses",
"source_id": "de/nw/statewide:7309d498c68271a3",
"name": "Esmarchstr. 13",
"housenumber": "13",
"street": "Esmarchstr.",
"distance": 472.353,
"accuracy": "point",
"country": "Germany",
"country_gid": "whosonfirst:country:85633111",
"country_a": "DEU",
"region": "Nordrhein-Westfalen",
"region_gid": "whosonfirst:region:85682513",
"region_a": "NRW",
"macrocounty": "Düsseldorf",
"macrocounty_gid": "whosonfirst:macrocounty:404227561",
"county": "Duisburg ",
"county_gid": "whosonfirst:county:102063799",
"locality": "Duisburg",
"locality_gid": "whosonfirst:locality:101748713",
"neighbourhood": "Neudorf",
"neighbourhood_gid": "whosonfirst:neighbourhood:85863029",
"continent": "Europe",
"continent_gid": "whosonfirst:continent:102191581",
"label": "Esmarchstr. 13, Duisburg, Germany"
}
},
{
"type": "Feature",
"geometry": {
"type": "Point",
"coordinates": [
6.793053,
51.444641
]
},
"properties": {
"id": "way:213431051",
"gid": "openstreetmap:address:way:213431051",
"layer": "address",
"source": "openstreetmap",
"source_id": "way:213431051",
"name": "Esmarchstraße 13",
"housenumber": "13",
"street": "Esmarchstraße",
"postalcode": "47058",
"distance": 472.354,
"accuracy": "point",
"country": "Germany",
"country_gid": "whosonfirst:country:85633111",
"country_a": "DEU",
"region": "Nordrhein-Westfalen",
"region_gid": "whosonfirst:region:85682513",
"region_a": "NRW",
"macrocounty": "Düsseldorf",
"macrocounty_gid": "whosonfirst:macrocounty:404227561",
"county": "Duisburg ",
"county_gid": "whosonfirst:county:102063799",
"locality": "Duisburg",
"locality_gid": "whosonfirst:locality:101748713",
"neighbourhood": "Neudorf",
"neighbourhood_gid": "whosonfirst:neighbourhood:85863029",
"continent": "Europe",
"continent_gid": "whosonfirst:continent:102191581",
"label": "Esmarchstraße 13, Duisburg, Germany"
}
},
{
"type": "Feature",
"geometry": {
"type": "Point",
"coordinates": [
10.507365,
56.387643
]
},
"properties": {
"id": "dk/countrywide:6945d16c7da4875d",
"gid": "openaddresses:address:dk/countrywide:6945d16c7da4875d",
"layer": "address",
"source": "openaddresses",
"source_id": "dk/countrywide:6945d16c7da4875d",
"name": "Esmarcksvej 13",
"housenumber": "13",
"street": "Esmarcksvej",
"postalcode": "8550",
"distance": 471.726,
"accuracy": "point",
"country": "Denmark",
"country_gid": "whosonfirst:country:85633121",
"country_a": "DNK",
"region": "Midtjylland",
"region_gid": "whosonfirst:region:85682597",
"locality": "Ryomgård",
"locality_gid": "whosonfirst:locality:101817281",
"continent": "Europe",
"continent_gid": "whosonfirst:continent:102191581",
"label": "Esmarcksvej 13, Ryomgård, Denmark"
}
},
{
"type": "Feature",
"geometry": {
"type": "Point",
"coordinates": [
6.780672,
51.207347
]
},
"properties": {
"id": "way:188435269",
"gid": "openstreetmap:address:way:188435269",
"layer": "address",
"source": "openstreetmap",
"source_id": "way:188435269",
"name": "Esmarchstraße 13",
"housenumber": "13",
"street": "Esmarchstraße",
"postalcode": "40223",
"distance": 481.613,
"accuracy": "point",
"country": "Germany",
"country_gid": "whosonfirst:country:85633111",
"country_a": "DEU",
"region": "Nordrhein-Westfalen",
"region_gid": "whosonfirst:region:85682513",
"region_a": "NRW",
"macrocounty": "Düsseldorf",
"macrocounty_gid": "whosonfirst:macrocounty:404227561",
"county": "Düsseldorf ",
"county_gid": "whosonfirst:county:102063759",
"locality": "Dusseldorf",
"locality_gid": "whosonfirst:locality:101748671",
"neighbourhood": "Flingern",
"neighbourhood_gid": "whosonfirst:neighbourhood:85795219",
"continent": "Europe",
"continent_gid": "whosonfirst:continent:102191581",
"label": "Esmarchstraße 13, Dusseldorf, Germany"
}
},
{
"type": "Feature",
"geometry": {
"type": "Point",
"coordinates": [
11.464182,
48.185289
]
},
"properties": {
"id": "node:2983581545",
"gid": "openstreetmap:address:node:2983581545",
"layer": "address",
"source": "openstreetmap",
"source_id": "node:2983581545",
"name": "Esmarchstraße 13",
"housenumber": "13",
"street": "Esmarchstraße",
"distance": 501.468,
"accuracy": "point",
"country": "Germany",
"country_gid": "whosonfirst:country:85633111",
"country_a": "DEU",
"region": "Bayern",
"region_gid": "whosonfirst:region:85682571",
"macrocounty": "Oberbayern",
"macrocounty_gid": "whosonfirst:macrocounty:404227567",
"county": "München ",
"county_gid": "whosonfirst:county:102063261",
"locality": "Munich",
"locality_gid": "whosonfirst:locality:101748479",
"neighbourhood": "Allach",
"neighbourhood_gid": "whosonfirst:neighbourhood:85898939",
"continent": "Europe",
"continent_gid": "whosonfirst:continent:102191581",
"label": "Esmarchstraße 13, Munich, Germany"
}
},
{
"type": "Feature",
"geometry": {
"type": "Point",
"coordinates": [
10.141361,
54.341268
]
},
"properties": {
"id": "way:100299505",
"gid": "openstreetmap:address:way:100299505",
"layer": "address",
"source": "openstreetmap",
"source_id": "way:100299505",
"name": "Esmarchstraße 11-13",
"housenumber": "11-13",
"street": "Esmarchstraße",
"postalcode": "24105",
"distance": 299.699,
"accuracy": "point",
"country": "Germany",
"country_gid": "whosonfirst:country:85633111",
"country_a": "DEU",
"region": "Schleswig-Holstein",
"region_gid": "whosonfirst:region:85682517",
"county": "Kiel ",
"county_gid": "whosonfirst:county:102064125",
"locality": "Kiel",
"locality_gid": "whosonfirst:locality:101748869",
"continent": "Europe",
"continent_gid": "whosonfirst:continent:102191581",
"label": "Esmarchstraße 11-13, Kiel, Germany"
}
}
],
"bbox": [
6.780672,
48.185289,
13.433299,
56.387643
]
}
""".data(using: .utf8)!
    }()
    
    let geocodeSearchData: Data = {
        return """

{
"geocoding": {
"version": "0.2",
"attribution": "openrouteservice.org | OpenStreetMap contributors | Geocoding by Pelias",
"query": {
"text": "Namibian Brewery",
"size": 10,
"private": false,
"lang": {
"name": "English",
"iso6391": "en",
"iso6393": "eng",
"defaulted": true
},
"querySize": 20,
"parser": "addressit",
"parsed_text": {}
},
"engine": {
"name": "Pelias",
"author": "Mapzen",
"version": "1.0"
},
"timestamp": 1551271523071
},
"type": "FeatureCollection",
"features": [
{
"type": "Feature",
"geometry": {
"type": "Point",
"coordinates": [
16.646482,
-20.458851
]
},
"properties": {
"id": "node:4684870705",
"gid": "openstreetmap:venue:node:4684870705",
"layer": "venue",
"source": "openstreetmap",
"source_id": "node:4684870705",
"name": "Namibian Brewery",
"confidence": 1,
"match_type": "exact",
"accuracy": "point",
"country": "Namibia",
"country_gid": "whosonfirst:country:85632535",
"country_a": "NAM",
"region": "Otjozondjupa",
"region_gid": "whosonfirst:region:85675217",
"county": "Otjiwarongo",
"county_gid": "whosonfirst:county:421186163",
"continent": "Africa",
"continent_gid": "whosonfirst:continent:102191573",
"label": "Namibian Brewery, Namibia"
}
},
{
"type": "Feature",
"geometry": {
"type": "Point",
"coordinates": [
17.075791,
-22.561616
]
},
"properties": {
"id": "node:3694091994",
"gid": "openstreetmap:venue:node:3694091994",
"layer": "venue",
"source": "openstreetmap",
"source_id": "node:3694091994",
"name": "The Namibian",
"confidence": 1,
"match_type": "exact",
"accuracy": "point",
"country": "Namibia",
"country_gid": "whosonfirst:country:85632535",
"country_a": "NAM",
"region": "Khomas",
"region_gid": "whosonfirst:region:85675205",
"county": "Windhoek West",
"county_gid": "whosonfirst:county:421186345",
"continent": "Africa",
"continent_gid": "whosonfirst:continent:102191573",
"label": "The Namibian, Namibia"
}
},
{
"type": "Feature",
"geometry": {
"type": "Point",
"coordinates": [
20.502481,
-19.593445
]
},
"properties": {
"id": "node:5058180949",
"gid": "openstreetmap:venue:node:5058180949",
"layer": "venue",
"source": "openstreetmap",
"source_id": "node:5058180949",
"name": "Namibian Police",
"confidence": 1,
"match_type": "exact",
"accuracy": "point",
"country": "Namibia",
"country_gid": "whosonfirst:country:85632535",
"country_a": "NAM",
"region": "Otjozondjupa",
"region_gid": "whosonfirst:region:85675217",
"county": "Tsumkwe",
"county_gid": "whosonfirst:county:1108785203",
"continent": "Africa",
"continent_gid": "whosonfirst:continent:102191573",
"label": "Namibian Police, Namibia"
}
},
{
"type": "Feature",
"geometry": {
"type": "Point",
"coordinates": [
24.246538,
-17.477939
]
},
"properties": {
"id": "way:362743034",
"gid": "openstreetmap:venue:way:362743034",
"layer": "venue",
"source": "openstreetmap",
"source_id": "way:362743034",
"name": "Namibian Borderpost",
"confidence": 1,
"match_type": "exact",
"accuracy": "point",
"country": "Namibia",
"country_gid": "whosonfirst:country:85632535",
"country_a": "NAM",
"region": "Zambezi",
"region_gid": "whosonfirst:region:1108804901",
"county": "Katima Mulilo Rural",
"county_gid": "whosonfirst:county:421199941",
"continent": "Africa",
"continent_gid": "whosonfirst:continent:102191573",
"label": "Namibian Borderpost, Namibia"
},
"bbox": [
24.24589,
-17.478481,
24.247183,
-17.477172
]
},
{
"type": "Feature",
"geometry": {
"type": "Point",
"coordinates": [
17.084228,
-22.560193
]
},
"properties": {
"id": "node:811183175",
"gid": "openstreetmap:venue:node:811183175",
"layer": "venue",
"source": "openstreetmap",
"source_id": "node:811183175",
"name": "Namibian Police",
"confidence": 1,
"match_type": "exact",
"accuracy": "point",
"country": "Namibia",
"country_gid": "whosonfirst:country:85632535",
"country_a": "NAM",
"region": "Khomas",
"region_gid": "whosonfirst:region:85675205",
"county": "Windhoek East",
"county_gid": "whosonfirst:county:421191505",
"continent": "Africa",
"continent_gid": "whosonfirst:continent:102191573",
"label": "Namibian Police, Namibia"
}
},
{
"type": "Feature",
"geometry": {
"type": "Point",
"coordinates": [
19.802838,
-17.872563
]
},
"properties": {
"id": "node:5316588166",
"gid": "openstreetmap:venue:node:5316588166",
"layer": "venue",
"source": "openstreetmap",
"source_id": "node:5316588166",
"name": "Namibian Borderpost",
"confidence": 1,
"match_type": "exact",
"accuracy": "point",
"country": "Namibia",
"country_gid": "whosonfirst:country:85632535",
"country_a": "NAM",
"county": "Rundu Rural East",
"county_gid": "whosonfirst:county:1108785189",
"continent": "Africa",
"continent_gid": "whosonfirst:continent:102191573",
"label": "Namibian Borderpost, Namibia"
}
},
{
"type": "Feature",
"geometry": {
"type": "Point",
"coordinates": [
-84.517838,
39.076605
]
},
"properties": {
"id": "way:123063383",
"gid": "openstreetmap:venue:way:123063383",
"layer": "venue",
"source": "openstreetmap",
"source_id": "way:123063383",
"name": "Bavarian Brewery",
"confidence": 1,
"match_type": "exact",
"accuracy": "point",
"country": "United States",
"country_gid": "whosonfirst:country:85633793",
"country_a": "USA",
"region": "Kentucky",
"region_gid": "whosonfirst:region:85688641",
"region_a": "KY",
"county": "Kenton County",
"county_gid": "whosonfirst:county:102084469",
"locality": "Park Hills",
"locality_gid": "whosonfirst:locality:85947203",
"neighbourhood": "West Covington",
"neighbourhood_gid": "whosonfirst:neighbourhood:420534885",
"continent": "North America",
"continent_gid": "whosonfirst:continent:102191575",
"label": "Bavarian Brewery, Park Hills, KY, USA"
},
"bbox": [
-84.518218,
39.076284,
-84.517121,
39.076843
]
},
{
"type": "Feature",
"geometry": {
"type": "Point",
"coordinates": [
-77.005457,
41.240434
]
},
"properties": {
"id": "node:48772442",
"gid": "openstreetmap:venue:node:48772442",
"layer": "venue",
"source": "openstreetmap",
"source_id": "node:48772442",
"name": "Bullfrog Brewery",
"confidence": 1,
"match_type": "exact",
"accuracy": "point",
"country": "United States",
"country_gid": "whosonfirst:country:85633793",
"country_a": "USA",
"region": "Pennsylvania",
"region_gid": "whosonfirst:region:85688481",
"region_a": "PA",
"county": "Lycoming County",
"county_gid": "whosonfirst:county:102081317",
"localadmin": "Williamsport",
"localadmin_gid": "whosonfirst:localadmin:404485355",
"locality": "Williamsport",
"locality_gid": "whosonfirst:locality:101716809",
"continent": "North America",
"continent_gid": "whosonfirst:continent:102191575",
"label": "Bullfrog Brewery, Williamsport, PA, USA"
}
},
{
"type": "Feature",
"geometry": {
"type": "Point",
"coordinates": [
-105.078585,
40.566354
]
},
"properties": {
"id": "node:2047096083",
"gid": "openstreetmap:venue:node:2047096083",
"layer": "venue",
"source": "openstreetmap",
"source_id": "node:2047096083",
"name": "Black Bottle Brewery",
"housenumber": "1611",
"street": "South College Avenue",
"postalcode": "80525-1006",
"confidence": 1,
"match_type": "exact",
"accuracy": "point",
"country": "United States",
"country_gid": "whosonfirst:country:85633793",
"country_a": "USA",
"region": "Colorado",
"region_gid": "whosonfirst:region:85688603",
"region_a": "CO",
"county": "Larimer County",
"county_gid": "whosonfirst:county:102083353",
"locality": "Fort Collins",
"locality_gid": "whosonfirst:locality:85929679",
"locality_a": "Ft. Collins",
"continent": "North America",
"continent_gid": "whosonfirst:continent:102191575",
"label": "Black Bottle Brewery, Fort Collins, CO, USA"
}
},
{
"type": "Feature",
"geometry": {
"type": "Point",
"coordinates": [
-112.297494,
40.56075
]
},
"properties": {
"id": "node:1784677213",
"gid": "openstreetmap:venue:node:1784677213",
"layer": "venue",
"source": "openstreetmap",
"source_id": "node:1784677213",
"name": "Bonneville Brewery",
"confidence": 1,
"match_type": "exact",
"accuracy": "point",
"country": "United States",
"country_gid": "whosonfirst:country:85633793",
"country_a": "USA",
"region": "Utah",
"region_gid": "whosonfirst:region:85688567",
"region_a": "UT",
"county": "Tooele County",
"county_gid": "whosonfirst:county:102086945",
"locality": "Tooele",
"locality_gid": "whosonfirst:locality:101727971",
"continent": "North America",
"continent_gid": "whosonfirst:continent:102191575",
"label": "Bonneville Brewery, Tooele, UT, USA"
}
}
],
"bbox": [
-112.297494,
-22.561616,
24.247183,
41.240434
]
}
""".data(using: .utf8)!
    }()
}
