// Copyright Max von Webel. All Rights Reserved.

import UIKit
import MapKit
import OpenrouteService

class ViewController: UIViewController {
  let client = OpenrouteClient(networkingClient: OpenrouteNetworkingClient(apiKey: "5b3ce3597851110001cf62486db6049f89cb407c8c6ea9d687fc917c"))

  @IBOutlet weak var mapView: MKMapView!

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
    client.autocomplete(text: "13 Esmarch", focusPoint: start) { (result) in
      switch result {
      case .failure(let error):
        print(error)
        assert(false)
      case .success(let response):
        let finish = response.features.first!.geometry.start
        self.client.directions(start: start, finish: finish) { (result) in
          DispatchQueue.main.async {
            switch result {
            case .failure(let error):
              print(error)
              assert(false)
            case .success(let directions):
              self.show(directions: directions)
            }
          }
        }
      }
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
