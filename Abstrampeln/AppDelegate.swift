// Copyright Max von Webel. All Rights Reserved.

import UIKit
import Pulley
import OpenrouteService

class AppController {
  static let shared = AppController(openrouteClient: OpenrouteClient(networkingClient: OpenrouteNetworkingClient(apiKey: "5b3ce3597851110001cf62486db6049f89cb407c8c6ea9d687fc917c")))
  let openrouteClient: OpenrouteClient
  let locationController = LocationController()
  let dispatcher = SignalDispatcher()
  
  init(openrouteClient: OpenrouteClient) {
    self.openrouteClient = openrouteClient
  }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    let mapVC = MapViewController(nibName: nil, bundle: nil)
    let searchVC = SearchViewController(nibName: nil, bundle: nil)

    let pulleyVC = PulleyViewController(contentViewController: mapVC, drawerViewController: searchVC)
    
    window.rootViewController = pulleyVC

    self.window = window
    window.makeKeyAndVisible()

    pulleyVC.setDrawerPosition(position: .partiallyRevealed, animated: false)
    
    RecentSuggestionsSource.collector.register(dispatcher: AppController.shared.dispatcher)

    return true
  }

}

