// Copyright Max von Webel. All Rights Reserved.

import UIKit
import MapKit

protocol DarkMode {
  func setDarkMode(on: Bool)
}

extension MKMapView: DarkMode {
  func setDarkMode(on: Bool) {
    _setShowsNightMode(on)
  }
}

extension UIVisualEffectView: DarkMode {
  func setDarkMode(on: Bool) {
    effect = UIBlurEffect(style: on ? .dark : .extraLight)
  }
}

extension UIView {
  func walkDarkMode(on: Bool) {
    if let view = self as? DarkMode {
      view.setDarkMode(on: on)
    }
    
    subviews.forEach { $0.walkDarkMode(on: on) }
  }
}
