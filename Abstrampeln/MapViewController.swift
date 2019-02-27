// Copyright Max von Webel. All Rights Reserved.

import UIKit
import CoreLocation
import MapKit
import OpenrouteService

class MapViewController: UIViewController {
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var searchField: UITextField!
  
  let locationManager = CLLocationManager()
  
  var latestLocation: CLLocation? {
    didSet {
      if let latestLocation = latestLocation {
        update(location: latestLocation)
      }
    }
  }
  
  var destination: CLLocationCoordinate2D? {
    didSet {
      update(destination: destination)
    }
  }
  
  var userInteracted = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.delegate = self
    mapView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:))))
    
    searchField.layer.shadowColor = UIColor.black.cgColor
    searchField.layer.shadowOpacity = 0.1
    searchField.layer.shadowRadius = 5
    searchField.layer.shadowOffset = CGSize(width: 0, height: 4)
    
    locationManager.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let status = CLLocationManager.authorizationStatus()
    if status == .notDetermined {
      locationManager.requestAlwaysAuthorization()
    } else if status == .authorizedWhenInUse || status == .authorizedAlways {
      locationManager.startUpdatingLocation()
    }
  }
  
  func update(location: CLLocation) {
    if userInteracted == false {
      let span = CLLocationDistance(1000)
      let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: span, longitudinalMeters: span)
      mapView.setRegion(region, animated: true)
    }
  }
  
  func update(destination: CLLocationCoordinate2D?) {
    
  }
}

extension MapViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedAlways || status == .authorizedWhenInUse {
      locationManager.startUpdatingLocation()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    latestLocation = locations.first
  }
}

extension MapViewController: MKMapViewDelegate {
  func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
    userInteracted = true
  }
}

extension MapViewController {
  @objc func didLongPress(_ gr: UILongPressGestureRecognizer) {
    if gr.state != .began {
      return
    }
    
    let location = gr.location(in: mapView)
    let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
    
    let pin = MKPointAnnotation()
    pin.coordinate = coordinate
    mapView.addAnnotation(pin)
  }
}
