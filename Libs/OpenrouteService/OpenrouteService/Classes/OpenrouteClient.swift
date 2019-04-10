// Copyright Max von Webel. All Rights Reserved.

import Foundation
import CoreLocation

public extension JSONDecoder {
    static let openroute: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}

public class OpenrouteClient {
  let client: NetworkingClient

  public init(networkingClient: NetworkingClient) {
    self.client = networkingClient
  }

  // search:
  // https://api.openrouteservice.org/geocode/search?text=Brandenburger&boundary.circle.lon=13.449880&boundary.circle.lat=52.511180&boundary.circle.radius=200


  // https://api.openrouteservice.org/geocode/autocomplete?text=Toky&focus.point.lon=13.449880&focus.point.lat=52.511180
    public func autocomplete(text: String, focusPoint: CLLocationCoordinate2D?, callback: @escaping (Result<Geocode, Error>) -> ()) {
        var parameters: NetworkingClient.ParameterDict = ["text": text]
        if let focusPoint = focusPoint {
            parameters["focus.point.lon"] = "\(focusPoint.longitude)"
            parameters["focus.point.lat"] = "\(focusPoint.latitude)"
        }

        client.GET("geocode/autocomplete", parameters, type: Geocode.self) { (_, result) in
            callback(result)
        }
    }

  // directions:
  // https://api.openrouteservice.org/directions?api_key=&coordinates=8.34234,48.23424%7C8.34423,48.26424&profile=cycling-road&preference=recommended&format=json&units=km&language=de&geometry=true&geometry_format=geojson&instructions=true&instructions_format=text

    public func directions(start: CLLocationCoordinate2D, finish: CLLocationCoordinate2D, profile: Directions.Profile = .cyclingRegular, language: Directions.Language = .english, callback: @escaping (Result<Directions, Error>) -> ()) {

        let parameters: NetworkingClient.ParameterDict = [
            "coordinates": [start, finish].map({ "\($0.longitude),\($0.latitude)" }).joined(separator: "|"),
            "format": "json",
            "units": "km",
            "geometry": "true",
            "geometry_format": "geojson",
            "instructions": "true",
            "instructions_format": "text",
            "profile": profile.rawValue,
            "language": language.rawValue
        ]

        client.GET("/directions", parameters, type: Directions.self) { (_, result) in
            callback(result)
        }
    }
}
