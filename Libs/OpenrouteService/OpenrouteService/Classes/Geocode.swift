// Copyright Max von Webel. All Rights Reserved.

import Foundation
import CoreLocation

public struct Geocode: Decodable {
  public let features: [Feature]
  public let bbox: BoundingBox
}

extension Geocode {
  public struct Feature: Decodable {
    public let type: FeatureType
    public let geometry: Geometry
    public let properties: Properties

    public enum FeatureType: String, Decodable {
      case feature = "Feature"
    }

    public struct Properties: Decodable {
      public let id: String
      public let gid: String
      public let layer: String
      public let source: String
      public let sourceId: String
      public let name: String
      public let housenumber: String?
      public let street: String?
      public let postalcode: String?
      public let distance: Float?
      public let country: String?
      public let countryGid: String?
      public let countryA: String?
      public let region: String?
      public let regionGid: String?
      public let county: String?
      public let countyGid: String?
      public let locality: String?
      public let localityGid: String?
      public let borough: String?
      public let boroughGid: String?
      public let neighbourhood: String?
      public let neighbourhoodGid: String?
      public let continent: String?
      public let continentGid: String?
      public let label: String
    }
  }

}
