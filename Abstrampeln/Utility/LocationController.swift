// Copyright Max von Webel. All Rights Reserved.

import Foundation
import CoreLocation
import Promise

class LocationController: NSObject {
  private let locationManager = CLLocationManager()
  
  private(set) lazy var locationPromise = Promise<[CLLocation]>(multiCall: true)
  var latestLocations: [CLLocation] = []
  
  override init() {
    super.init()
    locationManager.delegate = self
  }
  
  func startUpdatingLocation() {
    let status = CLLocationManager.authorizationStatus()
    if status == .notDetermined {
      locationManager.requestAlwaysAuthorization()
    } else if status == .authorizedWhenInUse || status == .authorizedAlways {
      locationManager.startUpdatingLocation()
    }
  }
}

extension LocationController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedAlways || status == .authorizedWhenInUse {
      locationManager.startUpdatingLocation()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    latestLocations = locations
    locationPromise.fulfill(locations)
  }
}
