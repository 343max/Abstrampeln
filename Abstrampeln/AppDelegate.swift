// Copyright Max von Webel. All Rights Reserved.

import UIKit
import Pulley
import OpenrouteService

class AppController {
  static let shared = AppController(openrouteClient: OpenrouteClient(networkingClient: OpenrouteNetworkingClient(apiKey: "5b3ce3597851110001cf62486db6049f89cb407c8c6ea9d687fc917c")))
  let openrouteClient: OpenrouteClient
  let locationController = LocationController()
  let dispatcher = SignalDispatcher()
  let directionsController: DirectionsController

  init(openrouteClient: OpenrouteClient) {
    self.openrouteClient = openrouteClient
    self.directionsController = DirectionsController(dispatcher: dispatcher, locationController: locationController, openrouteClient: openrouteClient)
  }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  weak var hierarchyContainingViewController: HierarchyContainingViewController?
  weak var pulleyViewController: PulleyViewController?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)

    let mapVC = MapViewController(nibName: nil, bundle: nil)
    let searchVC = SearchViewController(nibName: nil, bundle: nil)
    
    let hierarchyContainingViewController: HierarchyContainingViewController

    if window.traitCollection.userInterfaceIdiom == .phone {
      let stackVC = StackViewController(viewController: searchVC)
      let pulleyVC = PullingViewController(contentViewController: mapVC, drawerViewController: stackVC)
      hierarchyContainingViewController = stackVC
      self.pulleyViewController = pulleyVC
      window.rootViewController = pulleyVC
    } else {
      let navigationController = UINavigationController(rootViewController: searchVC)
      navigationController.navigationBar.isTranslucent = true
      navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
      navigationController.navigationBar.shadowImage = UIImage()
      navigationController.delegate = self
      hierarchyContainingViewController = navigationController
      let splitVC = OverlappingDrawerViewController(contentViewController: mapVC,
                                                    drawerViewController: navigationController)
      window.rootViewController = splitVC
    }
    
    self.hierarchyContainingViewController = hierarchyContainingViewController

    self.window = window
    window.makeKeyAndVisible()
    self.pulleyViewController?.setDrawerPosition(position: .partiallyRevealed, animated: false)

    let dispatcher = AppController.shared.dispatcher
    RecentSuggestionsSource.collector.register(dispatcher: dispatcher)
    dispatcher.register(listener: self)

    return true
  }

}

extension AppDelegate: DirectionsControllerDestinationListener {
  func destinationDidChange(_ destination: Location?) {
    guard let destination = destination else { return }

    pulleyViewController?.setDrawerPosition(position: .partiallyRevealed, animated: true)

    let vc = RouteViewController(destination: destination)
    hierarchyContainingViewController?.pushViewController(vc, animated: true)
  }
}

extension AppDelegate: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    navigationController.setNavigationBarHidden(navigationController.viewControllers.count == 1, animated: animated)
  }
}
