// Copyright Max von Webel. All Rights Reserved.

import UIKit

class StackViewController: UIViewController {
  var viewControllers: [UIViewController]
  var topViewController: UIViewController {
    get {
      return viewControllers.last!
    }
  }
  
  init(viewController: UIViewController) {
    self.viewControllers = [viewController]
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    // this prevents the child VCs safeAreaInset to be something a bit more sane
    view = UIView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let vc = topViewController
    addChild(vc)
    vc.view.frame = view.bounds
    view.addSubview(vc.view)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    topViewController.view.frame = view.bounds
  }
}
