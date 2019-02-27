// Copyright Max von Webel. All Rights Reserved.

import UIKit
import MapKit
import OpenrouteService

class ViewController: UIViewController {
  let client = OpenrouteClient(networkingClient: OpenrouteNetworkingClient(apiKey: "5b3ce3597851110001cf62486db6049f89cb407c8c6ea9d687fc917c"))
  
  @IBOutlet weak var mapView: MKMapView!
  
  func directions() -> Directions {
    let url = Bundle.main.url(forResource: "Directions", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    return try! JSONDecoder().decode(Directions.self, from: data)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.delegate = self
  }
  
  func show(directions: Directions) {
    mapView.setVisibleMapRect(directions.boundingBox.mapRect, animated: false)
    mapView.addOverlay(directions.routes.first!.geometry!.polyline)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
//    let directions = self.directions()
//    show(directions: directions)
    
    let start = CLLocationCoordinate2D(latitude: 52.511180, longitude: 13.449880)
    client.autocomplete(text: "13 Esmarch", focusPoint: start).map { (geocodeRespone) -> CLLocationCoordinate2D in
      return geocodeRespone.features.first!.geometry.start
      }.mapPromise { (finish) -> Promise<Directions> in
        return self.client.directions(start: start, finish: finish)
      }.mainQueue.then { (directions) in
        self.show(directions: directions)
    }
  }
}

extension ViewController: MKMapViewDelegate {
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
