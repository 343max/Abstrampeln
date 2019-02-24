// Copyright Max von Webel. All Rights Reserved.

import Foundation

enum Units: String {
  case meters = "m"
  case kilometers = "km"
  case miles = "mi"
}

extension Directions {
  enum Profile: String {
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
  
  enum Preferences: String {
    case recommended = "recommended"
    case fastest = "fastest"
    case shortest = "shortest"
  }
  
  enum Language: String {
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
