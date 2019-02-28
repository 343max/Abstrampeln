// Copyright Max von Webel. All Rights Reserved.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    let mapViewController = MapViewController(nibName: nil, bundle: nil)
    window.rootViewController = mapViewController
    
    self.window = window
    window.makeKeyAndVisible()
    
    return true
  }

}

