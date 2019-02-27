// Copyright Max von Webel. All Rights Reserved.

import Foundation
import CoreLocation

enum Units: String {
  case meters = "m"
  case kilometers = "km"
  case miles = "mi"
}

public struct Geometry: Decodable {
  public let type: GeometryType
  public let coordinates: [CLLocationCoordinate2D]
  
  public enum CodingKeys: String, CodingKey {
    case type = "type"
    case coordinates = "coordinates"
  }
  
  public enum GeometryType: String, Decodable {
    case point = "Point"
    case lineString = "LineString"
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.type = try container.decode(GeometryType.self, forKey: CodingKeys.type)
    if self.type == .point {
      self.coordinates = try [container.decode(CLLocationCoordinate2D.self, forKey: CodingKeys.coordinates)]
    } else {
      self.coordinates = try container.decode([CLLocationCoordinate2D].self, forKey: CodingKeys.coordinates)
    }
  }
}

extension Geometry {
  public var start: CLLocationCoordinate2D {
    get {
      return coordinates.first!
    }
  }
}

extension Directions {
  public enum Profile: String {
    case drivingCar = "driving-car"
    case drivingHeavyGoodsVehicle = "driving-hvg"
    case cyclingRegular = "cycling-regular"
    case cyclingRoad = "cycling-road"
    case cyclingSafe = "cycling-safe"
    case cyclingMountain = "cycling-mountain"
    case cyclingElectric = "cycling-electric"
    case footWalking = "foot-walking"
    case footHiking = "foot-hiking"
    case wheelchair = "wheelchair"
  }
  
  public enum Preferences: String {
    case recommended = "recommended"
    case fastest = "fastest"
    case shortest = "shortest"
  }
  
  public enum Language: String {
    case simplifiedChinese = "zh-CN"
    case german = "de"
    case english = "en"
    case spanish = "es"
    case russian = "ru"
    case french = "fr"
    case italian = "it"
    case dutch = "nl"
    case portugeese = "pt"
    case greek = "gr"
    case hungarian = "hu"
  }
}
