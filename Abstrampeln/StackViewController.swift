// Copyright Max von Webel. All Rights Reserved.

import UIKit

extension UIViewController {
  var stackViewController: StackViewController? {
    get {
      return self as? StackViewController ?? parent?.stackViewController
    }
  }
}

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
    
    add(viewController: topViewController)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    topViewController.view.frame = view.bounds
  }
  
  private func add(viewController: UIViewController) {
    addChild(viewController)
    viewController.view.frame = view.bounds
    view.addSubview(viewController.view)
  }
  
  private func remove(viewController: UIViewController) {
    viewController.view.removeFromSuperview()
    viewController.removeFromParent()
  }
  
  func push(viewController: UIViewController, animated: Bool) {
    if animated {
      add(viewController: viewController)
      let bottom: CGFloat
      if let window = view.window {
        bottom = view.convert(CGPoint(x: 0, y: window.bounds.height), from: window).y
      } else {
        bottom = view.bounds.height
      }
      viewController.view.frame = CGRect(x: 0, y: bottom, width: view.bounds.width, height: view.bounds.height)
      UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
        viewController.view.frame = self.view.bounds
      }) { (complete) in
        self.remove(viewController: self.topViewController)
        self.viewControllers.append(viewController)
      }
    } else {
      remove(viewController: topViewController)
      viewControllers.append(viewController)
      add(viewController: viewController)
    }
  }
}
