// Copyright Max von Webel. All Rights Reserved.

import UIKit
import MapKit
import OpenrouteService

class ViewController: UIViewController {
  @IBOutlet weak var mapView: MKMapView!
  
  func directions() -> Directions {
    let url = Bundle.main.url(forResource: "Directions", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    return try! JSONDecoder().decode(Directions.self, from: data)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.delegate = self
    
    let directions = self.directions()
    mapView.setVisibleMapRect(directions.boundingBox.mapRect, animated: false)
    mapView.addOverlay(directions.routes.first!.geometry!.polyline)
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
