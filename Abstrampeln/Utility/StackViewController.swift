// Copyright Max von Webel. All Rights Reserved.

import UIKit

extension UIViewController {
  var stackViewController: StackViewController? {
    return self as? StackViewController ?? parent?.stackViewController
  }
}

class StackViewController: UIViewController {
  private(set) var viewControllers: [UIViewController]
  var topViewController: UIViewController {
    return viewControllers.last!
  }

  init(viewController: UIViewController) {
    self.viewControllers = [viewController]
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    // this forces the child VCs safeAreaInset to be something a bit more sane
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

  func set(viewControllers: [UIViewController], animated: Bool) {
    let oldViewControllers = self.viewControllers

    let oldTop = oldViewControllers.last!
    let newTop = viewControllers.last!

    if oldTop == newTop {
      self.viewControllers = viewControllers
    } else if !animated {
      remove(viewController: oldTop)
      add(viewController: newTop)
      self.viewControllers = viewControllers
    } else {
      // animated
      self.viewControllers = viewControllers

      if oldViewControllers.contains(newTop) && !viewControllers.contains(oldTop) {
        // pop animation

        add(viewController: newTop)
        view.addSubview(oldTop.view)
        oldTop.view.backgroundColor = .white

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
          let bottom: CGFloat
          if let window = self.view.window {
            bottom = self.view.convert(CGPoint(x: 0, y: window.bounds.height), from: window).y
          } else {
            bottom = self.view.bounds.height
          }
          oldTop.view.frame = CGRect(x: 0, y: bottom, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: { (_) in
          self.remove(viewController: oldTop)
        })
      } else {
        // push animation

        add(viewController: newTop)
        let bottom: CGFloat
        if let window = view.window {
          bottom = view.convert(CGPoint(x: 0, y: window.bounds.height), from: window).y
        } else {
          bottom = view.bounds.height
        }
        newTop.view.frame = CGRect(x: 0, y: bottom, width: view.bounds.width, height: view.bounds.height)
        newTop.view.backgroundColor = .white
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
          newTop.view.frame = self.view.bounds
        }, completion: { (_) in
          newTop.view.backgroundColor = .clear
          self.remove(viewController: oldTop)
        })
      }
    }
  }

  func push(viewController: UIViewController, animated: Bool) {
    set(viewControllers: self.viewControllers + [viewController], animated: animated)
  }

  func popTopViewController(animated: Bool) {
    var viewControllers = self.viewControllers
    viewControllers.removeLast()
    set(viewControllers: viewControllers, animated: animated)
  }
}
