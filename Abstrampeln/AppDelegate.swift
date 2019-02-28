// Copyright Max von Webel. All Rights Reserved.

import UIKit
import Pulley

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

    return true
  }

}

