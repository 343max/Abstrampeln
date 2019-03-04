// Copyright Max von Webel. All Rights Reserved.

import UIKit
import CoreLocation
import MapKit
import OpenrouteService

class MapViewController: UIViewController {
  weak var mapView: MKMapView!
    
  var directions: Directions? {
    didSet {
      if let directions = directions {
        let mapRect = directions.boundingBox.mapRect.insetBy(dx: -4000, dy: -4000).offsetBy(dx: 0, dy: 4000)
        mapView.setVisibleMapRect(mapRect, animated: true)
      }
      update(directions: directions)
    }
  }
  var directionsOverlay: MKOverlay? {
    willSet {
      if let overlay = directionsOverlay {
        mapView.removeOverlay(overlay)
      }
    }
    
    didSet {
      if let overlay = directionsOverlay {
        mapView.addOverlay(overlay)
      }
    }
  }
  
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
  
  var destinationPin: MKPointAnnotation? {
    willSet {
      if let pin = destinationPin {
        mapView.removeAnnotation(pin)
      }
    }
    
    didSet {
      if let pin = destinationPin {
        mapView.addAnnotation(pin)
      }
    }
  }
  
  var userInteracted = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let mapView = MKMapView(frame: view.bounds)
    mapView.showsUserLocation = true
    mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    mapView.delegate = self
    mapView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:))))
    self.mapView = mapView
    view.addSubview(mapView)
    
    AppController.shared.locationController.locationPromise.then { [weak self] (locations) in
      guard let self = self else { return }
      
      self.latestLocation = locations.first!
    }
    
    AppController.shared.dispatcher.register(listener: self)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    AppController.shared.locationController.startUpdatingLocation()
  }
  
  func update(location: CLLocation) {
    if userInteracted == false {
      let span = CLLocationDistance(1000)
      let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: span, longitudinalMeters: span)
      mapView.setRegion(region, animated: true)
    }
  }
  
  func update(destination: CLLocationCoordinate2D?) {
    guard let destination = destination else {
      destinationPin = nil
      return
    }
    
    let pin = MKPointAnnotation()
    pin.coordinate = destination
    destinationPin = pin
  }
  
  func update(directions: Directions?) {
    guard let directions = directions else {
      directionsOverlay = nil
      return
    }
    
    directionsOverlay = directions.routes.first!.geometry!.polyline
  }
  
  func getDirections(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
    AppController.shared.openrouteClient.directions(start: from, finish: to).mainQueue.then { [weak self] (directions) in
      guard let self = self else { return }
      self.directions = directions
    }
  }
}

extension MapViewController: MKMapViewDelegate {
  func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
    userInteracted = true
  }
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    if let polyline = overlay as? MKPolyline {
      let testlineRenderer = MKPolylineRenderer(polyline: polyline)
      testlineRenderer.strokeColor = mapView.tintColor
      testlineRenderer.lineWidth = 3.0
      return testlineRenderer
    }

    fatalError()
  }
}

extension MapViewController {
  @objc func didLongPress(_ gr: UILongPressGestureRecognizer) {
    if gr.state != .began {
      return
    }
    
    let location = gr.location(in: mapView)
    let destination = mapView.convert(location, toCoordinateFrom: mapView)
    
    self.destination = destination
    
    if let from = latestLocation?.coordinate {
      getDirections(from: from, to: destination)
    }
  }
}

extension MapViewController: SelectedSuggestionListener {
  func didSelect(suggestion: SearchResultItem) {
    if let from = latestLocation?.coordinate {
      getDirections(from: from, to: suggestion.coordinate)
    }
  }
}
