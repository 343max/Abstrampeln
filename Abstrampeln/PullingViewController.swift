// Copyright Max von Webel. All Rights Reserved.

import Foundation
import Pulley

class PullingViewController: PulleyViewController {
  private var backgroundEffect: UIBlurEffect.Style = .extraLight {
    didSet {
      self.drawerBackgroundVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: backgroundEffect))
    }
  }
  
  private func updateBackgroundEffect() {
    backgroundEffect = traitCollection.userInterfaceStyle == .dark ? .dark : .extraLight
  }
  
  override func viewSafeAreaInsetsDidChange() {
    super.viewSafeAreaInsetsDidChange()

    // private kPulleyDefaultPartialRevealHeight
    primaryContentViewController.additionalSafeAreaInsets.bottom = 264 - view.safeAreaInsets.bottom
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    updateBackgroundEffect()
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    
    updateBackgroundEffect()
  }
}
