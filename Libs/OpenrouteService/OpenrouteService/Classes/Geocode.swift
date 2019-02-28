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
      public let source_id: String
      public let name: String
      public let housenumber: String?
      public let street: String?
      public let postalcode: String?
      public let distance: Float?
      public let country: String?
      public let country_gid: String?
      public let country_a: String?
      public let region: String?
      public let region_gid: String?
      public let county: String?
      public let county_gid: String?
      public let locality: String?
      public let locality_gid: String?
      public let borough: String?
      public let borough_gid: String?
      public let neighbourhood: String?
      public let neighbourhood_gid: String?
      public let continent: String?
      public let continent_gid: String?
      public let label: String
    }
  }
  
}
