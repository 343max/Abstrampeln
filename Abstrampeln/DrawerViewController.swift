// Copyright Max von Webel. All Rights Reserved.

import UIKit

class DrawerViewController: UIViewController {
  class PullPillView: UIView {
    override func layoutSubviews() {
      super.layoutSubviews()
      
      layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
  }
  
  var pullPillView: PullPillView!
    
  override func viewDidLoad() {
    additionalSafeAreaInsets = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    
    pullPillView = PullPillView()
    pullPillView.translatesAutoresizingMaskIntoConstraints = false
    
    pullPillView.backgroundColor = UIColor(white: 1.0 / 3.0 * 2.0, alpha: 1)
    
    view.addSubview(pullPillView)

    pullPillView.widthAnchor.constraint(equalToConstant: 36).isActive = true
    pullPillView.heightAnchor.constraint(equalToConstant: 5).isActive = true
    pullPillView.topAnchor.constraint(equalTo: view.topAnchor, constant: 6).isActive = true
    pullPillView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: 0).isActive = true
    
    super.viewDidLoad()
  }
  
  override func viewLayoutMarginsDidChange() {
    super.viewLayoutMarginsDidChange()
  }
}
