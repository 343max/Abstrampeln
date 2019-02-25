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
    
    let directions = self.directions()
    mapView.setVisibleMapRect(directions.boundingBox.mapRect, animated: false)
    mapView.addOverlay(directions.routes.first!.geometry!.geodesicPolyline)
  }
}

